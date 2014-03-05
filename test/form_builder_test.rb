require 'test_helper'

class FormBuilderTest < ActionView::TestCase
  # Vertical form
  # Inputs in inline forms use the same markup as in vertical forms.

  # <form role="form">
  #   <div class="form-group">
  #     <label for="exampleInputEmail1">Email address</label>
  #     <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
  #   </div>
  #   <div class="checkbox">
  #     <label>
  #       <input type="checkbox"> Check me out
  #     </label>
  #   </div>
  #   <button type="submit" class="btn btn-default">Submit</button>
  # </form>

  test 'it should wrap input with form-group' do
    with_input_for @user, :email, :text_field
    assert_select 'div.form-group > input'
  end

  test 'it should add custom class to form-group' do
    with_input_for @user, :email, :text_field, form_group_html: { class: 'foo', id: 'bar' }
    assert_select 'div.form-group.foo#bar > input'
  end

  test 'it should add class form-control to input' do
    with_input_for @user, :email, :text_field
    assert_select 'input.form-control'
  end

  test 'it should add a class to the input and keep the default form-control class' do
    with_input_for @user, :email, :text_field, class: 'foo-class'
    assert_select 'div.form-group > input.form-control.foo-class'
  end

  test 'it should add a class to the div around the input' do
    with_input_for @user, :email, :text_field, div_class: 'foo-class'
    assert_select 'div.form-group > div.foo-class'
  end

  test 'it should create a date select and add form control class' do
    with_input_for @user, :born_on, :date_select
    assert_select 'div.form-group > select.form-control'
  end


  # Labels and placeholders

  test 'it should create a default label' do
    with_input_for @user, :email, :text_field
    assert_select 'div.form-group > label'
  end

  test 'it should create a custom label' do
    with_input_for @user, :email, :text_field, 'foo'
    assert_select 'div.form-group > label', 'foo'
  end

  test 'it should create no label' do
    with_input_for @user, :email, :text_field, false
    assert_select 'div.form-group > label', false
  end

  test 'it should add a class to the label' do
    with_input_for @user, :email, :text_field, label_class: 'foo-class'
    assert_select 'div.form-group > label.foo-class'
  end

  test 'it should create a placeholder if no label is created' do
    with_concat_form_for @user do |f|
      f.text_field :email, false
    end
    assert_select 'div.form-group > label', false
    assert_select 'div.form-group > input[placeholder="Email"]'
  end

  test 'it should create a placeholder with the label text' do
    with_concat_form_for @user do |f|
      f.text_field :email, placeholder: true
    end
    assert_select 'div.form-group > label', "Email"
    assert_select 'div.form-group > input[placeholder="Email"]'
  end

  test 'it should create a placeholder with the custom label text' do
    with_concat_form_for @user do |f|
      f.text_field :email, 'Foo', placeholder: true
    end
    assert_select 'div.form-group > label', "Foo"
    assert_select 'div.form-group > input[placeholder="Foo"]'
  end

  test 'it should create no placeholder and no label' do
    with_concat_form_for @user do |f|
      f.text_field :email, false, placeholder: false
    end
    assert_select 'div.form-group > label', false
    assert_select 'div.form-group > input[placeholder="Email"]', false
  end


  # Horizontal form
  # The markup of inputs is different in horizontal forms.

  # <form class="form-horizontal" role="form">
  #   <div class="form-group">
  #     <label for="inputEmail1" class="col-lg-2 control-label">Email</label>
  #     <div class="col-lg-10">
  #       <input type="email" class="form-control" id="inputEmail1" placeholder="Email">
  #     </div>
  #   </div>
  #   <div class="form-group">
  #     <div class="col-lg-offset-2 col-lg-10">
  #       <div class="checkbox">
  #         <label>
  #           <input type="checkbox"> Remember me
  #         </label>
  #       </div>
  #     </div>
  #   </div>
  #   <div class="form-group">
  #     <div class="col-lg-offset-2 col-lg-10">
  #       <button type="submit" class="btn btn-default">Sign in</button>
  #     </div>
  #   </div>
  # </form>

  test 'it should add class control-label to label in horizontal form' do
    with_horizontal_form_input_for @user, :email, :text_field
    assert_select 'div.form-group > label.control-label'
  end

  test 'it should add column class to label in horizontal form' do
    with_horizontal_form_input_for @user, :email, :text_field
    assert_select 'div.form-group > label.col-lg-2'
  end

  test 'it should wrap input with div and column class in horizontal form' do
    with_horizontal_form_input_for @user, :email, :text_field
    assert_select 'div.form-group > div.col-lg-10 > input'
  end


  # Buttons

  test 'it should create a submit button with default button classes' do
    with_input_for @user, nil, :submit
    assert_select 'form > input[type="submit"].btn.btn-primary'
  end

  test 'it should create a submit button with additional options' do
    with_concat_form_for @user, layout: :horizontal do |f|
      f.submit 'Sign up', :class => "btn btn-warning", :id => 'foo'
    end
    assert_select 'input[type="submit"]#foo.btn.btn-warning'
  end


  # Actions

  test 'it should wrap submit button with form-group in horizontal forms' do
    with_concat_form_for @user, layout: :horizontal do |f|
      f.actions do
        f.submit 'Sign up'
      end
    end
    assert_select 'div.form-group > div.col-lg-offset-2.col-lg-10 > input'
    assert_select 'div.form-group#user_actions' # The form group must have the id.
  end

  test 'it should not wrap submit button with form-group in default vertical forms' do
    with_concat_form_for @user do |f|
      f.actions do
        f.submit 'Sign up'
      end
    end
    assert_select 'input[type="submit"]'
    assert_select 'div.form-group', false
  end


  # Checkbox

  # <div class="checkbox">
  #   <label>
  #     <input type="checkbox"> Check me out
  #   </label>
  # </div>

  test 'it should create a checkbox' do
    with_input_for @user, :newsletter, :check_box
    assert_select 'div.checkbox > label > input'
    assert_select 'div.checkbox > label', 'Newsletter'
    # Single checkboxes must not be wrapped with a form-group.
    assert_select 'div.form-group', false
  end

  test 'it should create a checkbox with a custom label' do
    with_input_for @user, :newsletter, :check_box, 'Foo'
    assert_select 'div.checkbox > label', 'Foo'
  end

  # In horizontal forms the checkbox must be wrapped with a form group and column div.
  # <div class="form-group">
  #   <div class="col-lg-offset-2 col-lg-10">
  #     <div class="checkbox">
  #       <label>
  #         <input type="checkbox"> Remember me
  #       </label>
  #     </div>
  #   </div>
  # </div>

  test 'it should create a checkbox with form group and column classes in horizontal forms' do
    with_horizontal_form_input_for @user, :newsletter, :check_box
    assert_select 'div.form-group > div.col-lg-offset-2.col-lg-10 > div.checkbox > label > input'
  end


  # Checkbox groups

  # <div class="form-group">
  #   <label>Colors</label>
  #   <div class="checkbox">
  #     <label>
  #       <input type="checkbox"> Red
  #     </label>
  #   </div>
  #   <div class="checkbox">
  #     <label>
  #       <input type="checkbox"> Green
  #     </label>
  #   </div>
  # </div>

  test 'it should create a checkbox group' do
    with_concat_form_for @user do |f|
      f.toggles 'Newsletter' do
        f.check_box :weekly_newsletter
        f.check_box :monthly_newsletter
      end
    end
    assert_select 'div.form-group > div.checkbox > label > input'
    # The checkbox group should have a label.
    assert_select 'div.form-group > label', 'Newsletter'
    # The checkbox group label should have no target.
    assert_select 'div.form-group > label[for]', false
  end

  test 'it should create a checkbox group without a label' do
    with_concat_form_for @user do |f|
      f.toggles do
        f.check_box :weekly_newsletter
        f.check_box :monthly_newsletter
      end
    end
    assert_select 'div.form-group > label', false
  end

  # Inline style
  # The the checkbox and label are not wrapped with a div.checkbox instead
  # the label gets the class checkbox-inline.
  # <label class="checkbox-inline">
  #   <input type="checkbox" id="inlineCheckbox1" value="option1"> 1
  # </label>

  test 'it should create a inline checkbox group' do
    with_concat_form_for @user do |f|
      f.toggles 'Newsletter', :style => :inline do
        f.check_box :weekly_newsletter
        f.check_box :monthly_newsletter
      end
    end
    assert_select 'div.form-group > label.checkbox-inline > input'
  end

  # In horizontal forms the label must get a column class and control-label class
  # and the checkboxes must be wrapped in a div with column class.

  # <div class="form-group">
  #   <label class="col-lg-2 control-label">Colors</label>
  #   <div class="col-lg-10">
  #     <div class="checkbox">
  #       <label>
  #         <input type="checkbox"> Red
  #       </label>
  #     </div>
  #     <div class="checkbox">
  #       <label>
  #         <input type="checkbox"> Green
  #       </label>
  #     </div>
  #   </div>
  # </div>

  test 'it should create a checkbox group with column class for label and checkbox in horizontal forms' do
    with_concat_form_for @user, :layout => :horizontal do |f|
      f.toggles 'Newsletter' do
        concat f.check_box :weekly_newsletter
        concat f.check_box :monthly_newsletter
      end
    end
    assert_select 'div.form-group > label.col-lg-2.control-label'
    assert_select 'div.form-group > div.col-lg-10 > div.checkbox > label > input'
  end


  # Radio button
  # This is basically the same markup as for checkboxes. Except the class names
  # are radio instead of checkbox of course.

  test 'it should create a radio button' do
    # Just a simple test.
    # A single radio button wouldn't make sense of course...
    with_concat_form_for @user do |f|
      f.radio_button :newsletter, 'Yes', true, :checked => true
    end
    assert_select 'div.radio > label > input'
  end

  test 'it should create a inline radio group' do
    with_concat_form_for @user do |f|
      f.toggles 'Newsletter', :style => :inline do
        concat f.radio_button :newsletter, 'Yes', true, :checked => true
        concat f.radio_button :newsletter, 'No', false
      end
    end
    assert_select 'div.form-group > label.radio-inline > input'
  end


  # Inline inputs
  # TODO


  # Inputs (aka fieldset)

  test 'it should wrap inputs with a fieldset and create a legend' do
    with_concat_form_for @user do |f|
      f.inputs 'Foo' do
        concat f.text_field :email
      end
    end
    assert_select 'fieldset > legend', 'Foo'
    assert_select 'fieldset > div.form-group'
  end

  test 'it should wrap inputs with a fieldset but not create a legend' do
    with_concat_form_for @user do |f|
      f.inputs do
        concat f.text_field :email
      end
    end
    assert_select 'fieldset > legend', false
  end

  test 'it should wrap inputs with a fieldset and apply options' do
    with_concat_form_for @user do |f|
      f.inputs 'Foo', :class => 'foo', :id => 'bar' do
        concat f.text_field :email
      end
    end
    assert_select 'fieldset#bar.foo'
  end

  test 'it should wrap inputs with a fieldset and apply options to the legend' do
    with_concat_form_for @user do |f|
      f.inputs 'Foo', :legend_options => { :class => 'foo', :id => 'bar' } do
        concat f.text_field :email
      end
    end
    assert_select 'fieldset > legend#bar.foo'
  end


  # Help text

  # <div class="form-group">
  #   <label for="exampleInputEmail1">Email address</label>
  #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
  #   <span class="help-block">A block of help text that breaks onto a new line and may extend beyond one line.</span>
  # </div>

  test 'it should create a help text' do
    with_input_for @user, :email, :text_field do
      concat %(<span class="help-block">foo</span>).html_safe
    end
    assert_select 'div.form-group > span.help-block', 'foo'
  end


  # Add ons

  # Prepend
  # <div class="input-group">
  #   <span class="input-group-addon">@</span>
  #   <input type="text" class="form-control" placeholder="Username">
  # </div>

  test 'it should prepend a add on' do
    with_input_for @user, :email, :text_field, add_on: :prepend do
      concat %(<span class="input-group-addon">foo</span>).html_safe
    end
    assert_select 'div.form-group > div.input-group > span.input-group-addon:first-child', 'foo'
  end

  # Append
  # <div class="input-group">
  #   <input type="text" class="form-control">
  #   <span class="input-group-addon">.00</span>
  # </div>

  test 'it should append a add on' do
    with_input_for @user, :email, :text_field, add_on: :append do
      concat %(<span class="input-group-addon">foo</span>).html_safe
    end
    assert_select 'div.form-group > div.input-group > span.input-group-addon:last-child', 'foo'
  end

  # Prepend and append
  # <div class="input-group">
  #   <span class="input-group-addon">$</span>
  #   <input type="text" class="form-control">
  #   <span class="input-group-addon">.00</span>
  # </div>

  # test 'it should append and prepend a add on' do
  #   # TODO: This is not possible at the moment because the add on given in the
  #   # block is either appended or prepended.
  # end


  test 'it should append a add on and create a extra input-group div in horizontal forms' do
    with_horizontal_form_input_for @user, :email, :text_field, add_on: :append do
      concat %(<span class="input-group-addon">foo</span>).html_safe
    end
    assert_select 'div.form-group > div.col-lg-10 > div.input-group > span.input-group-addon:last-child', 'foo'
  end


  # Errors

  # <div class="form-group has-error">
  #   <label class="control-label" for="inputError">Input with error</label>
  #   <input type="text" class="form-control" id="inputError">
  # </div>

  test 'it should add error class to form group' do
    @user.valid?
    with_input_for @user, :name, :text_field
    assert_select 'div.form-group.has-error'
  end

  test 'it should add error message to input' do
    @user.valid?
    with_input_for @user, :name, :text_field
    assert_select 'div.form-group.has-error > span.help-block', 'can&#39;t be blank'
  end


  test 'it should display error messages with the errors helper' do
    @user.valid?
    with_concat_form_for @user do |f|
      f.errors
    end
    assert_select 'div#error_explanation h2', "There were problems with the following fields:"
  end

  test 'it should only display selected errors with the errors helper' do
    @user.valid?
    with_concat_form_for @user do |f|
      f.errors only: :name
    end
    assert_select 'div#error_explanation ul li', 1
  end

  test 'it should only display errors except specified fields with the errors helper' do
    @user.valid?
    with_concat_form_for @user do |f|
      f.errors except: :name
    end
    assert_select 'div#error_explanation ul li', 1
  end

  # TODO
  # test errors on checkbox and checkbox group and inline elements (if we add it back)

end
