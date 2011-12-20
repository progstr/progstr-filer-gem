require 'digest'
require 'rest-client'
require 'uuid'
UUID.state_file = false

require 'filer/config'
require 'filer/uploader'
require 'filer/attachment'
require 'filer/file_info'
require 'filer/activerecord'

class ApiError < StandardError
  attr_accessor :server_response

  def initialize(server_response)
    @server_response = server_response
  end

  def message
    @server_response["message"]
  end

  def http_code
    @server_response["httpCode"]
  end
end
