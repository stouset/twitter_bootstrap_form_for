require 'semantic_form_for'

class SemanticFormFor::FormBuilder < ActionView::Helpers::FormBuilder
  include SemanticFormFor::FormHelpers
  
  attr_reader :template
  attr_reader :object
  attr_reader :object_name
  
  FIELDSETS = [ :inputs, :buttons ]
  
  INPUTS    = [ :check_box,    :email_field,    :file_field,   :hidden_field,
                :number_field, :password_field, :radio_button, :range_field,
                :search_field, :select,         :text_area,    :text_field,
                :url_field ]
                
  BUTTONS   = [ :image_submit, :submit ]
  
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
    define_method input do |attribute, *args|
      options  = args.extract_options!
      text     = args.shift
      error    = self.object.errors[attribute].try(:join, ', ')
      
      classes  = [ input ]
      classes << 'error' if error.present?
      
      template.capture_haml do
        template.haml_tag(:li, :id => _li_id(attribute), :class => classes) do
          # check boxes should have their label and input tag in the reverse
          # order
          if input != :check_box
            template.haml_concat self.label(attribute, text)
            template.haml_tag    :p, error if error.present?
            template.haml_concat super(attribute, options)
          else
            template.haml_concat super(attribute, options)
            template.haml_concat self.label(attribute, text)
            template.haml_tag    :p, error if error.present?
          end
        end
      end
    end
  end
  
  BUTTONS.each do |button|
    define_method button do |text, options = {}|
      template.capture_haml do
        template.haml_tag(:li, :class => button) do
          template.haml_concat super(text, options)
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
