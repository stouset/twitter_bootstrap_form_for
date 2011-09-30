require 'semantic_form_for'

module SemanticFormFor::FormHelpers
  [:form_for, :fields_for, :remote_form_for].each do |method|
    module_eval do
      define_method "semantic_#{method}" do |record, *args, &block|
        options = args.extract_options!
        
        klass = case record
          when String, Symbol then record.to_s
          when Array          then ActiveModel::Naming.singular(record.last.class)
          else                     ActiveModel::Naming.singular(record.class)
        end
        
        options[:html]       ||= {}
        options[:html][:class] = [ options[:html][:class], klass ].compact.join(' ')
        options[:builder]      = SemanticFormFor::FormBuilder
        
        send method, record, *(args << options), &block
      end
    end
  end
end
