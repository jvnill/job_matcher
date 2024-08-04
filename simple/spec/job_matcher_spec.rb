require 'spec_helper'

describe JobMatcher do
  before do
    FileUtils.rm_rf('output.csv')
  end

  it 'should return an error when jobseeker file does not exists' do
    expect { JobMatcher.new('spec/support/files/jobseekers.csv', 'test.csv') }.to raise_error(ArgumentError, 'Missing Job file')
    expect { JobMatcher.new('test.csv', 'spec/support/files/jobs.csv') }.to raise_error(ArgumentError, 'Missing Jobseeker file')
  end

  it 'should not raise an error if both files exists' do
    expect { JobMatcher.new('spec/support/files/jobseekers.csv', 'spec/support/files/jobs.csv') }.not_to raise_error
  end

  it 'should return nothing when there is no match' do
    expect { JobMatcher.new('spec/support/files/jobseekers_no_match.csv', 'spec/support/files/jobs.csv').process }.not_to raise_error
    expect(File.exist?('output.csv')).to eq(true)

    output = CSV.read('output.csv', headers: true)

    expect(output.length).to eq(0)
  end

  it 'should return match ordered by jobseeker id' do
    expect { JobMatcher.new('spec/support/files/ruby_jobseekers.csv', 'spec/support/files/ruby_jobs.csv').process }.not_to raise_error
    expect(File.exist?('output.csv')).to eq(true)

    output = CSV.read('output.csv', headers: true)
    jobseeker_ids = output.map { |row| row['jobseeker_id'] }

    expect(jobseeker_ids).to eq(jobseeker_ids.sort)
  end

  it 'should return match ordered by match percentage' do
    expect { JobMatcher.new('spec/support/files/multiskill_jobseekers.csv', 'spec/support/files/jobs.csv').process }.not_to raise_error
    expect(File.exist?('output.csv')).to eq(true)

    output = CSV.read('output.csv', headers: true)
    skill_percentage = output.map { |row| row['matching_skill_percentage'] }

    expect(skill_percentage).to eq(skill_percentage.sort)
  end
end
