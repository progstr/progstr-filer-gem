module Progstr
  module Filer
    module FormHtml

      def filer_upload_field(method, options = {})
        unless options.key? :file_input_name
          sanitized_method_name = method.to_s.sub(/\?$/,"")
          input_name = "#{@object_name}[#{sanitized_method_name}]"
          options[:file_input_name] = input_name
        end
        attachment = @object.send(method)

        @template.filer_upload(attachment, options)
      end
    end
  end
end

require "action_view"
form_builder = ActionView::Base.default_form_builder
form_builder.class_eval do 
  include Progstr::Filer::FormHtml
end
