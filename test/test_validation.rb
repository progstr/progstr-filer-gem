require 'test_helper'

class TestValidation < UserTest
  test "don't store without attachment" do
    u = ValidatedUser.new
    assert_false u.valid?, "User not valid without an avatar"
  end

  test "don't store if size greater than 2MB" do
    u = ValidatedUser.new
    too_big = FileMock.new
    too_big.path = "too_big.png"
    too_big.size = 5 * 1024 * 1024
    u.avatar = too_big
    assert_false u.valid?, "User not valid with huge avatar"
    assert_equal u.errors[:avatar], ["Not uploading more than 2 MB."]
  end

  test "don't store if extension not allowed" do
    u = ValidatedUser.new
    exe = FileMock.new
    exe.path = "virus_infected.exe"
    u.avatar = exe

    assert_false u.valid?, "User not valid with 'exe' avatar extension."
    assert_equal u.errors[:avatar], ["Avatar image extension not allowed."]
  end

  test "use original_filename on file objects if present" do
    u = ValidatedUser.new
    exe = UploadedFileMock.new
    exe.original_filename = "virus_infected.exe"
    u.avatar = exe

    assert_false u.valid?, "User not valid with 'exe' avatar extension."
    assert_equal u.errors[:avatar], ["Avatar image extension not allowed."]
  end

  test "don't store files without an extension" do
    u = ValidatedUser.new
    exe = FileMock.new
    exe.path = "noextension"
    u.avatar = exe

    assert_false u.valid?, "User not valid with an avatar without a file extension."
    assert_equal u.errors[:avatar], ["Avatar image extension not allowed."]
  end

  test "don't validate prevalidated attachments on record update" do
    u = ValidatedUser.new
    u.name = "John"
    avatar = File.open("test/adium-green-duckling.png")
    u.avatar = avatar
    save_success = u.save
    assert_true save_success, "Initially valid."

    loaded = ValidatedUser.find(u.id)
    loaded.name = "Jim"
    save_success = loaded.save
    assert_true save_success, "Still valid on update when attachment not modified."
  end

  test "validation passes" do
    u = ValidatedUser.new
    jpg = FileMock.new
    jpg.path = "avatar.jpg"
    u.avatar = jpg

    assert_true u.valid?, "Validation passed."
  end
end
