require 'twitter_bootstrap_form_for'
require 'rails'

class TwitterBootstrapFormFor::Railtie < Rails::Railtie
  initializer 'twitter_bootstrap_form_for.initialize',
    :after => :after_initialize do
    ActionView::Base.send :include, TwitterBootstrapFormFor::FormHelpers
    ActionController::Base.append_view_path Pathname.new(__FILE__).join('../../../app/views')
  end
end
