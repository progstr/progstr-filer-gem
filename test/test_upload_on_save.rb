require 'test_helper'

$lastUploadedAtachment = nil
$lastDeletedAtachment = nil

class MockUploader < Progstr::Filer::Uploader
  def upload_attachment(attachment)
    $lastUploadedAtachment = attachment
  end
  def delete_attachment(attachment)
    $lastDeletedAtachment = attachment
  end
end

class NotUploadingUser < User
  has_uploader :avatar, MockUploader
end

class TestUploadOnSave < UserTest
  should "upload file on record save" do
    u = NotUploadingUser.new
    f = FileLike.new
    u.avatar = f

    u.save!
    assert_same $lastUploadedAtachment.file, f, "avatar file sent to uploader"
  end

  should "delete the previous attachment on save" do
    u = NotUploadingUser.new
    f1 = FileLike.new
    u.avatar = f1
    u.save!

    f2 = FileLike.new
    u.avatar = f2

    u.save!
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
  end
end
