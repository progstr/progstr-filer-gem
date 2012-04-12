module Progstr
  module Filer
    class FileLike
      def initialize(json)
        @values = MultiJson.decode(json)
      end

      def id
        @values["id"]
      end

      def path
        @values["name"]
      end

      def size
        @values["size"]
      end
    end

    class Attachment
      attr_accessor :id, :attribute, :file, :pre_validated

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
        def display_json
          nil
        end
        def need_upload?
          false
        end
      end

      def self.empty
        EmptyAttachment.new
      end

      def self.from_json(attribute, json)
        file = FileLike.new(json)
        result = from_file(attribute, file)
        result.pre_validated = true
        return result
      end

      def self.from_file(attribute, file)
        result = Attachment.new
        result.id = file_id(file)
        result.attribute = attribute

        result.file = file
        result.pre_validated = false
        result
      end

      def self.file_id(file)
        if file.respond_to?(:id)
          file.id
        else
          generate_id
        end
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

        result.pre_validated = true
        result
      end

      def blank?
        false
      end

      def url
        if !blank?
          token = Progstr::Filer.generate_download_auth_token(id)
          "#{Progstr::Filer.url_prefix}files/data/#{Progstr::Filer.access_key}/#{id}?auth=#{token}"
        else
          ""
        end
      end

      def public_url
        if !blank?
          "#{Progstr::Filer.url_prefix}files/data/#{Progstr::Filer.access_key}/#{id}"
        else
          ""
        end
      end

      def display_json
        values = {
          "name" => path,
          "size" => size,
          "id" => id
        }
        MultiJson.encode(values)
      end

      def need_upload?
        if file.nil?
          false
        elsif file.kind_of?(FileLike)
          false
        else
          true
        end
      end
    end
  end
end
