module Progstr
  module Filer
    class Attachment
      attr_accessor :id, :attribute, :file

      @@id_generator = ::UUID.new

      class EmptyAttachment
        def blank?
          true
        end
      end

      def self.empty
        EmptyAttachment.new
      end

      def self.from_file(attribute, file)
        result = Attachment.new
        result.id = generate_id
        result.attribute = attribute
        result.file = file
        result
      end

      def self.generate_id
        uuid = @@id_generator.generate
        uuid.gsub("-", "")
      end

      def self.from_id(attribute, id)
        result = Attachment.new
        result.id = id
        result.attribute = attribute
        result
      end

      def blank?
        false
      end

      def url
        if !blank?
          "#{Progstr::Filer.url_prefix}files/data/#{Progstr::Filer.access_key}/#{id}"
        else
          ""
        end
      end
    end
  end
end
