require 'test_helper'

class DatepickerTest < ActionView::TestCase
  test 'it should check if a field can use the datepicker' do
    # Implicit, based on the input field type
    assert TwitterBootstrapFormFor::Datepicker.datepicker?(:date_select)
    assert !TwitterBootstrapFormFor::Datepicker.datepicker?(:text_field)

    # Explicit, if options datepicker == true
    options = { datepicker: true }
    assert TwitterBootstrapFormFor::Datepicker.datepicker?(:date_select, options)
    # But still not for fields that do not support the datepicker.
    # Maybe we should always use it when options datepicker == true?
    assert !TwitterBootstrapFormFor::Datepicker.datepicker?(:text_field, options)

    # Explicitly disabled
    options = { datepicker: false }
    assert !TwitterBootstrapFormFor::Datepicker.datepicker?(:date_select, options)
    assert !TwitterBootstrapFormFor::Datepicker.datepicker?(:text_field, options)
  end


  test 'it should create a date select and add form control class do every select field' do
    with_input_for @user, :born_on, :date_select, datepicker: false
    assert_select 'div.form-group > select.form-control', 3
  end

  test 'it should create a date picker for a date select input' do
    with_input_for @user, :born_on, :date_select
    assert_select 'div.form-group > input[type=text][data-behaviour=datepicker].form-control'
  end

  test 'it should explicitly create a date picker for a date select input' do
    with_input_for @user, :born_on, :date_select, datepicker: true
    assert_select 'div.form-group > input[type=text][data-behaviour=datepicker].form-control'
  end

  test 'it should not implicitly create a datepicker for a date select input' do
    with_input_for @user, :born_on, :date_select, datepicker: false
    assert_select 'div.form-group > select.form-control', 3
  end

  test 'it should create a datepicker with default options' do
    with_input_for @user, :born_on, :date_select, datepicker: { language: 'de' }
    assert_select 'input[type=text][data-behaviour=datepicker][data-datepicker-autoclose]'
  end

  test 'it should create a datepicker with options' do
    with_input_for @user, :born_on, :date_select, datepicker: { language: 'de' }
    assert_select 'input[type=text][data-behaviour=datepicker][data-datepicker-language=de]'
  end


  test 'it should return the default date format' do
    assert_equal 'yyyy-mm-dd', TwitterBootstrapFormFor::Datepicker.new(nil, nil).send(:default_date_format)
  end

  test 'it should convert date formats' do
    assert_equal 'yyyy-mm-dd', TwitterBootstrapFormFor::Datepicker.new(nil, nil).send(:strftime_to_ms_format, '%Y-%m-%d')
    assert_equal 'dd.mm.yyyy', TwitterBootstrapFormFor::Datepicker.new(nil, nil).send(:strftime_to_ms_format, '%d.%m.%Y')
    assert_equal 'dd/mm/yyyy', TwitterBootstrapFormFor::Datepicker.new(nil, nil).send(:strftime_to_ms_format, '%d/%m/%Y')
  end
end
