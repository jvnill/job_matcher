describe JobMatcher::Runner do
  let(:options) { double }
  let(:jobseekers) { [] }
  let(:jobs) { [] }
  let(:input) { double(jobseekers: jobseekers, jobs: jobs) }
  let(:output) { double }
  let(:runner) { JobMatcher::Runner.new(options) }

  before do
    expect(JobMatcher::Input).to receive(:get_input).with(options).and_return(input)
    expect(JobMatcher::Output).to receive(:get_output).with(options).and_return(output)
  end

  context 'no input' do
    it 'should output nothing' do
      expect(output).to receive(:output).with([])
      runner.process
    end
  end

  context 'single jobseeker' do
    let(:jobseekers) do
      [{
        id: 1,
        name: 'Peter Parker',
        skills: ['Ruby', 'SQL']
      }]
    end

    context 'no match' do
      let(:jobs) do
        [{
          id: 1,
          title: 'Java Platform Engineer',
          required_skills: ['Java', 'Kubernetes']
        }]
      end

      before do
        expect_any_instance_of(JobMatcher::SkillMatcher).to receive(:process).and_return([])
      end

      it 'should output nothing' do
        expect(output).to receive(:output).with(
          [{
            jobseeker: jobseekers[0],
            job_matches: []
          }]
        )

        runner.process
      end
    end

    context 'with match' do
      let(:jobs) do
        [{
          id: 1,
          title: 'Ruby Engineer',
          required_skills: ['Ruby']
        }, {
          id: 2,
          title: 'Ruby Platform Engineer',
          required_skills: ['Ruby', 'Kubernetes']
        }]
      end

      before do
        expect_any_instance_of(JobMatcher::SkillMatcher).to receive(:process).and_call_original
      end

      it 'should output the matches ordered by match percentage' do
        expect(output).to receive(:output).with(
          [{
            jobseeker: jobseekers[0],
            job_matches: [{
              job: jobs[0],
              matching_skills: ['Ruby'],
              matching_skills_count: 1,
              matching_skills_percentage: 100
            }, {
              job: jobs[1],
              matching_skills: ['Ruby'],
              matching_skills_count: 1,
              matching_skills_percentage: 50
            }]
          }]
        )

        runner.process
      end
    end

    context 'with match that has the same matching percentage' do
      let(:jobs) do
        [{
          id: 3,
          title: 'Ruby Platform Engineer 3',
          required_skills: ['Ruby', 'Kubernetes']
        }, {
          id: 2,
          title: 'Ruby Platform Engineer 2',
          required_skills: ['Ruby', 'Kubernetes']
        }, {
          id: 1,
          title: 'Ruby Platform Engineer 1',
          required_skills: ['Ruby', 'Kubernetes']
        }]
      end

      before do
        expect_any_instance_of(JobMatcher::SkillMatcher).to receive(:process).and_call_original
      end

      it 'should output the matches ordered by job id' do
        expect(output).to receive(:output).with(
          [{
            jobseeker: jobseekers[0],
            job_matches: [{
              job: jobs[2],
              matching_skills: ['Ruby'],
              matching_skills_count: 1,
              matching_skills_percentage: 50
            }, {
              job: jobs[1],
              matching_skills: ['Ruby'],
              matching_skills_count: 1,
              matching_skills_percentage: 50
            }, {
              job: jobs[0],
              matching_skills: ['Ruby'],
              matching_skills_count: 1,
              matching_skills_percentage: 50
            }]
          }]
        )

        runner.process
      end
    end
  end
end
