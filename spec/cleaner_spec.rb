# frozen_string_literal: true

require_relative 'spec_helper'

describe DirClean::Cleaner do
  subject { DirClean::Cleaner.new(file_system_wrapper: file_system_wrapper, logger: logger) }

  describe '#clean' do
    class DummyLogger
      def info; end
    end

    let(:file_system_wrapper) { MiniTest::Mock.new }
    let(:logger) { DummyLogger.new }

    let(:time_now) { Time.now }
    let(:expected_retention_period) { 30 * 24 * 60 * 60 }
    let(:cleaned_dir_path) { '/cleaned/directory/path' }
    let(:file_path) { '/cleaned/directory/path/file' }
    let(:dir_path) { '/cleaned/directory/path/directory' }
    let(:file_inside_path) { '/cleaned/directory/path/directory/file_inside' }

    it 'removes file with access time more than 30 days ago' do
      file_system_wrapper.expect(:directory_contents, [file_path], [cleaned_dir_path])
      file_system_wrapper.expect(:directory?, false, [file_path])
      file_system_wrapper.expect(:file_last_access_time, time_now - expected_retention_period - 1, [file_path])
      file_system_wrapper.expect(:remove_file, nil, [file_path])

      subject.clean(cleaned_dir_path, time_now)

      file_system_wrapper.verify
    end

    it 'does not remove file with access time less than 30 days ago' do
      file_system_wrapper.expect(:directory_contents, [file_path], [cleaned_dir_path])
      file_system_wrapper.expect(:directory?, false, [file_path])
      file_system_wrapper.expect(:file_last_access_time, time_now - expected_retention_period, [file_path])

      subject.clean(cleaned_dir_path, time_now)

      file_system_wrapper.verify
    end

    it 'removes directory with no files accessed during last 30 days' do
      file_system_wrapper.expect(:directory_contents, [dir_path], [cleaned_dir_path])
      file_system_wrapper.expect(:directory?, true, [dir_path])
      file_system_wrapper.expect(:directory_contents, [file_inside_path], [dir_path])
      file_system_wrapper.expect(:directory?, false, [file_inside_path])
      file_system_wrapper.expect(:file_last_access_time, time_now - expected_retention_period - 1, [file_inside_path])
      file_system_wrapper.expect(:remove_directory, nil, [dir_path])

      subject.clean(cleaned_dir_path, time_now)

      file_system_wrapper.verify
    end

    it 'does not remove directory with files accessed during last 30 days' do
      file_system_wrapper.expect(:directory_contents, [dir_path], [cleaned_dir_path])
      file_system_wrapper.expect(:directory?, true, [dir_path])
      file_system_wrapper.expect(:directory_contents, [file_inside_path], [dir_path])
      file_system_wrapper.expect(:directory?, false, [file_inside_path])
      file_system_wrapper.expect(:file_last_access_time, time_now - expected_retention_period + 1, [file_inside_path])

      subject.clean(cleaned_dir_path, time_now)

      file_system_wrapper.verify
    end
  end
end
