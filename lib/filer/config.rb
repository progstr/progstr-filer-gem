
module Progstr
  module Filer
    class << self
      attr_accessor :host, :port, :path_prefix, :access_key, :secret_key, :session_timeout

      def host
        @host ||= "filer-api.progstr.com"
      end
      def port
        @port || 80
      end
      def path_prefix
        @path_prefix ||= '/'
      end
      def session_timeout
        @http_read_timeout ||= 30 * 60 # 30 minutes
      end

      def generate_auth_token
        expiration_seconds = (Time.now + session_timeout).to_i
        expiration_millis = expiration_seconds * 1000
        data = "#{access_key}-#{expiration_millis}-#{secret_key}"
        signature = Digest::SHA1.hexdigest(data)
        "#{access_key}-#{expiration_millis}-#{signature}"
      end

      def url_prefix
        prefix = "http://#{Progstr::Filer.host}:#{Progstr::Filer.port}#{Progstr::Filer.path_prefix}"
        if prefix.end_with? "/"
          prefix
        else
          prefix + "/"
        end
      end
    end
  end
end
