module Progstr
  module Filer
    class Attachment
      attr_accessor :id, :file

      @@id_generator = ::UUID.new

      class EmptyAttachment
        def empty?
          true
        end
      end

      def self.empty
        EmptyAttachment.new
      end

      def self.from_file(file)
        result = Attachment.new
        result.id = generate_id
        result.file = file
        result
      end

      def self.generate_id
        uuid = @@id_generator.generate
        uuid.gsub("-", "")
      end

      def self.from_id(id)
        result = Attachment.new
        result.id = id
        result
      end

      def empty?
        false
      end

      def url
        ""
      end
    end
  end
end
