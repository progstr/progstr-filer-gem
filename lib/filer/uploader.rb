module Progstr
  module Filer
    class UploadStatus
      def initialize(parsed)
        @parsed = parsed
      end

      def name
        @parsed["name"]
      end
      def success
        @parsed["success"]
      end
      def message
        @parsed["message"]
      end
    end

    class Uploader
      def upload_attachment(attachment)
        url = "http://#{Progstr::Filer.host}:#{Progstr::Filer.port}#{Progstr::Filer.path_prefix}/upload/new"
        response = RestClient.post("http://filer.local:8080/upload/new", {
                    :upload1 => attachment.file,
                    :authToken => Progstr::Filer.generate_auth_token,
                    :id => attachment.id
                  },
                  { :accept => "application/json" })
        UploadStatus.new MultiJson.decode(response)
      end
    end
  end
end
