module TwitterBootstrapFormFor
  require 'twitter_bootstrap_form_for/version'
  
  autoload :FormBuilder, 'twitter_bootstrap_form_for/form_builder'
  autoload :FormHelpers, 'twitter_bootstrap_form_for/form_helpers'
  autoload :Railtie,     'twitter_bootstrap_form_for/railtie'
end

TwitterBootstrapFormFor::Railtie # trigger loading the Railtie
