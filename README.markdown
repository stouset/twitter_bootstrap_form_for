Twitter Bootstrap Form For
==========================

`twitter_bootstrap_form_for` is a Rails FormBuilder DSL that, like Formtastic,
makes it easier to create semantically awesome, readily-stylable, and
wonderfully accessible HTML forms in your Rails applications. It abides by
the markup expectations of [Twitter Bootstrap], make your forms look great right
out of the box.

However, it also tries not to do too much. Rather than try to guess at input
types and provide an exhaustive set of options for each tag helper (as
Formtastic does), it only lightly wraps the existing Rails form tag helpers.

## Dependencies ##

 * Rails 4
 * Bootstrap 3 (Checkout the [bootstrap-sass] gem.)

## Syntax ##

```haml
= twitter_bootstrap_form_for @user, layout: [:vertical (default) OR :horizontal OR :inline], default_div_class: 'col-lg-10 (default)', role: 'form (default)' do |f|
  // By default error messages on fields are rendered inline with the field and you
  // don't have to do something special to display them. But if you have error messages
  // on your model that have no corresponding field in the form such as hidden fields
  // or if you use *model.errors.add :base* for example you can use the following helper.
  // To prevent errors from beeing listed twice you can use the *only* or *except*
  // option like this *= f.errors only: :base* for example.
  = f.errors

  / wraps a section in a fieldset with the provided legend text
  = f.inputs 'Sign up', class: 'sign_up' do

    / generate a email field
    = f.email_field :email

    / generate a text field with a custom label, a placeholder text, custom attributes
    / (class and id) for the input element, a custom class for the wrapper around the input element
    / and custom attributes for the form-group wrapper.
    = f.text_field :name, 'Username', placeholder: 'Choose your user name.', class: 'input-lg', id: 'username-input',
        div_class: 'col-md-6',
        form_group_html: { id: 'bar', class: 'foo' }

    / generate a password field with a descriptive aside
    = f.password_field :password do
      %span.help-block
        Must be no larger than 6 characters<br/>
        Must contain only the letters 'x' or 'p'

    / generate a field with a custom label
    = f.password_field :password_confirmation, 'Confirm Password'

    / generate a field with custom add-ons
    = f.text_field :twitter_id, 'Twitter', add_on: :prepend do
      %span.input-group-addon @

    / select fields now have the second parameter as a label
    = f.date_select :born_on, 'Born on'

    / generate agroup of radio buttons
    = f.toggles 'Email Preferences' do
      = f.radio_button :email, 'HTML Email', :html, checked: true
      = f.radio_button :email, 'Plain Text', :plain

    / generate a group of checkboxes
    = f.toggles 'Agreements' do
      = f.check_box :agree,   'I agree to the abusive Terms and Conditions'
      = f.check_box :spam,    'I agree to receive all sorts of spam'
      = f.check_box :spammer, 'I agree to let the site spam others through my Twitter account'

    / single checkboxes must not be wrapped with the *toggles* method.
    = f.check_box :agree,   'I agree to the abusive Terms and Conditions'

  / wraps buttons in a distinctive style
  = f.actions do
    = f.submit 'Sign up'
    = button_tag  'Cancel', type: 'reset', class: 'btn'
```

That code produces the following output, with no custom stylesheets.

![](examples/screenshot.png?raw=true)

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, but with minor extensions to expose
the functionality anticipated by Twitter Bootstrap.

[Twitter Bootstrap]: http://twitter.github.com/bootstrap
[bootstrap-sass]: https://github.com/twbs/bootstrap-sass
