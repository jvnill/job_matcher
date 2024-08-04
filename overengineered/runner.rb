require_relative 'lib/job_matcher'

options = {
  jobseekers_file_path: 'jobseekers.csv',
  jobs_file_path: 'jobs.csv'
}

JobMatcher::Runner.new(options).process
puts File.read('output.csv')
