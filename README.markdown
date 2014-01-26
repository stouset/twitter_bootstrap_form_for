Twitter Bootstrap Form For
==========================

*_WARNING! This is for Rails 4 and Bootstrap 3 (current in RC)._*

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
 * Bootstrap-sass, pull from branch 3 off github

`
    gem 'bootstrap-sass', :git => 'git://github.com/thomas-mcdonald/bootstrap-sass.git', :branch => '3'
`

## Syntax ##

```haml
= twitter_bootstrap_form_for @user, layout: 'vertical (default) OR horizontal OR inline', default_div_class: 'col-lg-10 (default)', role: 'form (default)' do |user|

  / wraps a section in a fieldset with the provided legend text
  = user.inputs 'Sign up', :class => 'sign_up' do

    / generates a standard email field; also showing overriding the div_class around the input element on a horizontal form
    = user.email_field :email, :placeholder => 'me@example.com', div_class: 'col-md-6'

    / generates a password field with a descriptive aside
    = user.password_field :password do
      %span.help-block
        Must be no larger than 6 characters<br/>
        Must contain only the letters 'x' or 'p'

    / a field with a custom label
    = user.password_field :password_confirmation, 'Confirm Password'

    / input fields with custom add-ons, append by default
    = user.text_field :twitter_id, 'Twitter', :class => 'medium' do
      %span.add-on @
    = user.text_field :twitter_id, 'Twitter', :class => 'medium', :add_on => :prepend do
      %span.add-on @

    / input fields with input-group
    = user.text_field :twitter_id, 'Twitter', :class => 'medium', :input-group => '€'

    / select fields now have the second parameter as a label
    = user.date_select :born_on, 'Born on', {}, :class => 'small'

    / inline inputs are not automatically labeled
    = user.inline 'Interests' do |inline|
      #{inline.text_field :interest_1, :class => 'small'},
      #{inline.text_field :interest_2, :class => 'small'}, and
      #{inline.text_field :interest_3, :class => 'small'}

    / group of radio buttons
    = user.toggles 'Email Preferences' do
      = user.radio_button :email, 'HTML Email', :html, :checked => true
      = user.radio_button :email, 'Plain Text', :plain

    / group of checkboxes
    = user.toggles 'Agreements' do
      = user.check_box :agree,   'I agree to the abusive Terms and Conditions'
      = user.check_box :spam,    'I agree to receive all sorts of spam'
      = user.check_box :spammer, 'I agree to let the site spam others through my Twitter account'

  / wraps buttons in a distinctive style
  = user.actions do
    = user.submit 'Sign up'
    = button_tag  'Cancel', :type => 'reset', :class => 'btn'
```

That code produces the following output, with no custom stylesheets.

![](https://github.com/stouset/twitter_bootstrap_form_for/raw/master/examples/screenshot.png)

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, but with minor extensions to expose
the functionality anticipated by Twitter Bootstrap.

## Form Helper Changes ##

The changes this `FormBuilder` effects to the existing Rails form helpers is
simple:

  * the second parameter becomes the label (pass false to disable, nil for default)
  * the last options hash accepts an `:add_on` key
  * if a block is passed, the HTML it outputs is placed immediately after the input

## Configuration ##

Default class applied on label and div can be customized. Setup a file `config/initializers/twitter_bootstrap_form_for.rb` e.g.:

```ruby
TwitterBootstrapFormFor::FormBuilder.label_class = 'col-md-2 control-label'
TwitterBootstrapFormFor::FormBuilder.div_class = 'col-md-6'
TwitterBootstrapFormFor::FormBuilder.div_labelless_class = 'col-md-offset-2 col-md-6'
TwitterBootstrapFormFor::FormBuilder.action_class = 'col-md-offset-2 col-md-6'
```

## Known Bugs ##

  - inline fields don't receive error markup ([issue #28])

[Twitter Bootstrap]: http://twitter.github.com/bootstrap/
[issue #28]:          https://github.com/stouset/twitter_bootstrap_form_for/issues/28
