require 'active_record'

module Progstr
  module Filer
    module ActiveRecordClassMethods
      def _uploaders
        if @uploaders.nil?
          @uploaders = {}
          @uploaders = superclass._uploaders.merge(@uploaders) if superclass.respond_to?(:_uploaders)
          after_save :"_upload_attachments!"
        end
        @uploaders
      end

      def has_uploader(attribute, uploaderClass)
        class_eval <<-RUBY, __FILE__, __LINE__+1
          def #{attribute}
            _get_attachment(:#{attribute})
          end
          def #{attribute}=(new_file)
            _set_attachment(:#{attribute}, new_file)
          end
          def upload_#{attribute}!
            _upload_attachment(:#{attribute})
          end
        RUBY

        _uploaders[attribute] = uploaderClass.new
      end
    end

    module ActiveRecordInstanceMethods
      def _attachments
        @_filer_attachments ||= {}
        @_filer_attachments
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
        attachment = Attachment.from_file(attribute, file)
        _attachments[attribute] = attachment
        write_attribute(attribute, attachment.id)
      end

      def _upload_attachments!
          self.class._uploaders.each do |item|
            attribute = item[0]
            _upload_attachment!(attribute)
          end
      end

      def _upload_attachment!(attribute)
        attachment = _get_attachment(attribute)
        if (!attachment.empty?) && (!attachment.file.nil?)
          uploader = self.class._uploaders[attribute]
          uploader.upload_attachment(attachment) unless uploader.nil?
        end
      end
    end
  end
end

ActiveRecord::Base.extend Progstr::Filer::ActiveRecordClassMethods
ActiveRecord::Base.send(:include, Progstr::Filer::ActiveRecordInstanceMethods)
