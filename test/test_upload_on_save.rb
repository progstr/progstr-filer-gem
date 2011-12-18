require 'test_helper'

class TestUploadOnSave < UserTest
  should "upload file on record save" do
    u = User.new
    f = FileLike.new
    u.avatar = f

    u.save!
    assert_same $lastUploadedAtachment.file, f, "avatar file sent to uploader"
  end

  should "delete the previous attachment on save" do
    u = User.new
    f1 = FileLike.new
    u.avatar = f1
    u.save!

    f2 = FileLike.new
    u.avatar = f2

    u.save!
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
  end

  should "delete attachments on record delete" do
    u = User.new
    f1 = FileLike.new
    u.avatar = f1
    u.save!

    # Note that calling `delete` doesn't run the before_destroy hook and attachments won't get deleted
    # u.delete
    u.destroy
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
  end
end
