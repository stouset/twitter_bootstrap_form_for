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

Dependencies
============

Besides Rails, Twitter Bootstrap depends on Haml. You don't have to use it
yourself, but it made the views for this gem far, far cleaner and more
readable.

I may consider adding a dependency on `less-rails-bootstrap` in the future, to
tie this plugin to specific releases of Twitter Bootstrap.

Syntax
======

```haml
= twitter_bootstrap_form_for @user do |user|
  
  / wraps a section in a fieldset with the provided legend text
  = user.inputs 'Sign up' do
    
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
    
    / lists of checkboxes / radio buttons
    = user.toggles 'Agreements' do
      = user.check_box :agree, 'I agree to the abusive Terms and Conditions'
      = user.check_box :spam,  'I agree to receive all sorts of spam'
      = user.check_box :spammer, 'I agree to let the site spam others through my Twitter account'
  
  / wraps buttons in a distinctive style
  = user.actions do
    = user.submit 'Sign up'
    = button_tag 'Cancel', :type => 'reset', :class => 'btn'
```

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, but with minor extensions to expose
the functionality anticipated by Twitter Bootstrap.

[Twitter Bootstrap]: http://twitter.github.com/bootstrap/
