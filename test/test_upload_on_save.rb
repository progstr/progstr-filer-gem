require 'test_helper'

class TestUploadOnSave < UserTest
  should "upload file on record save" do
    u = User.new
    f = FileMock.new
    u.avatar = f

    u.save!
    assert_same $lastUploadedAtachment.file, f, "avatar file sent to uploader"
  end

  should "not upload JSON-created attachments" do
    $lastUploadedAtachment = nil

    u = User.new
    json = '{"id":"7933ad9a0f93457ab625a070fec3544f","name":"test.png","size":100}'
    u.avatar = json

    u.save!
    assert_nil $lastUploadedAtachment
  end

  should "save id only when JSON-created" do
    $lastUploadedAtachment = nil

    u = User.new
    json = '{"id":"7933ad9a0f93457ab625a070fec3544f","name":"test.png","size":100}'
    u.avatar = json
    saved_id = u.read_attribute(:avatar)
    assert_equal "7933ad9a0f93457ab625a070fec3544f", saved_id
  end

  should "delete the previous attachment on save" do
    u = User.new
    f1 = FileMock.new
    u.avatar = f1
    u.save!

    f2 = FileMock.new
    u.avatar = f2

    u.save!
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
  end

  should "delete previous attachment and null attribute if set to nil" do
    u = User.new
    f1 = FileMock.new
    u.avatar = f1
    u.save!

    u.avatar = nil

    u.save!
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
    assert_true u.avatar.blank?
    assert_nil u.read_attribute(:avatar)
  end

  should "delete attachments on record delete" do
    u = User.new
    f1 = FileMock.new
    u.avatar = f1
    u.save!

    # Note that calling `delete` doesn't run the before_destroy hook and attachments won't get deleted
    # u.delete
    u.destroy
    assert_same $lastDeletedAtachment.file, f1, "overwritten attachment deleted"
  end
end
