describe JobMatcher::Input do
  context 'self.get_input' do
    context 'invalid input' do
      it 'should raise ArgumentError if invalid input' do
        expect { JobMatcher::Input.get_input(nil) }.to raise_error(ArgumentError, 'No valid input')
      end
    end

    context 'valid input' do
      context 'file input' do
        let(:options) do
          {
            jobseekers_file_path: '',
            jobs_file_path: ''
          }
        end

        it 'should use file input if file paths are passed' do
          expect(JobMatcher::Inputs::FileInput).to receive(:new).with(options)

          JobMatcher::Input.get_input(options)
        end
      end
    end
  end
end
