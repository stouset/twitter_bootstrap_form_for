require 'twitter_bootstrap_form_for'
require 'action_view/helpers'

class TwitterBootstrapFormFor::FormBuilder < ActionView::Helpers::FormBuilder
  include TwitterBootstrapFormFor::FormHelpers

  attr_reader :template
  attr_reader :object
  attr_reader :object_name

  INPUTS = [
    :select,
    *ActionView::Helpers::FormBuilder.instance_methods.grep(%r{
      _(area|field|select)$ # all area, field, and select methods
    }mx).map(&:to_sym)
  ]

  INPUTS.delete(:hidden_field)

  TOGGLES = [
    :check_box,
    :radio_button,
  ]

  #
  # Wraps the contents of the block passed in a fieldset with optional
  # +legend+ text.
  #
  def inputs(legend = nil, options = {}, &block)
    template.content_tag(:fieldset, options) do
      template.concat template.content_tag(:legend, legend) unless legend.nil?
      block.call
    end
  end

  #
  # Wraps groups of toggles (radio buttons, checkboxes) with a single label
  # and the appropriate markup. All toggle buttons should be rendered
  # inside of here, and will not look correct unless they are.
  #
  def toggles(label = nil, &block)
    template.content_tag(:div, :class => 'clearfix') do
      template.concat template.content_tag(:label, label)
      template.concat template.content_tag(:div, :class => "input") {
        template.content_tag(:ul, :class => "inputs-list") { block.call }
      }
    end
  end

  #
  # Wraps action buttons into their own styled container.
  #
  def actions(&block)
    template.content_tag(:div, :class => 'actions', &block)
  end

  #
  # Renders a submit tag with default classes to style it as a primary form
  # button.
  #
  def submit(value = nil, options = {})
    options[:class] ||= 'btn primary'

    super value, options
  end

  #
  # Creates bootstrap wrapping before yielding a plain old rails builder
  # to the supplied block.
  #
  def inline_inputs(label = nil)
    template.content_tag(:div, :class => 'clearfix') do
      template.concat template.content_tag(:label, label)
      template.concat template.content_tag(:div, :class => "input") {
        inline_options = @options.merge(:builder => ActionView::Helpers::FormBuilder)
        yield(ActionView::Helpers::FormBuilder.new @object_name, @object, @template, inline_options, @proc) if block_given?
      }
    end
  end

  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      options  = args.extract_options!
      label    = args.first.nil? ? '' : args.shift
      classes  = [ 'input' ]
      classes << ('input-' + options.delete(:add_on).to_s) if options[:add_on]

      self.div_wrapper(attribute) do
        template.concat self.label(attribute, label) if label
        template.concat template.content_tag(:div, :class => classes.join(' ')) {
          template.concat super(attribute, *(args << options))
          template.concat error_span(attribute)
          block.call if block.present?
        }
      end
    end
  end

  TOGGLES.each do |toggle|
    define_method toggle do |attribute, *args, &block|
      label       = args.first.nil? ? '' : args.shift
      target      = self.object_name.to_s + '_' + attribute.to_s
      label_attrs = toggle == :check_box ? { :for => target } : {}

      template.content_tag(:li) do
        template.concat template.content_tag(:label, label_attrs) {
          template.concat super(attribute, *args)
          template.concat ' ' # give the input and span some room
          template.concat template.content_tag(:span, label)
        }
      end
    end
  end

  protected

  #
  # Wraps the contents of +block+ inside a +tag+ with an appropriate class and
  # id for the object's +attribute+. HTML options can be overridden by passing
  # an +options+ hash.
  #
  def div_wrapper(attribute, options = {}, &block)
    options[:id]    = _wrapper_id      attribute, options[:id]
    options[:class] = _wrapper_classes attribute, options[:class], 'clearfix'

    template.content_tag :div, options, &block
  end

  def error_span(attribute, options = {})
    options[:class] ||= 'help-inline'

    template.content_tag(
      :span, self.errors_for(attribute),
      :class => options[:class]
    ) if self.errors_on?(attribute)
  end

  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  def errors_for(attribute)
    self.object.errors[attribute].try(:join, ', ')
  end

  private

  #
  # Returns an HTML id to uniquely identify the markup around an input field.
  # If a +default+ is provided, it uses that one instead.
  #
  def _wrapper_id(attribute, default = nil)
    default || [
      _object_name + _object_index,
      _attribute_name(attribute),
      'input'
     ].join('_')
  end

  #
  # Returns any classes necessary for the wrapper div around fields for
  # +attribute+, such as 'errors' if any errors are present on the attribute.
  # This merges any +classes+ passed in.
  #
  def _wrapper_classes(attribute, *classes)
    classes.compact.tap do |klasses|
      klasses.push 'error' if self.errors_on?(attribute)
    end.join(' ')
  end

  def _attribute_name(attribute)
    attribute.to_s.gsub(/[\?\/\-]$/, '')
  end

  def _object_name
    self.object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def _object_index
    case
      when options.has_key?(:index) then options[:index]
      when defined?(@auto_index)    then @auto_index
      else                               nil
    end.to_s
  end
end
