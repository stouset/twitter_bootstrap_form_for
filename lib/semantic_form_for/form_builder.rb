require 'semantic_form_for'

class SemanticFormFor::FormBuilder < ActionView::Helpers::FormBuilder
  def inputs(label = nil, &block)
    template.content_tag :fieldset do
      template.content_tag :legend, label if label
      template.capture(&block)
    end
  end
end