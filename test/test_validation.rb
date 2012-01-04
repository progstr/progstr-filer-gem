require 'test_helper'

class TestValidation < UserTest
  test "don't store without attachment" do
    u = ValidatedUser.new
    assert_false u.valid?, "User not valid without an avatar"
  end

  test "don't store if size greater than 2MB" do
    u = ValidatedUser.new
    too_big = FileLike.new
    too_big.path = "too_big.png"
    too_big.size = 5 * 1024 * 1024
    u.avatar = too_big
    assert_false u.valid?, "User not valid with huge avatar"
    assert_equal u.errors[:avatar_file_size], ["Not uploading more than 2 MB."]
  end

  test "don't store if extension not allowed" do
    u = ValidatedUser.new
    exe = FileLike.new
    exe.path = "virus_infected.exe"
    u.avatar = exe

    assert_false u.valid?, "User not valid with 'exe' avatar extension."
    assert_equal u.errors[:avatar_file_extension], ["Avatar image extension not allowed."]
  end

  test "validation passes" do
    u = ValidatedUser.new
    jpg = FileLike.new
    jpg.path = "avatar.jpg"
    u.avatar = jpg

    assert_true u.valid?, "Validation passed."
  end
end
