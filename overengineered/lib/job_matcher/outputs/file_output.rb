require 'csv'

module JobMatcher
  module Outputs
    class FileOutput
      HEADERS = %w[jobseeker_id jobseeker_name job_id job_title matching_skill_count matching_skill_percent]

      def output(results)
        CSV.open('output.csv', 'w') do |csv|
          csv << HEADERS

          results.each do |jobseeker|
            jobseeker[:job_matches].each do |job|
              csv << [
                jobseeker[:jobseeker][:id],
                jobseeker[:jobseeker][:name],
                job[:job][:id],
                job[:job][:title],
                job[:matching_skills_count],
                job[:matching_skills_percentage].round(2)
              ]
            end
          end
        end
      end
    end
  end
end
