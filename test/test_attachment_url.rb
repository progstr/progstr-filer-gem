require 'test_helper'

class TestIdGeneration < Test::Unit::TestCase
  should "generate file URLs using accessKey and file ID" do
    a = Progstr::Filer::Attachment.from_id(:avatar, "some-attachment-id")

    assert_match "/files/data/DEMO/some-attachment-id", a.url
    assert_match Progstr::Filer.host, a.url
    assert_match Progstr::Filer.host, a.url
  end
end
