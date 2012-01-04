module Progstr
  module Filer
    module Validation
      def validates_file_size(attribute, options)
        range = options[:in] || (0..1.0/0)
        min = options[:greater_than] || range.first
        max = options[:less_than]    || range.last
        allowed_range = (min..max)

        message = options[:message] || "File size not between #{min} and #{max} bytes."

        validates_inclusion_of :"#{attribute}_file_size",
          :in        => allowed_range,
          :message   => message,
          :allow_blank => true,
          :allow_nil => true
      end

      def validates_file_size(attribute, options)
        range = options[:in] || (0..1.0/0)
        min = options[:greater_than] || range.first
        max = options[:less_than]    || range.last
        allowed_range = (min..max)

        message = options[:message] || "File size not between #{min} and #{max} bytes for '#{attribute}'."

        validates_inclusion_of :"#{attribute}_file_size",
          :in        => allowed_range,
          :message   => message,
          :allow_blank => true,
          :allow_nil => true
      end
    end
  end
end
