require 'csv'

module JobMatcher
  module Inputs
    class FileInput
      def initialize(options)
        @options = options

        require_file!(jobseekers_file_path)
        require_file!(jobs_file_path)
      end

      def jobseekers
        csv = CSV.read(jobseekers_file_path, headers: true, header_converters: :symbol)

        csv.map do |row|
          row.to_h.merge(
            id: row[:id].to_i,
            skills: row[:skills].split(',').map(&:strip)
          )
        end
      end

      def jobs
        csv = CSV.read(jobs_file_path, headers: true, header_converters: :symbol)

        csv.map do |row|
          row.to_h.merge(
            id: row[:id].to_i,
            required_skills: row[:required_skills].split(',').map(&:strip)
          )
        end
      end

      private

      attr_reader :options

      def jobseekers_file_path
        @jobseekers_file_path ||= options[:jobseekers_file_path]
      end

      def jobs_file_path
        @jobs_file_path ||= options[:jobs_file_path]
      end

      def require_file!(path)
        raise ArgumentError.new("File does not exists #{path}") unless File.exist?(path)
      end
    end
  end
end
