module Progstr
  module Filer
    module Html
      def filer_upload(attachment, options = {})
        client_id = generate_container_id
        register_scripts

        client_options = prepare_client_options(attachment, options)
        client_options_json = MultiJson.encode(client_options)

        init_script = <<EOJSON
    $(function(){
      $('\##{client_id}').filerUpload(#{client_options_json})
    })
EOJSON

        "<div id=\"#{client_id}\"></div>".html_safe +
          javascript_tag(init_script)
      end


      def filer_scripts
        prefix = Progstr::Filer.asset_url_prefix || Progstr::Filer.default_asset_url_prefix

        scripts = [
          "/upload.js",
          "/pl/flash.support.js",
        ]
        tags = scripts.map do |script|
          javascript_include_tag (prefix + script)
        end
        tags.join("\r\n").html_safe
      end

      private
      def generate_container_id
        request.env["PROGSTR_FILER_UPLOAD_INSTANCES"] ||= 1
        instances = request.env["PROGSTR_FILER_UPLOAD_INSTANCES"]
        request.env["PROGSTR_FILER_UPLOAD_INSTANCES"] += 1
        "filer_upload_container_#{instances}"
      end

      def prepare_client_options(attachment, options)
        client_options = {}
        options.each do |k, v|
          client_options[k.to_s.camelize(:lower)] = v
        end
        uploader_name = attachment.uploader_class.name
        client_options["uploader"] = uploader_name
        client_options["initialFiles"] = [attachment.display_hash] unless attachment.blank?
        client_options["authToken"] = Progstr::Filer.generate_upload_auth_token(uploader_name)
        client_options["uploadUrl"] = Progstr::Filer.upload_url unless Progstr::Filer.upload_url.nil?

        client_options
      end

      def register_scripts
        unless request.env.key? "PROGSTR_FILER_SCRIPTS_INCLUDED"
          request.env["PROGSTR_FILER_SCRIPTS_INCLUDED"] = true

          content_for :filer_scripts, filer_scripts
        end
      end
    end
  end
end

require "action_controller"
ActionController::Base.helper(Progstr::Filer::Html)
