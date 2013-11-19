require 'twitter_bootstrap_form_for'
require 'action_view/helpers'

class TwitterBootstrapFormFor::TwitterBootstrapFormFor::FormBuilder < ActionView::Helpers::FormBuilder
  include TwitterBootstrapFormFor::FormHelpers

  attr_reader :template
  attr_reader :object
  attr_reader :object_name

  INPUTS = [
    :select,
    *ActionView::Helpers::FormBuilder.instance_methods.grep(%r{
      _(area|field|select)$ # all area, field, and select methods
    }mx).map(&:to_sym)
  ]

  INPUTS.delete(:hidden_field)

  TOGGLES = [
    :check_box,
    :radio_button,
  ]

  #
  # Wraps the contents of the passed block with a fieldset and a (optional) legend.
  #
  #   f.inputs 'Sign-up' do
  #     f.text_field :username
  #   end
  #
  #   <fieldset>
  #     <legend>Sign-up</legend>
  #     ...
  #   </fieldset>
  #
  # The legend is optional.
  #
  #   f.inputs do
  #     f.text_field :username
  #   end
  #
  # Any additional options are passed on to the fieldset.
  #
  #   f.inputs 'Sign-up', :class => 'foo', :id => 'bar' do
  #     f.text_field :username
  #   end
  #
  #   <fieldset class="foo" id="bar">
  #     <legend>Sign-up</legend>
  #     ...
  #   </fieldset>
  #
  # To pass options to the legend tag use legend_options
  #
  #   f.inputs 'Sign-up', :class => 'foo', :id => 'bar', :legend_options { :class => 'foo-bar' }
  #
  def inputs(*args)
    options = args.extract_options!
    legend = args.first
    legend_options = options.delete(:legend_options)

    template.content_tag(:fieldset, options) do
      template.concat template.content_tag(:legend, legend, legend_options) if legend
      yield
    end
  end

  #
  # Wraps groups of toggles (radio buttons, checkboxes) with a label and the appropriate markup.
  # Remember: Always put checkboxes and radiobuttons in a +toggles+ block or the layout
  # will be wrong. Exeption: A single checkbox can be added without a toggles block.
  #
  #   f.toggles 'Favorite Colors' do
  #     f.checkbox :red
  #     f.checkbox :green
  #   end
  #
  #   <div class="form-group">
  #     <label>Favorite Colors</label>
  #     ...
  #   </div>
  #
  # The group label is optional.
  #
  #   f.toggles do
  #     f.checkbox :accept_terms
  #     f.checkbox :accept_privacy_policy
  #   end
  #
  # To create a custom label for the checkbox use
  #
  #   f.checkbox :accept_terms, 'I accept the terms of use.'
  #
  # You can create inline checkboxes by adding a style option.
  # Default style is +stacked+.
  #
  #   f.toggles 'Favorite Colors', :style => :inline do
  #     f.checkbox :red
  #     f.checkbox :green
  #   end
  #
  #   <div class="form-group">
  #     <label>Favorite Colors</label>
  #     <label class="checkbox-inline">
  #       <input id="red" name="red" type="checkbox" value="1" /> Red
  #     </label>
  #     <label class="checkbox-inline">
  #       <input id="green" name="green" type="checkbox" value="1" /> Green
  #     </label>
  #   </div>
  #
  # To change to form group label class pass the +label_class+ option.
  #
  def toggles(*args)
    # A flag that we are inside the toggles method because the
    # checkbox/radiobutton markup is different then. It would be more cool if we
    # could add this when calling the checkbox/radiobutton method but i couldn't
    # figure out how. Same for @toggles_style.
    @toggles = true

    options  = args.extract_options!
    label    = args.first.nil? ? '' : args.shift
    label_class = options.delete(:label_class) || @options[:default_label_class]

    # This set of toggles will conform to either the stacked or inline style
    options[:style] ||= @options[:default_toggle_style]
    raise "Invalid style passed to toggles: #{options[:style].to_s}. Must be :stacked or :inline" unless [:stacked, :inline].include?(options[:style])
    @toggles_style = options[:style]

    html = template.content_tag :div, :class => 'form-group' do
      template.concat self.label(nil, label, :for => nil, :class => label_class) if label.present?

      if @options[:layout] == :horizontal
        html_class = label.present? ? @options[:default_div_class] : 'col-lg-offset-2 col-lg-10'
      end

      template.concat conditional_div_wrapper(:class => html_class) { yield }
    end
    @toggles = false
    @toggles_style = nil
    html
  end

  #
  # Wraps action buttons into their own styled container.
  # In horizontal forms buttons must be wrapped with extra markup or the layout
  # will be wrong. You might leave the actions out on vertical forms but
  # you sure need it on horizontal forms. So it might be a good idea to always
  # use the actions block anyway.
  #
  #   f.actions do
  #     f.submit, "Update User"
  #
  # Output for vertical forms
  #   <input class="btn btn-primary" name="commit" type="submit" value="Update User" />
  #
  # Output for horizontal forms
  #   <div class="form-group" id="user_actions">
  #     <div class="col-lg-offset-2 col-lg-10">
  #       <input class="btn btn-primary" name="commit" type="submit" value="Sign up" />
  #     </div>
  #   </div>
  #
  # To change the column div class pass the +class+ option.
  #
  #   f.actions :class => 'col-lg-offset-2 col-lg-10' do
  #     f.submit, "Update User"
  #
  def actions(*args, &block)
    if @options[:layout] == :horizontal
      options = args.extract_options!
      options[:class] ||= 'col-lg-offset-2 col-lg-10'
      conditional_div_wrapper(:id => "#{_object_name}_actions", :class => 'form-group') do
        template.content_tag(:div, :class => options[:class], &block)
      end
    else
      template.capture(&block)
    end
  end


  #
  # Renders a submit tag with default classes to style it as a primary button.
  # Remember: Always put buttons inside actions or the layout will be wrong in
  # horizontal forms.
  #
  #   f.actions do
  #     f.submit, "Update User"
  #
  #   <input class="btn btn-primary" name="commit" type="submit" value="Update User" />
  #
  # And additional options are passed on to the input tag
  #
  #   f.actions do
  #     f.submit, "Update User", :class => 'btn btn-warning', :id => 'foo'
  #
  #   <input class="btn btn-warning" id="foo" name="commit" type="submit" value="Update User" />
  #
  def submit(value = nil, options = {})
    options[:class] ||= 'btn btn-primary'
    super value, options
  end

  #
  # Creates bootstrap wrapping before yielding a plain old rails builder
  # to the supplied block.
  # FIXME: This is no Bootstrap 3 markup. It is also not mentioned in the
  # Bootstrap docs so maybe we should remove this?
  # If it should stay then http://stackoverflow.com/a/18429555/1392226 would
  # be a straight forward markup. Or http://stackoverflow.com/a/12212196/1392226
  #
  def inline(label = nil, &block)
    template.content_tag(:div) do
      template.concat template.content_tag(:label, label) if label.present?
      template.concat template.content_tag(:div, :class => 'input') {
        template.content_tag(:div, :class => 'inline-inputs') do
          template.fields_for(
            self.object_name,
            self.object,
            self.options.merge(:builder => ActionView::Helpers::FormBuilder),
            &block
          )
        end
      }
    end
  end

  #
  # Creates the different inputs. We support the same parameters as the
  # Rails form helpers with some additions to create the bootstrap markup.
  #
  # Examples: Check the readme for a complete example on how to create a
  # form with twitter_bootstrap_form_for.
  #
  #   = user.email_field :email
  #
  #   <div class="form-group" id="user_email_input">
  #     <label for="user_email">Email</label>
  #     <input class="form-control" id="user_email" name="user[email]" type="text" />
  #   </div>
  #
  #   = user.email_field :email, 'Your email address', :placeholder => 'me@example.com', :class => 'input-lg', :div_class => 'col-md-6'
  #
  #   <div class="form-group" id="user_email_input">
  #     <label for="user_email">Your email address</label>
  #     <div class="col-md-6">
  #       <input class="form-control input-lg" id="user_email" name="user[email]" placeholder="me@example.com" type="text" />
  #     </div>
  #   </div>
  #
  # To create a help text:
  #
  #   = user.email_field :email do
  #     %span.help-block We won't send no spam
  #
  #   <div class="form-group" id="user_email_input">
  #     <label for="user_email">Email</label>
  #     <input class="form-control" id="user_email" name="user[email]" type="text" />
  #     <span class="help-block">We won't send no spam</span>
  #   </div>
  #
  # To create a add on:
  #
  #   = user.email_field :email, :add_on => :prepend do
  #     %span.input-group-addon @
  #
  #   <div class="form-group" id="user_email_input">
  #     <label for="user_email">Email</label>
  #     <div class="input-group">
  #       <span class="input-group-addon">@</span>
  #       <input class="form-control" id="user_email" name="user[email]" type="text" />
  #     </div>
  #   </div>
  #
  # To remove the label
  #
  #   = user.email_field :email, false
  #
  #   <div class="form-group" id="user_email_input">
  #     <input class="form-control" id="user_email" name="user[email]" type="text" />
  #   </div>
  #
  # It will automatically create a placeholder if you create no label. Except if
  # you specify +placeholder: false+ as a option. If you specify +placeholder: true+
  # if will create a placeholder with the text from the label (or use the attribute name
  # if no label is specified)
  #


  INPUTS.each do |input|
    define_method input do |attribute, *args, &block|
      type = input
      options = args.extract_options!

      label = args.first.nil? ? '' : args.shift
      label_class = options.delete(:label_class) || @options[:default_label_class]

      if options[:placeholder].is_a?(FalseClass)
        options.delete(:placeholder)
      elsif options[:placeholder].is_a?(TrueClass)
        options[:placeholder] = label.presence || attribute.to_s.humanize
      elsif options[:placeholder].nil? && !label
        options[:placeholder] = attribute.to_s.humanize
      end

      add_on = options.delete(:add_on)

      # Add class form-control and any additional classes to the input.
      options[:class] = "form-control #{options[:class]}".strip

      # Inputs like the date select expect html options like class or id as a
      # separate parameter. Simply add all options (inlcuding the input class form-control)
      # to the html_options parameter.
      html_options = options.delete(:html) || {}
      html_options.merge!(options) if %w(date_select time_select datetime_select).include?(input.to_s)

      div_classes = []
      if options[:div_class].present?
        div_classes << options.delete(:div_class)
      elsif @options[:default_div_class].present?
        div_classes <<  @options[:default_div_class]
      end
      div_classes << 'input-group' if add_on.present?

      div_wrapper(attribute, :class => 'form-group') do
        template.concat self.label(attribute, label, :class => label_class) if label

        template.concat conditional_div_wrapper(:class => div_classes.join(' ').presence) {
          block.call if block.present? && add_on == :prepend

          final_args = args << options
          final_args << html_options if html_options.any?
          template.concat super(attribute, *final_args)

          template.concat error_span(attribute)
          # Append the add-on if :append was specified or if a add-on is
          # present but neither :append nor :prepend were specified.
          # This can be used to add the given block on as a help-block.
          block.call if block.present? && (add_on == :append || add_on != :prepend)
        }
      end
    end
  end


  #
  # Create check_box or radio_button inputs.
  # Please read the documentation on the +toggles+ method on how to create
  # checkboxes or radiobuttons.
  #
  TOGGLES.each do |toggle|
    define_method toggle do |attribute, *args|
      label = args.first.blank? ? attribute.to_s.humanize : args.shift
      input_class = bootstrap_class_for_input(toggle)

      # If the checkbox/radiobutton style is :inline we need to add
      # a style class to the label. If the style is :stacked (default) the
      # checkbox must be wrapped with a div.checkbox.
      if @toggles_style == :inline
        label_class = "#{input_class}-inline"
      else
        # We must wrap the checkox in a div.checkbox if the checkbox style is not inline
        div_wrapper_attributes = { :id => _wrapper_id(attribute), :class => input_class }
      end

      # In horizontal forms single checkboxes must be wrapped with a form group
      # and column classes. If the checkbox is created inside a toggles block we
      # don't need to do this because this is then done in the toggles method.
      if @options[:layout] == :horizontal && !@toggles
        form_group_attributes = { :class => 'form-group' }
        column_attributes = { :class => 'col-lg-offset-2 col-lg-10' }
      end

      conditional_div_wrapper(form_group_attributes) do
        conditional_div_wrapper(column_attributes) do
          conditional_div_wrapper(div_wrapper_attributes) do
            template.concat template.content_tag(:label, :class => label_class) {
              template.concat super(attribute, *args)
              template.concat " #{label}"
            }
            if toggle == :check_box
              template.concat template.content_tag(:div, :class => "has-error") {
                template.concat error_span(attribute)
              } if errors_on?(attribute)
            end
          end
        end
      end

    end
  end

  protected

  #
  # Wraps the contents of +block+ inside a +div+ with an appropriate class and
  # id for the object's +attribute+. HTML options can be overridden by passing
  # an +options+ hash.
  #
  def div_wrapper(attribute, options = {}, &block)
    options[:id]    = _wrapper_id      attribute, options[:id]
    options[:class] = _wrapper_classes attribute, options[:class]

    template.content_tag :div, options, &block
  end

  #
  # Wraps the contents of +block+ inside a +div+ if HTML options are present.
  # If no options are present the given block is not wrapped in a div.
  # Options with blank values (nil, '') will be ignored.
  #
  def conditional_div_wrapper(options = {}, &block)
    # Remove empty entries from options hash.
    opts = present_options(options)

    if opts.any?
      template.content_tag :div, opts, &block
    else
      template.capture(&block)
    end
  end

  def error_span(attribute, options = {})
    options[:class] ||= 'help-block'

    template.content_tag(
      :span, self.errors_for(attribute),
      :class => options[:class]
    ) if self.errors_on?(attribute)
  end

  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  def errors_for(attribute)
    self.object.errors[attribute].try(:join, ', ')
  end

  private

  #
  # Returns an HTML id to uniquely identify the markup around an input field.
  # If a +default+ is provided, it uses that one instead.
  #
  def _wrapper_id(attribute, default = nil)
    default || [
      _object_name + _object_index,
      _attribute_name(attribute),
      'input'
     ].join('_')
  end

  #
  # Returns any classes necessary for the wrapper div around fields for
  # +attribute+, such as 'errors' if any errors are present on the attribute.
  # This merges any +classes+ passed in.
  #
  def _wrapper_classes(attribute, *classes)
    classes.compact.tap do |klasses|
      klasses.push 'has-error' if self.errors_on?(attribute)
    end.join(' ')
  end

  def _attribute_name(attribute)
    attribute.to_s.gsub(/[\?\/\-]$/, '')
  end

  def _object_name
    self.object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def _object_index
    case
      when options.has_key?(:index) then options[:index]
      when defined?(@auto_index)    then @auto_index
      else                               nil
    end.to_s
  end

  #
  # Return only those options from a options hash that have values.
  #   present_options {:id => 1, :class => '', :role => nil}
  #   => {:id => 1}
  #
  def present_options(options)
    options ||= {}
    options.select {|option,value| value.present? }
  end

  #
  # Bootstrap input classes are different from input names. This method returns
  # the right class for the right input
  #  bootstrap_class_for_input :radio_button
  #  => 'radio'
  #
  def bootstrap_class_for_input(input)
    if input.to_s == 'check_box'
      'checkbox'
    elsif input.to_s == 'radio_button'
      'radio'
    else
      input.to_s
    end
  end
end
