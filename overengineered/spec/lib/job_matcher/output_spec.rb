describe JobMatcher::Output do
  context 'self.get_input' do
    context 'file output' do
      it 'should use file input if file paths are passed' do
        expect(JobMatcher::Outputs::FileOutput).to receive(:new)

        JobMatcher::Output.get_output(nil)
      end
    end
  end
end
