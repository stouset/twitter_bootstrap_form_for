require 'bootstrap-datepicker-rails'

module TwitterBootstrapFormFor
  autoload :FormBuilder, 'twitter_bootstrap_form_for/form_builder'
  autoload :FormHelpers, 'twitter_bootstrap_form_for/form_helpers'
  autoload :Datepicker,  'twitter_bootstrap_form_for/datepicker'
  autoload :VERSION,     'twitter_bootstrap_form_for/version'
end

require 'twitter_bootstrap_form_for/engine'
