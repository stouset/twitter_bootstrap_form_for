module SemanticFormFor
  autoload :FormBuilder, 'semantic_form_for/form_builder'
  autoload :FormHelpers, 'semantic_form_for/form_helpers'
  autoload :Railtie,     'semantic_form_for/railtie'
end

SemanticFormFor::Railtie # trigger loading the Railtie
