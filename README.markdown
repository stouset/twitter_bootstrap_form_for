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

Just Rails. But you were going to use that anyway, weren't you?

## Installation ##

```ruby
# Gemfile
gem 'twitter_bootstrap_form_for', :github => "stouset/twitter_bootstrap_form_for", :branch => "rails-2.3"
```


```ruby
# environment.rb
config.after_initialize do
  ActionView::Base.send :include, TwitterBootstrapFormFor::FormHelpers
end
```

## Syntax ##

```haml
/ supports both vertical and horizontal forms
= twitter_bootstrap_form_for @user, :html => { :class => 'form-horizontal'}  do |user|

  / wraps a section in a fieldset with the provided legend text
  = user.fieldset 'Sign up', :class => 'sign_up' do

    / generates a standard email field
    = user.email_field :email, :placeholder => 'me@example.com'

    / generates a password field with a descriptive aside
    = user.password_field :password do
      %span.help-block
        Must be no larger than 6 characters<br/>
        Must contain only the letters 'x' or 'p'

    / a field with a custom label
    = user.password_field :password_confirmation, 'Confirm Password'

    / input fields with custom add-ons
    = user.text_field :twitter_id, 'Twitter', :class => 'medium', :add_on => :prepend do
      %span.add-on @

    / select fields now have the second parameter as a label
    = user.date_select :born_on, 'Born on', {}, :class => 'span2'

    / inline inputs
    = user.label 'Interests' do |controls|
      #{controls.text_field :interest_1, :class => 'span2 inline'},
      #{controls.text_field :interest_2, :class => 'span2 inline'}, and
      #{controls.text_field :interest_3, :class => 'span2 inline'}

    / group of radio buttons
    = user.label 'Email Preferences' do |controls|
      = controls.radio_button :email, :html,  'HTML Email', :checked => true
      = controls.radio_button :email, :plain, 'Plain Text'

    / group of checkboxes
    = user.label 'Agreements' do |controls|
      = controls.check_box :agree,   'I agree to the abusive Terms and Conditions'
      = controls.check_box :spam,    'I agree to receive all sorts of spam'
      = controls.check_box :spammer, 'I agree to let the site spam others through my Twitter account'

    / wraps buttons in a distinctive style
    = user.actions do
      = user.submit 'Sign up'
      = user.button 'Cancel'
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

[Twitter Bootstrap]: http://twitter.github.com/bootstrap/
