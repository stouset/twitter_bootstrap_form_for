require 'twitter_bootstrap_form_for'

module TwitterBootstrapFormFor::FormHelpers
  [:form_for, :fields_for].each do |method|
    module_eval do
      define_method "twitter_bootstrap_#{method}" do |record, *args, &block|
        # add the TwitterBootstrap builder to the options
        options            = args.extract_options!
        options[:layout] ||= 'vertical'
        if options[:layout] == 'horizontal'
          options[:default_div_class] ||= 'col-lg-10'
          options[:default_label_class] ||= 'col-lg-2 control-label'
        end
        if options[:html].nil?
          options[:html] = {:role => 'form'}
          options[:html][:class] = "form-#{options[:layout]}" if options[:layout] != 'vertical'
        end
        options[:builder]  = TwitterBootstrapFormFor::FormBuilder

        # call the original method with our overridden options
        _override_field_error_proc do
          send method, record, *(args << options), &block
        end
      end
    end
  end

  private

  BLANK_FIELD_ERROR_PROC = lambda {|input, _| input }

  def _override_field_error_proc
    original_field_error_proc           = ::ActionView::Base.field_error_proc
    ::ActionView::Base.field_error_proc = BLANK_FIELD_ERROR_PROC
    yield
  ensure
    ::ActionView::Base.field_error_proc = original_field_error_proc
  end
end
