require 'fileutils'

class File
  def self.deep_write(file, content)
    dir = File.dirname file
    FileUtils.mkdir_p dir
    File.write file, content
  end
end
