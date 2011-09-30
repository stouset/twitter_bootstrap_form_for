Twitter Bootstrap Forms
=======================

twitter_bootstrap_forms is a Rails FormBuilder DSL that, like Formtastic,
makes it easier to create semantically awesome, readily-stylable, and
wonderfully accessible HTML forms in your Rails applications. It abides by
the markup expectations of [Twitter Bootstrap], make your forms look great right
out of the box.

However, it also tries not to do too much. Rather than try to guess at input
types and provide an exhaustive set of options for each tag helper (as
Formtastic does), it only lightly wraps the existing Rails form tag helpers.

Dependencies
============

None, although it will work best with the styling provided by Twitter
Bootstrap.

Syntax
======

  = twitter_bootstrap_form_for @user do |user|
    # wraps a section in a fieldset with the provided legend text
    = user.inputs 'Sign in' do
    
      # longhand form
      = user.input :email do
        = user.label       :email
        = user.email_field :email, :placeholder => 'me@example.com'
        = user.help link_to('Create an account', '#')
      
      # shorthand form
      = user.labeled_password_field :password, 'Password', link_to('Forgot your password?', '#')
      = user.input_list do
        = user.labeled_check_box, :remember, 'Remember me'
        = user.labeled_check_box, :agree,    'I agree to the Terms and Conditions'
	
This is equivalent to the following Haml.

  # TODO

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, but they have enhanced versions that
wrap them in labels, handle error and help text automatically, and wrap
everything in the markup that Twitter Bootstrap expects.

[Twitter Bootstrap]: http://twitter.github.com/bootstrap/