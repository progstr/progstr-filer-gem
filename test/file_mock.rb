class FileMock
  attr_accessor :size, :path

  def read
    "contents"
  end
end

class UploadedFileMock
  attr_accessor :size, :original_filename

  def read
    "contents"
  end
end
