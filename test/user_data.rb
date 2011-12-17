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


class UserTest < Test::Unit::TestCase
  def setup
    TestUserMigration.up
  end

  def teardown
    TestUserMigration.down
  end
end
