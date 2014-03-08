module TwitterBootstrapFormFor
  class Datepicker
    def initialize(form_builder, attribute, *args)
      @form_builder = form_builder
      @attribute = attribute
      @options = to_datepicker_options!(args.extract_options!)
      @args = args
    end

    # Returns true if a datepicker should be rendered.
    # This checks if the input_type is one of the date/time selects and options[:datepicker] != false.
    def self.datepicker?(input_type, options={})
      if %w(date_select time_select datetime_select select_datetime select_date select_time).include?(input_type.to_s) && !options[:datepicker].is_a?(FalseClass)
        true
      else
        options.delete(:datepicker)
        false
      end
    end

    def render
      # Use the original text_field method here or we would
      # create labels and stuff again...
      @form_builder.original_text_field(@attribute, *(@args << @options))
    end

    private

      # Converts the input field options to datepicker option format.
      def to_datepicker_options!(options)
        options[:data] ||= {}
        options[:data][:behaviour] = 'datepicker'

        # Convert datepicker options to data attributes and prefix the
        # data attribute name with "datepicker" so we don't mess up other data attributes.
        datepicker_options = options.delete(:datepicker)
        datepicker_options = { } unless datepicker_options.is_a?(Hash)

        # Add the default options
        datepicker_options = default_options.merge(datepicker_options)

        # Prefix the data attribute names.
        datepicker_options = Hash[datepicker_options.map{|k,v| ["datepicker_#{k}", v] }]

        options[:data].merge! datepicker_options
        options
      end

      # Returns the default options for the datepicker input
      def default_options
        { autoclose: true, format: default_date_format }
      end

      # Returns the default date format for the datepicker
      # There is a catch here. If the input format for the datepicker does not
      # match the date format that is defined in rails it might not be possible
      # to save the date on the model. Assigning a unknown date format to a attribute
      # on the model will simply be ignored and the attribute is not changed.
      #
      # I try to check I18n for the current date format and use this as the format
      # for the datepicker. But if that get's overwritten by the user and then
      # can't be parsed by Rails the error might be hard to find for the user.
      #
      # Another options would be to use something like https://github.com/mojombo/chronic
      # to parse the input. But I think we would need to modify the model setter
      # for that too.
      #
      # For future reference: Default Rails date and time formats for "en" are:
      #
      #   I18n.t 'date.formats'
      #   {:default=>"%Y-%m-%d", :short=>"%b %d", :long=>"%B %d, %Y"}
      #
      #   I18n.t 'time.formats'
      #   {:default=>"%a, %d %b %Y %H:%M:%S %z", :short=>"%d %b %H:%M", :long=>"%B %d, %Y %H:%M", :date=>"%d %b %Y"}
      #
      def default_date_format
        begin
          format = I18n.t('date.formats.default')
        rescue
          format = '%Y-%m-%d'
        end

        strftime_to_ms_format(format)
      end

      # Converts the strftime format (%Y-%m-%d) to the microsoft format (yyyy-mm-dd)
      # that the datepicker component uses to setup the date format.
      def strftime_to_ms_format(format)
        format.gsub('%Y','yyyy').gsub('%A','dddd').gsub('%B','mmmm').gsub('%a','ddd').gsub('%b','mmm').gsub('%y','yy').gsub('%d','dd').gsub('%m','mm').gsub('%y','y').gsub('%y','%%y').gsub('%e','d')
      end

  end
end
