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
 * Bootstrap 3 (Checkout the [bootstrap-rails] gem.)

## Syntax ##

```haml
= twitter_bootstrap_form_for @user, layout: [:vertical (default) OR :horizontal OR :inline], default_div_class: 'col-lg-10 (default)', role: 'form (default)' do |f|

  / wraps a section in a fieldset with the provided legend text
  = f.inputs 'Sign up', class: 'sign_up' do

    / generates a standard email field
    / also showing overriding the div_class around the input element on a horizontal form
    = f.email_field :email

    / generates a field for the user name with a custom label, a placeholder text,
    / a bootstrap class to make the form field larger and overwrites the
    / default class on the input element wrapper in horizontal forms.
    = f.text_field :name, 'Username', placeholder: 'Choose your user name.', class: 'input-lg', div_class: 'col-md-6'

    / generates a password field with a descriptive aside
    = f.password_field :password do
      %span.help-block
        Must be no larger than 6 characters<br/>
        Must contain only the letters 'x' or 'p'

    / a field with a custom label
    = f.password_field :password_confirmation, 'Confirm Password'

    / input fields with custom add-ons
    = f.text_field :twitter_id, 'Twitter', add_on: :prepend do
      %span.input-group-addon @

    / select fields now have the second parameter as a label
    = f.date_select :born_on, 'Born on'

    / group of radio buttons
    = f.toggles 'Email Preferences' do
      = f.radio_button :email, 'HTML Email', :html, checked: true
      = f.radio_button :email, 'Plain Text', :plain

    / group of checkboxes
    = f.toggles 'Agreements' do
      = f.check_box :agree,   'I agree to the abusive Terms and Conditions'
      = f.check_box :spam,    'I agree to receive all sorts of spam'
      = f.check_box :spammer, 'I agree to let the site spam others through my Twitter account'

  / wraps buttons in a distinctive style
  = f.actions do
    = f.submit 'Sign up'
    = button_tag  'Cancel', type: 'reset', class: 'btn'
```

That code produces the following output, with no custom stylesheets.

![](https://github.com/stouset/twitter_bootstrap_form_for/raw/master/examples/screenshot.png)

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, but with minor extensions to expose
the functionality anticipated by Twitter Bootstrap.

[Twitter Bootstrap]: http://twitter.github.com/bootstrap/
[bootstrap-rails]: https://github.com/anjlab/bootstrap-rails
