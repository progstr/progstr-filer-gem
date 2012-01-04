require 'test_helper'

class TestValidation < UserTest
  test "don't store without attachment" do
    u = ValidatedUser.new
    assert_false u.valid?, "User not valid without an avatar"
  end

  test "don't store if size greater than 2MB" do
    u = ValidatedUser.new
    too_big = FileLike.new
    too_big.size = 5 * 1024 * 1024
    u.avatar = too_big
    assert_false u.valid?, "User not valid with huge avatar"
    assert_equal u.errors[:avatar_file_size], ["Not uploading more than 2 MB."]
  end
end
