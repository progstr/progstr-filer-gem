require 'test_helper'

class TestIdGeneration < Test::Unit::TestCase
  should "generate file URLs using accessKey and file ID" do
    a = Progstr::Filer::Attachment.from_id(:avatar, "some-attachment-id")

    assert_match "/files/data/DEMO/some-attachment-id", a.url
    assert_match Progstr::Filer.host, a.url
    assert_match Progstr::Filer.host, a.url
  end

  should "roundtrip from and to JSON" do
    json = '{"id":"7933ad9a0f93457ab625a070fec3544f","name":"test.png","size":100}'
    a = Progstr::Filer::Attachment.from_json(:avatar, json)

    new_json = a.display_json

    assert_match "7933ad9a0f93457ab625a070fec3544f", new_json
    assert_match "test.png", new_json
    assert_match "100", new_json
  end
end
