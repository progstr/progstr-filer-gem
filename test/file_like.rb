class FileLike
  attr_accessor :size, :path

  def read
    "contents"
  end
end

class UploadedFileLike
  attr_accessor :size, :original_filename

  def read
    "contents"
  end
end
