class FileInfo
  def initialize(values)
    @values = values
  end

  def id
    @values["_id"]
  end
  def name
    @values["name"]
  end
  def content_type
    @values["contentType"]
  end
  def property
    @values["property"]
  end
  def uploader
    @values["uploader"]
  end
  def size
    @values["size"]
  end
  def created_at
    @values["createdAt"]
  end
end
