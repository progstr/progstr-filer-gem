require 'test_helper'

$lastUploadedAtachment = nil

class MockUploader < Progstr::Filer::Uploader
  def upload_attachment(attachment)
    $lastUploadedAtachment = attachment
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
end
