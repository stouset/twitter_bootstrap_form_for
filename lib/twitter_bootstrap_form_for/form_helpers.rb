require 'twitter_bootstrap_form_for'

module TwitterBootstrapFormFor::FormHelpers
  [:form_for, :fields_for].each do |method|
    module_eval do
      define_method "twitter_bootstrap_#{method}" do |record, *args, &block|
        # add the TwitterBootstrap builder to the options
        options           = args.extract_options!
        options[:builder] = TwitterBootstrapFormFor::FormBuilder
        
        # call the original method with our overridden options
        send method, record, *(args << options), &block
      end
    end
  end
end
