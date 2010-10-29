Semantic Forms
==============

semantic_form_for is a Rails FormBuilder DSL that, like Formtastic, makes it
easier to create semantically awesome, readily stylable, and wonderfully
accessible HTML forms in your Rails applications.

However, it also tries not to do too much. Rather that trying to guess at
input types, and provide its own sizeable set of customization options to
each method, it wraps around the existing Rails field helpers.

Dependencies
============

semantic_form_for depends on Haml. Why? It's what I use, and it was marginally
easier than writing it for ERB.

Syntax
======

	= semantic_form_for @user do |user|
		= user.inputs 'Sign in' do
			= user.email_field    :email, :placeholder => 'me@example.com'
			= user.password_field :password
			= user.check_box,     :remember, 'Remember me'
			
			= user.submit 'Sign in'
	
This is equivalent to the following Haml.

	= form_for @user do |user|
		%fieldset.inputs
			%legend Sign in
			%ol
				%li#user_email_input
					= user.label       :email
					= user.email_field :email, :placeholder => 'me@example.com'
				%li#user_password_input
					= user.label          :password
					= user.password_field :password
				%li#user_remember_input
					= user.check_box :remember
					= user.label     :remember, 'Remember me'
				%li
					= user.submit_tag 'Sign in'

That's it. All of the Rails field helpers you know and love work just like
their normal FormBuilder counterparts, except for the minor addition of an
optional second parameter to specify the field's label. Everything else works
as expected, but gives you more semantic markup for free.