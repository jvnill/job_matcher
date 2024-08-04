module JobMatcher
  class SkillMatcher
    def initialize(jobseeker, jobs)
      @jobseeker = jobseeker
      @jobs = jobs
    end

    def process
      [].tap do |matches|
        jobs.each do |job|
          skill_matches = jobseeker[:skills] & job[:required_skills]

          next if skill_matches.size == 0

          matches << {
            job: job,
            matching_skills: skill_matches,
            matching_skills_count: skill_matches.size,
            matching_skills_percentage: (skill_matches.size / job[:required_skills].size.to_f) * 100
          }
        end
      end
    end

    private

    attr_reader :jobseeker, :jobs
  end
end
