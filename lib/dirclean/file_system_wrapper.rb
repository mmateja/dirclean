# frozen_string_literal: true
module DirClean
  class FileSystemWrapper
    def directory_contents(dir_path)
      dir_pattern = dir_path.gsub('[', '\[').gsub(']', '\]')
      Dir.glob(File.join(dir_pattern, '*'))
    end

    def file_last_access_time(file_path)
      [File.atime(file_path), File.mtime(file_path)].max
    end

    def directory?(file_path)
      File.directory?(file_path)
    end

    def remove_file(file_path)
      `rm "#{file_path}"`
    end

    def remove_directory(dir_path)
      `rm -r "#{dir_path}"`
    end
  end
end
