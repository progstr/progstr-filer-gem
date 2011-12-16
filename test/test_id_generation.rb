require 'test_helper'

class TestIdGeneration < Test::Unit::TestCase
  should "attachment IDs are UUIDs" do
    a = Progstr::Filer::Attachment.from_file(FileLike.new)
    b = Progstr::Filer::Attachment.from_file(FileLike.new)

    assert_not_nil a.id
    assert_not_nil b.id
    assert_not_equal a.id, b.id
  end

  should "attachment IDs have hyphens removed" do
    a = Progstr::Filer::Attachment.from_file(FileLike.new)
    assert_match /^[^-]+$/, a.id, "IDs should contain no hyphens"
  end
end
