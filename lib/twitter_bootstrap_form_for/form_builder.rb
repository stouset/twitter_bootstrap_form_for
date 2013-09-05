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
  def fieldset(legend = nil, options = {})
    template.content_tag(:fieldset, options) do
      template.concat template.content_tag(:legend, legend) unless legend.nil?
      yield
    end
  end

  #
  # Wraps action buttons into their own styled container.
  #
  def actions(&block)
    template.content_tag(:div, :class => 'form-actions', &block)
  end

  #
  # Attaches a label to the inputs rendered inside of the block passed to it.
  # Associates the label with the input for the +attribute+ given. If +text+
  #is passed, uses that as the text for the label; otherwise humanizes the
  # +attribute+ name.
  #
  def label(attribute, text = '', options = {}, &block)
    text, attribute = attribute, nil if attribute.kind_of? String

    options = { :class => 'control-label' }.merge(options)
    id      = _wrapper_id      attribute, 'control_group'
    classes = _wrapper_classes attribute, 'control-group'

    template.content_tag(:div, :id => id, :class => classes) do
      template.concat case
        when attribute && text then super(attribute, text, options, &nil)
        when attribute         then super(attribute, nil,  options, &nil)
        when text              then template.label_tag(nil, text, options, &nil)
      end

      template.concat template.content_tag(:div, :class => 'controls') {
        template.with_output_buffer {
          template.fields_for(
            self.object_name,
            self.object,
            self.options.merge(:builder => TwitterBootstrapFormFor::FormControls),
            &block
          )
        }
      }
    end
  end

  #
  # Renders a button with default classes to style it as a form button.
  #
  def button(value = nil, options = {})
    super value, {
      :type  => 'button',
      :class => 'btn',
    }.merge(options)
  end

  #
  # Renders a submit tag with default classes to style it as a primary form
  # button.
  #
  def submit(value = nil, options = {})
    self.button value, {
      :type  => 'submit',
      :class => 'btn btn-primary',
    }.merge(options)
  end

  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      options = args.extract_options!
      text    = args.any? ? args.shift : ''

      self.label(attribute, text) do |builder|
        builder.send(input, attribute, *(args << options), &block)
      end
    end
  end

  TOGGLES.each do |toggle|
    define_method input do |attribute, *args, &block|
      template.with_output_buffer do
        self.fields_for(
          self.object_name,
          self.object,
          self.options.merge(:builder => TwitterBootstrapFormFor::FormControls)
        ) {|controls| controls.send(input, *args, &block) }
      end
    end
  end

  protected

  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  private

  #
  # Returns an HTML id to uniquely identify the markup around an input field.
  #
  def _wrapper_id(attribute, suffix = nil)
    [
      _object_name + _object_index,
      _attribute_name(attribute),
      suffix,
     ].compact.join('_') if attribute
  end

  #
  # Returns any classes necessary for the wrapper div around fields for
  # +attribute+, such as 'errors' if any errors are present on the attribute.
  # Merges any +classes+ passed in.
  #
  def _wrapper_classes(attribute, *classes)
    classes.push 'error' if attribute and self.errors_on?(attribute)
    classes.compact.join(' ')
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

class TwitterBootstrapFormFor::FormControls < ActionView::Helpers::FormBuilder
  attr_reader :template
  attr_reader :object
  attr_reader :object_name

  TwitterBootstrapFormFor::FormBuilder::INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      options = args.extract_options!
      add_on  = options.delete(:add_on)
      tag     = add_on.present? ? :div : :span
      classes = [ "input", add_on ].compact.join('-')

      template.content_tag(tag, :class => classes) do
        template.concat super attribute, *(args << options)
        template.concat self.error_span(attribute) if self.errors_on?(attribute)
        block.call if block.present?
      end
    end
  end

  def check_box(attribute, text, options = {}, checked_value = 1, unchecked_value = 0)
    klasses = _merge_classes 'checkbox', options.delete(:inline) && 'inline'

    input = super(attribute, options, checked_value, unchecked_value)
    title = text || value.to_s.humanize.titleize
    extra = block_given? ? yield : ''

    self.label(attribute, input + title + extra, :class => klasses)
  end

  def radio_button(attribute, value, text = nil, options = {})
    klasses = _merge_classes 'radio', options.delete(:inline) && 'inline'

    input = super(attribute, value, options)
    title = text || value.to_s.humanize.titleize
    extra = block_given? ? yield : ''

    self.label(attribute, input + title + extra, :class => klasses)
  end

  protected

  def error_span(attribute, options = {})
    options[:class] = _merge_classes options[:class], 'help-inline'

    template.content_tag :span,
      self.errors_for(attribute),
      :class => options[:class]
  end

  def errors_for(attribute)
    self.object.errors[attribute].try(:join, ', ')
  end

  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  private

  def _merge_classes(string, *classes)
    string.to_s.split(' ').push(*classes.compact).join(' ')
  end
end
