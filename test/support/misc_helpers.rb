# Taken from simple_form.
# https://github.com/plataformatec/simple_form

module MiscHelpers
  def with_concat_form_for(*args, &block)
    concat twitter_bootstrap_form_for(*args, &(block || proc {}))
  end

  def with_input_for(object, attribute_name, type, options={}, &block)
    with_concat_form_for(object) do |f|
      f.send type, attribute_name, options, &block
    end
  end

  def with_horizontal_form_input_for(object, attribute_name, type, options={}, &block)
    with_concat_form_for(object, layout: :horizontal) do |f|
      f.send type, attribute_name, options, &block
    end
  end
end
