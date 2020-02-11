# frozen_string_literal: true

require 'logger'

module DirClean
  class Cleaner
    DEFAULT_LOG_FILE_PATH = '/tmp/dirclean.log'

    def initialize(file_system_wrapper: FileSystemWrapper.new,
                   logger: Logger.new(DEFAULT_LOG_FILE_PATH),
                   retention_days: 30)
      @file_system_wrapper = file_system_wrapper
      @logger              = logger
      @retention_period    = retention_days * 24 * 60 * 60
    end

    def clean(directory_path, current_time = Time.now)
      directory_entries = file_system_wrapper.directory_contents(directory_path)
      logger.info { "Analyzing #{directory_entries.size} entries inside '#{directory_path}'" }
      directory_entries.each { |file_name| delete_entry_if_outdated(file_name, current_time) }
      logger.info { "Cleanup finished in #{Time.now - current_time} seconds" }
    rescue StandardError => e
      logger.error { "Unexpected error occurred: #{e.message}" }
      raise e
    end

    private

    attr_reader :file_system_wrapper, :logger, :retention_period

    def delete_entry_if_outdated(file_name, current_time)
      if file_system_wrapper.directory?(file_name)
        delete_directory_if_outdated(file_name, current_time)
      else
        delete_file_if_outdated(file_name, current_time)
      end
    end

    def delete_directory_if_outdated(file_name, current_time)
      return unless directory_outdated?(file_name, current_time)

      file_system_wrapper.remove_directory(file_name)
      logger.info { "Removed '#{file_name}' directory" }
    end

    def delete_file_if_outdated(file_name, current_time)
      return unless file_outdated?(file_name, current_time)

      file_system_wrapper.remove_file(file_name)
      logger.info { "Removed '#{file_name}' file" }
    end

    def directory_outdated?(dir_path, current_time)
      directory_last_atime = directory_last_access_time(dir_path)

      passed_retention_time?(current_time, directory_last_atime)
    end

    def file_outdated?(file_path, current_time)
      access_time = file_system_wrapper.file_last_access_time(file_path)
      passed_retention_time?(current_time, access_time)
    end

    def passed_retention_time?(current_time, time)
      current_time - time > retention_period
    end

    def directory_last_access_time(dir_path)
      max_atime = Time.at(0)

      file_system_wrapper.directory_contents(dir_path).each do |dir_entry|
        atime     = if file_system_wrapper.directory?(dir_entry)
                      directory_last_access_time(dir_entry)
                    else
                      file_system_wrapper.file_last_access_time(dir_entry)
                    end

        max_atime = atime if atime > max_atime
      end

      max_atime
    end
  end
end
