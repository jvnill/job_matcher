describe JobMatcher::SkillMatcher do
  let(:jobseeker_skills) { ['Ruby'] }
  let(:jobseeker) { { skills: jobseeker_skills } }
  let(:jobs) { [] }
  let(:skill_matcher) { JobMatcher::SkillMatcher.new(jobseeker, jobs) }

  context 'no matching skills' do
    let(:jobs) do
      [
        { required_skills: ['C#'] },
        { required_skills: ['Python'] }
      ]
    end

    it 'should return empty array' do
      expect(skill_matcher.process).to eq([])
    end
  end

  context 'matching skills' do
    let(:jobs) do
      [
        { required_skills: ['Ruby'] },
        { required_skills: ['Python', 'Ruby'] }
      ]
    end

    let(:expected_output) do
      [{
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
    end

    it 'should return array with percentage match' do
      expect(skill_matcher.process).to eq(expected_output)
    end
  end
end
