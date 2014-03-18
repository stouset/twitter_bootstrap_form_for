module TwitterBootstrapFormFor
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_view) { include TwitterBootstrapFormFor::FormHelpers }
  end
end
