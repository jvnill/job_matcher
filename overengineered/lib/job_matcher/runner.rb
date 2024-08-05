module JobMatcher
  class Runner
    def initialize(options = {})
      input = Input.get_input(options)

      @jobseekers = input.jobseekers
      @jobs = input.jobs

      @output = Output.get_output(options)
    end

    def process
      results = jobseekers.map do |jobseeker|
        {
          jobseeker: jobseeker,
          job_matches: SkillMatcher.new(jobseeker, jobs).process
        }
      end

      output.output(sort_results(results))
    end

    private

    attr_reader :jobseekers, :jobs, :output

    def sort_results(results)
      # Sort results by jobseeker id
      results.sort! { |a, b| a[:jobseeker][:id] <=> b[:jobseeker][:id] }

      # Sort each jobseeker job matches
      results.each do |jobseeker|
        jobseeker[:job_matches].sort! do |a, b|
          if a[:matching_skills_percentage] == b[:matching_skills_percentage]
            a[:job][:id] <=> b[:job][:id]
          else
            b[:matching_skills_percentage] <=> a[:matching_skills_percentage]
          end
        end
      end
    end
  end
end
