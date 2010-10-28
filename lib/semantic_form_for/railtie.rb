require 'semantic_form_for'
require 'rails'

class SemanticFormFor::Railtie < Rails::Railtie
  initializer 'semantic_form_for.initialize', :after => :after_initialize do
    ActionView::Base.send :include, SemanticFormFor::FormHelpers
  end
end
