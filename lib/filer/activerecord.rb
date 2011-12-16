require 'active_record'

module Progstr
  module Filer
    module ActiveRecordClassMethods
      def uploaders
        @uploaders ||= {}
        @uploaders = superclass.uploaders.merge(@uploaders) if superclass.respond_to?(:uploaders)
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
        RUBY
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
            _attachments[attribute] = Attachment.from_id(id)
          end
        else
          _attachments[attribute]
        end
      end

      def _set_attachment(attribute, file)
        attachment = Attachment.from_file(file)
        _attachments[attribute] = attachment
        write_attribute(attribute, attachment.id)
      end
    end
  end
end

ActiveRecord::Base.extend Progstr::Filer::ActiveRecordClassMethods
ActiveRecord::Base.send(:include, Progstr::Filer::ActiveRecordInstanceMethods)
