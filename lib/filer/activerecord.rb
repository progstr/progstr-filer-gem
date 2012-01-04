require 'active_record'

module Progstr
  module Filer
    module ActiveRecordClassMethods
      def _uploaders
        if @uploaders.nil?
          @uploaders = {}
          @uploaders = superclass._uploaders.merge(@uploaders) if superclass.respond_to?(:_uploaders)
          after_save :"_filer_after_save"
          before_destroy :"_filer_before_delete"
        end
        @uploaders
      end

      def has_file(attribute, uploaderClass)
        class_eval <<-RUBY, __FILE__, __LINE__+1
          def #{attribute}
            _get_attachment(:#{attribute})
          end
          def #{attribute}=(new_file)
            _set_attachment(:#{attribute}, new_file)
          end
          def #{attribute}_file_size
            _get_attachment(:#{attribute}).size
          end
          def #{attribute}_file_extension
            _get_attachment(:#{attribute}).extension
          end
          def upload_#{attribute}!
            _upload_attachment(:#{attribute})
          end
        RUBY

        _uploaders[attribute] = uploaderClass.new
      end

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

      def validates_file_extension(attribute, options)
        allowed = options[:allowed] || EverythingIncluded.new
        message = options[:message] || "File extension not allowed for '#{attribute}'."

        validates_inclusion_of :"#{attribute}_file_extension",
          :in        => allowed,
          :message   => message,
          :allow_blank => true,
          :allow_nil => true
      end

      class EverythingIncluded
        def include?
          true
        end
      end
    end

    module ActiveRecordInstanceMethods
      def _attachments
        @_filer_attachments ||= {}
        @_filer_attachments
      end

      def _attachments_to_delete
        @_filer_attachments_to_delete ||= []
        @_filer_attachments_to_delete
      end

      def _get_attachment(attribute)
        if _attachments[attribute].nil?
          id = read_attribute(attribute)
          if id.nil?
            _attachments[attribute] = Attachment.empty
          else
            _attachments[attribute] = Attachment.from_id(attribute, id)
          end
        else
          _attachments[attribute]
        end
      end

      def _set_attachment(attribute, file)
        old_attachment = _get_attachment(attribute)
        unless old_attachment.blank?
          _attachments_to_delete << old_attachment
        end

        attachment = Attachment.from_file(attribute, file)
        _attachments[attribute] = attachment
        write_attribute(attribute, attachment.id)
      end

      def _upload_attachments
        self.class._uploaders.each do |item|
          attribute = item[0]
          _upload_attachment(attribute)
        end
      end

      def _upload_attachment(attribute)
        attachment = _get_attachment(attribute)
        if (!attachment.blank?) && (!attachment.file.nil?)
          uploader = self.class._uploaders[attribute]
          uploader.upload_attachment(attachment) unless uploader.nil?
        end
      end

      def _delete_expired_attachments
        _attachments_to_delete.each do |attachment|
          uploader = self.class._uploaders[attachment.attribute]
          uploader.delete_attachment(attachment) unless uploader.nil?
        end
      end

      def _filer_after_save
        _upload_attachments
        _delete_expired_attachments
      end

      def _expire_all_attachments
        # trigger entity load
        dummy = read_attribute(:dummy)
        self.class._uploaders.each do |item|
          attribute = item[0]
          #load attachment object
          dummy = _get_attachment(attribute)
          #schedule it for deletion
          _set_attachment(attribute, nil)
        end
      end

      def _filer_before_delete
        _expire_all_attachments
        _delete_expired_attachments
      end
    end
  end
end

ActiveRecord::Base.extend Progstr::Filer::ActiveRecordClassMethods
ActiveRecord::Base.send(:include, Progstr::Filer::ActiveRecordInstanceMethods)
