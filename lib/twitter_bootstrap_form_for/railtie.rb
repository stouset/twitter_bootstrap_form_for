require 'twitter_bootstrap_form_for'
require 'rails/railtie'

class TwitterBootstrapFormFor::Railtie < Rails::Railtie
  initializer 'twitter_bootstrap_form_for.initialize',
    :after => :after_initialize do
    ActionView::Base.send :include, TwitterBootstrapFormFor::FormHelpers
  end
end
