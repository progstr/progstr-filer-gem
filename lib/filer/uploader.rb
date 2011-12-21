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
      def json_headers
        {
          :accept => "application/json",
          :"X-Progstr-Filer-Auth-Token" => Progstr::Filer.generate_auth_token,
        }
      end

      def upload_attachment(attachment)
        url = "#{Progstr::Filer.url_prefix}upload/new"
        begin
          response = RestClient.post(url, {
                      :upload1 => attachment.file,
                      :authToken => Progstr::Filer.generate_auth_token,
                      :property => attachment.attribute,
                      :uploader => self.class.name,
                      :id => attachment.id
                    }, json_headers)
          UploadStatus.new MultiJson.decode(response)
        rescue => e
          raise ApiError.new(UploadStatus.new MultiJson.decode(e.response))
        end
      end

      def delete_attachment(attachment)
        url = "#{Progstr::Filer.url_prefix}files/#{attachment.id}"
        begin
          response = RestClient.delete(url, json_headers)
          UploadStatus.new MultiJson.decode(response)
        rescue => e
          raise ApiError.new(MultiJson.decode(e.response))
        end
      end

      def file_info(attachment)
        url = "#{Progstr::Filer.url_prefix}files/info/#{attachment.id}"
        begin
          response = RestClient.get(url, json_headers)
          FileInfo.new MultiJson.decode(response)
        rescue => e
          raise ApiError.new(MultiJson.decode(e.response))
        end
      end
    end
  end
end
