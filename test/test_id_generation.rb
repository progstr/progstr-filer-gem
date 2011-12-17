require 'test_helper'

class TestIdGeneration < Test::Unit::TestCase
  should "use UUIDs for attachment IDs" do
    a = Progstr::Filer::Attachment.from_file(:avatar, FileLike.new)
    b = Progstr::Filer::Attachment.from_file(:avatar, FileLike.new)

    assert_not_nil a.id
    assert_not_nil b.id
    assert_not_equal a.id, b.id
  end

  should "have attachment IDs with no hyphens" do
    a = Progstr::Filer::Attachment.from_file(:avatar, FileLike.new)
    assert_match /^[^-]+$/, a.id, "IDs should contain no hyphens"
  end
end
