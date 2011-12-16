require 'test_helper'

dbconfig = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Migration.verbose = false

class TestUserMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :name, :string
      t.column :avatar, :string
    end
  end

  def self.down
    drop_table :users
  end
end

class AvatarUploader < Progstr::Filer::Uploader
end

class User < ActiveRecord::Base
  has_uploader :avatar, AvatarUploader
end

class FileLike
  def read
    "contents"
  end
end

class TestFileMount < Test::Unit::TestCase
  def setup
    TestUserMigration.up
  end

  def teardown
    TestUserMigration.down
  end

  should "start with an empty uploader field" do
    empty = User.new
    assert_true empty.avatar.empty?
  end

  should "create an uploader when given a file" do
    non_empty = User.new
    non_empty.avatar = FileLike.new
    assert_false non_empty.avatar.empty?
  end

  should "save persist attachment id only" do
    u = User.new
    u.avatar = FileLike.new
    assert_not_nil u.avatar.id, "attachment id generated"
    assert_equal u.read_attribute(:avatar), u.avatar.id, "attachment id saved to db"
  end

  should "save and load attachment id to db" do
    u = User.new
    u.avatar = FileLike.new
    u.save!

    loaded = User.find(u.id)
    assert_equal loaded.read_attribute(:avatar), u.avatar.id, "Loaded avatar id from db"
    assert_equal loaded.avatar.id, u.avatar.id, "Loaded avatar id matches the saved one."
  end
end
