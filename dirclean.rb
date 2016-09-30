#!/usr/bin/env ruby
require 'logger'

SCRIPT_START_TIME = Time.new
RETENTION_TIME    = 30 * 24 * 60 * 60 # 30 days

def show_help
  puts 'Removes files and folders that were not accessed for over 30 days'
  puts "usage: #{__FILE__} directory"
end

def directory_contents(dir_path)
  dir_pattern = dir_path.gsub('[', '\[').gsub(']', '\]')
  Dir.glob(File.join(dir_pattern, '*'))
end

def passed_retention_time?(time)
  SCRIPT_START_TIME - time > RETENTION_TIME
end

def file_last_access_time(file_path)
  [File.atime(file_path), File.mtime(file_path)].max
end

def file_outdated?(file_path)
  access_time = file_last_access_time(file_path)
  passed_retention_time?(access_time)
end

def directory_last_access_time(dir_path)
  max_atime = Time.at(0)

  directory_contents(dir_path).each do |file_path|
    atime     = if File.directory?(file_path)
                  directory_last_access_time(file_path)
                else
                  file_last_access_time(file_path)
                end

    max_atime = atime if atime > max_atime
  end

  max_atime
end

def directory_outdated?(dir_path)
  directory_last_atime = directory_last_access_time(dir_path)

  passed_retention_time?(directory_last_atime)
end

def remove_file(file_path)
  `rm "#{file_path}"`
end

def remove_directory(dir_path)
  `rm -r "#{dir_path}"`
end

if ARGV.size != 1
  show_help
  exit
end

logger = Logger.new(File.join(File.dirname(__FILE__), 'dirclean.log'))

directory_path     = ARGV.first
directory_contents = directory_contents(directory_path)

logger.info("Analyzing #{directory_contents.size} entries inside '#{directory_path}'")

directory_contents.each do |file_name|
  if File.directory?(file_name)
    if directory_outdated?(file_name)
      remove_directory(file_name)
      logger.info("Removed '#{file_name}' directory")
    end
  else
    if file_outdated?(file_name)
      remove_file(file_name)
      logger.info("Removed '#{file_name}' file")
    end
  end
end

logger.info("Cleanup finished in #{Time.new - SCRIPT_START_TIME} seconds")