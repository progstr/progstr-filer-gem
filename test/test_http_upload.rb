require 'test_helper'

class DemoUploader < Progstr::Filer::Uploader
end

class TestHttpUpload < Test::Unit::TestCase
  test "upload attachment" do
    attachment = Progstr::Filer::Attachment.from_file(:version, File.open("VERSION"))
    uploader = DemoUploader.new
    response = uploader.upload_attachment attachment

    assert_equal response.name, "VERSION"
    assert_equal response.success, true
    assert_equal response.message, "OK"
  end

  test "report error on failed upload" do
    begin
      Progstr::Filer.secret_key = "BROKEN"

      attachment = Progstr::Filer::Attachment.from_file(:version, File.open("VERSION"))
      uploader = DemoUploader.new
      response = uploader.upload_attachment attachment

      assert_equal response.success, false
      assert_match "Session expired or authorization failed", response.message,
    ensure
      Progstr::Filer.secret_key = "DEMO"
    end
  end

end
