require 'semantic_form_for'

module SemanticFormFor::FormHelpers
  [:form_for, :field_for, :remote_form_for].each do |method|
    module_eval do
      define_method "semantic_#{method}" do |record, *args, &block|
        options = args.extract_options!
        options[:builder] = SemanticFormFor::FormBuilder
        
        class_names  = options[:class] ? options[:class].split(' ') : []
        class_names << case record
          when String, Symbol then record.to_s
          when Array          then ActiveModel::Naming.singular(record.last.class)
          else                     ActiveModel::Naming.singular(record.class)
        end
        
        send method, record, *(args << options), &block
      end
    end
  end
end
