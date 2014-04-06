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

    / required fields are marked with an * prepended to their labels.
    / A field is required if the model responds with "true" to "[attribute]_required?"
    / or if you specify "required: true|false" on the form field.
    = f.email_field :email, required: true

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

    / generate a datepicker (to generate a regulare date_select field use
    / "datepicker: false" as a option)
    = f.date_select :born_on

    / generate a single checkbox
    = f.check_box :agree

    / generate a group of checkboxes using the *toggles* method and add custom labels
    = f.toggles 'Agreements' do
      = f.check_box :agree,   'I agree to the abusive Terms and Conditions'
      = f.check_box :spam,    'I agree to receive all sorts of spam'
      = f.check_box :spammer, 'I agree to let the site spam others through my Twitter account'

    / generate a group of radio buttons using the *toggles* method and add custom labels
    = f.toggles 'Email Preferences' do
      = f.radio_button :email, 'HTML Email', :html, checked: true
      = f.radio_button :email, 'Plain Text', :plain

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

## Datepicker ##

By default a datepicker is rendered for date and/or time inputs via the
bootstrap-datepicker-rails Gem. You need require "twitter_bootstrap_form_for"
in your stylesheet and javascript manifest files to make it work.

In "app/assets/javascripts/application.js" add

  //= require twitter_bootstrap_form_for

In "app/assets/stylesheets/application.css" add

  *= require twitter_bootstrap_form_for

To create a datepicker in your form use

  = f.date_select :born_on

To customize the datepicker use

  = f.date_select :born_on, datepicker: { language: 'de', today_btn: 'linked', today_highlight: true, autoclose: true }

Datepicker options are documented at https://github.com/eternicode/bootstrap-datepicker but
make sure you use the Ruby dash syntax when specifying the options via the form helper.
Write "today_btn" instead of "todayBtn". More examples via http://eternicode.github.io/bootstrap-datepicker/

If you set a language different from english "en" you need to include the localized
javascript files in your "app/assets/javascripts/application.js" file right where you
require "twitter_bootstrap_form_for" like this:

  //= require bootstrap-datepicker/locales/bootstrap-datepicker.de.js
  //= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
  //= require bootstrap-datepicker/locales/bootstrap-datepicker.fr.js
  ...

To disable the datepicker and render a regular input field use

  = f.date_select :born_on, datepicker: false

Important! The datepicker uses the Rails default date format from I18n.t('date.formats.default').
If change that via the "format" option on the datepicker make sure Rails can parse that
custom format. You might need to overwrite the attribute setter on your model for that.


[Twitter Bootstrap]: http://twitter.github.com/bootstrap
[bootstrap-sass]: https://github.com/twbs/bootstrap-sass
[bootstrap-datepicker-rails]: https://github.com/Nerian/bootstrap-datepicker-rails
