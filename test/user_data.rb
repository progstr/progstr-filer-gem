dbconfig = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}

ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Migration.verbose = false

class UserMigration < ActiveRecord::Migration
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


class User < ActiveRecord::Base
  has_file :avatar, MockUploader
end

class ValidatedUser < User
  validates_presence_of :avatar
  validates_file_size :avatar,
    :less_than => 2 * 1024 * 1024,
    :message => "Not uploading more than 2 MB."
  validates_file_extension :avatar, :allowed => ["png", "jpg"],
    :message => "Avatar image extension not allowed."
end

class UserTest < Test::Unit::TestCase
  def setup
    UserMigration.up
  end

  def teardown
    UserMigration.down
  end
end
