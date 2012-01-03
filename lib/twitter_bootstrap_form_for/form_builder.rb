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
    div_wrapper_with_label(label) do
      template.content_tag(:ul, :class => "inputs-list") { block.call }
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
  # Creates bootstrap wrapping before yielding this builder instance.
  # Yielding this instance is not necessary, but present for backwards compatability.
  # 
  #
  def inline(label = nil, &block)
    div_wrapper_with_label(label) do
      template.content_tag(:div, :class => 'inline-inputs') do
        render_inline do
          yield(self)
        end
      end
    end
  end

  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      options  = args.extract_options!
      label    = args.first.nil? ? '' : args.shift
      classes  = [ 'input' ]
      classes << ('input-' + options.delete(:add_on).to_s) if options[:add_on]
      
      self.div_wrapper_with_label(label,attribute,:input_wrapper_class=>classes.join(' ')) do
        template.concat super(attribute, *(args << options))
        block.call if block.present?
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
  # If no attribute is given, simply wraps contents in a clearfix container
  #
  def div_wrapper(attribute=nil,options = {}, &block)
    
    # call the block before determining the class to see if there are
    # errors for ANY of the attributes in this wrapper
    block_content = template.capture(&block)
    
    options[:class] = _wrapper_classes options[:class], 'clearfix'
    # can clear the attribute list now that we've calculated the class name
    _initialize_attribute_list
    
    options[:id]    = _wrapper_id      attribute, options[:id] if attribute
    
    template.content_tag :div, block_content, options
    
  end
  
  #
  # Wraps the field in the necessary wraper ('input' by default) and adds the label
  # If we are rendering inline, it simply yields
  #
  def div_wrapper_with_label(label,attribute=nil, options={}, &block)
    
    # add to the list of attributes we are using for this wrapper
    @attribute_list ||= []
    @attribute_list << attribute if attribute.present?
    
    if render_inline
      yield
    else
      input_wrapper_class = options.delete(:input_wrapper_class) || 'input'
      div_wrapper(attribute,options) do
        if attribute
          template.concat self.label(attribute, label)
        else
          template.concat template.content_tag(:label, label) if label.present?
        end
        block_content = template.capture(&block)
        block_content << error_span
        template.concat(template.content_tag(:div,block_content,:class=>input_wrapper_class))
      end
    end
      
  end
  
  def render_inline(&block)
    if block.present?
      @render_inline = true
      yield
      @render_inline = false
    else
      @render_inline
    end
  end

  def error_span(options = {})
    options[:class] ||= 'help-inline'

    if errors?
      template.content_tag(
        :span, attribute_error_messages.join(', '),
        :class => options[:class]
      ) 
    else
      ''
    end
  end
  
  def errors?
    @attribute_list.detect{|att| errors_on?(att)}
  end
  
  def attribute_error_messages
    if @attribute_list.length > 1
      @attribute_list.collect{|att| full_errors_for(att)}.flatten.compact
    elsif @attribute_list.length == 1
      errors_for(@attribute_list.first)
    else
      []
    end
  end
  
  def full_errors_for(attribute)
    if errors_on?(attribute)
      attr_name = attribute.to_s.gsub('.', '_').humanize
      attr_name = self.object.class.base_class.human_attribute_name(attribute, :default => attr_name)
      message = errors_for(attribute).join(', ')
    
      I18n.t(:"errors.format", {
        :default   => "%{attribute} %{message}",
        :attribute => attr_name,
        :message   => message
      })
    end
  end
  
  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  def errors_for(attribute)
    errors_on?(attribute) ? self.object.errors[attribute] : []
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
  def _wrapper_classes(*classes)
    classes.compact.tap do |klasses|
      klasses.push 'error' if errors?
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
  
  def _initialize_attribute_list
    @attribute_list = []
  end
end
