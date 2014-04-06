require 'test_helper'

class FormHelperTest < ActionView::TestCase
  test 'it should yield an instance of TwitterBootstrapFormFor::FormBuilder' do
    twitter_bootstrap_form_for @user do |f|
      assert f.instance_of?(TwitterBootstrapFormFor::FormBuilder)
    end
  end

  test 'it should add role to form' do
    with_concat_form_for(@user)
    assert_select 'form[role="form"]'
  end

  test 'it should create vertical form by default' do
    with_concat_form_for(@user)
    assert_select 'form.form-vertical'
  end

  test 'it should create vertical form' do
    with_concat_form_for(@user, layout: :vertical)
    assert_select 'form.form-vertical'
  end

  test 'it should create inline form' do
    with_concat_form_for(@user, layout: :inline)
    assert_select 'form.form-inline'
  end

  test 'it should create horizontal form' do
    with_concat_form_for(@user, layout: :horizontal)
    assert_select 'form.form-horizontal'
  end

  test 'it should raise error if specified form layout is unsupported' do
    exception = assert_raises(RuntimeError) { twitter_bootstrap_form_for(@user, layout: :foo) }
    assert_equal 'Specified form layout foo is invalid. Must be one of :vertical, :horizontal, or :inline.', exception.message
  end

  test 'it should add form class to form even if another class is already there' do
    with_concat_form_for(@user, layout: :horizontal, html: { class: 'foo' })
    assert_select 'form.form-horizontal.foo'
  end
end
