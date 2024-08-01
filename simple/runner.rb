require_relative 'job_matcher'

JobMatcher.new(ARGV[0], ARGV[1]).process
puts File.read('output.csv')
