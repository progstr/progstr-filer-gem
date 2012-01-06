module Progstr
  module Filer
    class Attachment
      attr_accessor :id, :attribute, :file

      @@id_generator = ::UUID.new

      class EmptyAttachment < Attachment
        def blank?
          true
        end

        def size
          0
        end

        def path
          ""
        end

        def extension
          ""
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

      def size
        file.size
      end

      def path
        (file.original_filename if file.respond_to?(:original_filename)) ||
          (file_path = file.path if file.respond_to?(:path))
      end

      def extension
        from_file = File.extname(path) || ""
        from_file.sub(".", "")
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
