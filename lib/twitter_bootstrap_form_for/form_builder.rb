require 'twitter_bootstrap_form_for'
require 'action_view/helpers'

class TwitterBootstrapFormFor::FormBuilder < ActionView::Helpers::FormBuilder

  cattr_accessor :label_class, :div_class, :div_labelless_class, :action_class

  self.label_class = 'col-lg-2 control-label'
  self.div_class = 'col-lg-10'
  self.div_labelless_class = 'col-lg-offset-2 col-lg-10'
  self.action_class = 'col-lg-offset-2 col-lg-10'

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
  def toggles(*args, &block)

    options  = args.extract_options!
    label    = args.first.nil? ? '' : args.shift

    # Pull out the label class
    label_class = options[:label_class] || @options[:default_label_class]
    options.delete :label_class

    # This set of toggles will conform to either the stacked or inline style
    options[:style] ||= @options[:default_toggle_style]
    raise "Invalid style passed to toggles: #{options[:style].to_s}. Must be :stacked or :inline" unless [:stacked, :inline].include?(options[:style])
    @toggles_style = options[:style]

    # Not necessary, but makes it convenient if we are using the horizontal form style
    template.content_tag :div, :class => 'form-group' do
      template.concat self.label(nil, label, :class => label_class) if label.present?

			if @options[:layout] == :horizontal
        html_class = label.present? ? @options[:default_div_class] : self.div_labelless_class
      end
      template.concat template.content_tag(:div, :class => html_class) { block.call }
    end
  end

  #
  # Wraps action buttons into their own styled container.
  #
  def actions(*args, &block)
    if @options[:layout] == :horizontal
      options  = args.extract_options!
      options[:class] ||= self.action_class
      self.div_wrapper(:div, :class => 'form-group') do
        template.content_tag(:div, :class => options[:class], &block)
      end
    else
      block.call
    end
  end

  #
  # Renders a submit tag with default classes to style it as a primary form
  # button.
  #
  def submit(value = nil, options = {})
    options[:class] ||= 'btn btn-primary'

    super value, options
  end

  #
  # Creates bootstrap wrapping before yielding a plain old rails builder
  # to the supplied block.
  #
  def inline(label = nil, &block)
    template.content_tag(:div) do
      template.concat template.content_tag(:label, label) if label.present?
      template.concat template.content_tag(:div, :class => 'input') {
        template.content_tag(:div, :class => 'inline-inputs') do
          template.fields_for(
            self.object_name,
            self.object,
            self.options.merge(:builder => ActionView::Helpers::FormBuilder),
            &block
          )
        end
      }
    end
  end

  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|

      options  = args.extract_options!
      label    = args.first.nil? ? '' : args.shift
      label_class = options[:label_class] || @options[:default_label_class]
      options.delete :label_class

      self.div_wrapper(attribute, :class => 'form-group') do
        template.concat self.label(attribute, label, :class => label_class) if label

        options[:class] ||= 'form-control'
        classes = []
        if options[:div_class].present?
          classes << options[:div_class]
        elsif @options[:default_div_class].present?
          classes <<  @options[:default_div_class]
        end
        classes << ('input-' + (options.delete(:add_on) || :append).to_s) if block.present?
        template.concat template.content_tag(:div, :class => classes.join(' ')) {
          block.call if block.present? and classes.include?('input-prepend')
          input_group = options.delete(:input_group)
          tag = super(attribute, *(args << options))
          if input_group
            template.concat template.content_tag(:div, :class => 'input-group' + (input == :select ? ' select2-bootstrap-append' : '')) {
              template.concat tag
              template.concat template.content_tag(:span, :class => (input_group =~ /class[^=]*=['"]*[^'"=>]*btn[ '"]/) ? 'input-group-btn' : 'input-group-addon') {
                template.concat input_group
              }
            }
          else
            template.concat tag
          end
          template.concat error_span(attribute)
          block.call if block.present? and classes.include?('input-append')
        }
      end
    end
  end

  TOGGLES.each do |toggle|
    define_method toggle do |attribute, *args, &block|
      
      label       = args.first.nil? ? '' : args.shift
      target      = self.object_name.to_s + '_' + attribute.to_s
      label_attrs = toggle == :check_box ? { :for => target } : {}

      template.concat template.content_tag(:label, label_attrs) {
        template.concat super(attribute, *args)
        template.concat ' ' # give the input and span some room
        template.concat template.content_tag(:span, label)
      }
      if toggle == :check_box
        template.concat template.content_tag(:div, :class => "has-error") {
          template.concat error_span(attribute)
        } if errors_on?(attribute)
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
    options[:class] = _wrapper_classes attribute, options[:class]

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
      klasses.push 'has-error' if self.errors_on?(attribute)
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
