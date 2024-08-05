require 'pry'
describe JobMatcher::Inputs::FileInput do
  context 'files do not exist' do
    it 'should raise ArgumentError if jobseeker file does not exist' do
      expect {
        JobMatcher::Inputs::FileInput.new(jobseekers_file_path: 'jobsickers.csv', jobs_file_path: 'jobz.csv')
      }.to raise_error(ArgumentError, 'File does not exists jobsickers.csv')
    end

    it 'should raise ArgumentError if job file does not exist' do
      expect {
        JobMatcher::Inputs::FileInput.new(jobseekers_file_path: 'jobseekers.csv', jobs_file_path: 'jobz.csv')
      }.to raise_error(ArgumentError, 'File does not exists jobz.csv')
    end
  end

  context 'files exist' do
    context '#jobseekers' do
      let(:file_input) { JobMatcher::Inputs::FileInput.new(jobseekers_file_path: 'jobseekers.csv', jobs_file_path: 'jobs.csv') }
      let(:skills) { 'Ruby,Python' }
      let(:csv_stub) { [{ id: 1, skills: skills }] }

      before do
        expect(CSV).to receive(:read).with('jobseekers.csv', headers: true, header_converters: :symbol).and_return(csv_stub)
      end

      it 'should return an array of jobseeker hashes' do
        expect(file_input.jobseekers).to eq([{ id: 1, skills: skills.split(',') }])
      end
    end

    context '#jobs' do
      let(:file_input) { JobMatcher::Inputs::FileInput.new(jobseekers_file_path: 'jobseekers.csv', jobs_file_path: 'jobs.csv') }
      let(:skills) { 'Ruby,Python' }
      let(:csv_stub) { [{ id: 1, required_skills: skills }] }

      before do
        expect(CSV).to receive(:read).with('jobs.csv', headers: true, header_converters: :symbol).and_return(csv_stub)
      end

      it 'should return an array of job hashes' do
        expect(file_input.jobs).to eq([{ id: 1, required_skills: skills.split(',') }])
      end
    end
  end
end
