require 'semantic_form_for'

class SemanticFormFor::FormBuilder < ActionView::Helpers::FormBuilder
  include SemanticFormFor::FormHelpers
  
  attr_reader :template
  attr_reader :object
  attr_reader :object_name
  
  FIELDSETS = [ :inputs, :buttons ]
  
  INPUTS = [
    *ActionView::Helpers::FormBuilder.instance_methods.grep(%r{_box$}),
    *ActionView::Helpers::FormBuilder.instance_methods.grep(%r{_field$}),
    *ActionView::Helpers::FormBuilder.instance_methods.grep(%r{_select$}),
    :select
  ]
                
  BUTTONS = [ :submit ]
  
  FIELDSETS.each do |set|
    define_method set do |text = nil, &block|
      template.capture_haml do
        template.haml_tag :fieldset, :class => set do
          template.haml_tag(:legend, text) if text
          template.haml_tag(:ol, &block)
        end
      end
    end
  end
  
  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      options  = args.extract_options!
      text     = args.shift
      args    << options
      error    = self.object.errors[attribute].try(:join, ', ')
      labeled  = text.present? || text.nil?
      
      classes  = [ input ]
      classes << 'error' if error.present?
      
      template.capture_haml do
        template.haml_tag(:li, :id => _li_id(attribute), :class => classes) do
          case input
            when :hidden_field then
              template.haml_concat super(attribute, *args)
            when :check_box then
              template.haml_concat super(attribute, *args)
              template.haml_concat self.label(attribute, text) if labeled
              template.haml_tag    :span, error if error.present?
            else
              template.haml_concat self.label(attribute, text) if labeled
              template.haml_tag    :span, error if error.present?
              template.haml_concat super(attribute, *args)
          end
        
          block.call if block
        end
      end
    end
  end
  
  BUTTONS.each do |button|
    define_method button do |*args|
      template.capture_haml do
        template.haml_tag(:li, :class => button) do
          template.haml_concat super(*args)
        end
      end
    end
  end
  
  private
  
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
  
  def _attribute_name(attribute)
    attribute.to_s.gsub(/[\?\/\-]$/, '')
  end
  
  def _li_id(attribute)
    [
      _object_name + _object_index, 
      _attribute_name(attribute),
      'input'
     ].join('_')
  end
end
