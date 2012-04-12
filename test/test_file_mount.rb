require 'test_helper'

class TestFileMount < UserTest
  should "start with an empty uploader field" do
    empty = User.new
    assert_true empty.avatar.blank?
  end

  should "create an uploader when given a file" do
    non_empty = User.new
    non_empty.avatar = FileMock.new
    assert_false non_empty.avatar.blank?
  end

  should "create an uploader when given an id string" do
    non_empty = User.new
    non_empty.avatar = "some-string-id"
    assert_false non_empty.avatar.blank?
    assert_equal "some-string-id", non_empty.avatar.id
  end

  should "create an uploader when given file info JSON string" do
    json = '{"id":"7933ad9a0f93457ab625a070fec3544f","name":"test.png","size":100}'

    non_empty = User.new
    non_empty.avatar = json
    assert_false non_empty.avatar.blank?
    assert_equal "7933ad9a0f93457ab625a070fec3544f", non_empty.avatar.id
    assert_equal "test.png", non_empty.avatar.path
    assert_equal 100, non_empty.avatar.size
  end

  should "persist attachment id only" do
    u = User.new
    u.avatar = FileMock.new
    assert_not_nil u.avatar.id, "attachment id generated"
    assert_equal u.read_attribute(:avatar), u.avatar.id, "attachment id saved to db"
  end

  should "save and load attachment id to db" do
    u = User.new
    u.avatar = FileMock.new
    u.save!

    loaded = User.find(u.id)
    assert_equal loaded.read_attribute(:avatar), u.avatar.id, "Loaded avatar id from db"
    assert_equal loaded.avatar.id, u.avatar.id, "Loaded avatar id matches the saved one."
  end
end
