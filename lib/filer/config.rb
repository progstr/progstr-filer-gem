
module Progstr
  module Filer
    class << self
      attr_accessor :host, :access_key, :http_open_timeout, :http_read_timeout, :proxy_host, :proxy_port, :proxy_user, :proxy_pass, :log_debug_events

      def test()
        "Yo, progstr-filer config.rb here!"
      end
    end
  end
end
