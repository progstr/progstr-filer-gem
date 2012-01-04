require 'test_helper'

class ValidatedUser < User
  validates_presence_of :avatar
end

class TestValidation < UserTest
  test "don't store without attachment" do
    u = ValidatedUser.new
    assert_equal false, u.valid?, "User not valid without an avatar"
  end
end
