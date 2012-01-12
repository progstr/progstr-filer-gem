require 'active_model'

module Progstr
  module Filer
    module Validation
      def validates_file_size_of(attribute, options)
        range = options[:in] || (0..1.0/0)
        min = options[:greater_than] || range.first
        max = options[:less_than]    || range.last
        allowed_range = (min..max)

        message = options[:message] || "File size not between #{min} and #{max} bytes."

        validates_with AttachmentPropertyValidator, :attributes => [attribute],
          :property => :size,
          :in        => allowed_range,
          :message   => message,
          :allow_blank => true,
          :allow_nil => true
      end

      def validates_file_extension_of(attribute, options)
        allowed = options[:allowed] || EverythingIncluded.new
        message = options[:message] || "File extension not allowed."

        validates_with AttachmentPropertyValidator, :attributes => [attribute],
          :property => :extension,
          :in        => allowed,
          :message   => message
      end

      class EverythingIncluded
        def include?
          true
        end
      end

      class AttachmentPropertyValidator < ActiveModel::Validations::InclusionValidator
        def initialize(options)
          @property = options[:property]
          super(options)
        end

        def validate_each(record, attribute, attachment)
          unless attachment.pre_validated
            property_value = attachment.send(@property)
            super(record, attribute, property_value) unless attachment.nil? || attachment.blank? || property_value.nil?
          end
        end
      end
    end
  end
end
