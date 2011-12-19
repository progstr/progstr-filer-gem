$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#require 'rspec'
require 'progstr-filer'

require 'test/unit'
require 'shoulda'
require 'file_like'
require 'user_data'
require 'pp'

Progstr::Filer.host = "filer.local"
Progstr::Filer.port = "8080"

Progstr::Filer.access_key = "DEMO"
Progstr::Filer.secret_key = "DEMO"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

#RSpec.configure do |config|

#end
