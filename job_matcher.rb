require 'csv'

class JobMatcher
  def initialize(jobseeker_csv_path, job_csv_path)
    @jobseekers = read_csv(jobseeker_csv_path, 'Jobseeker')
    @jobs = read_csv(job_csv_path, 'Job')

  rescue ArgumentError => e
    puts e
    exit 0
  end

  # jobseekers have 3 columns named id, name, skills
  # jobs have 3 columns named id, title, required_skills
  #
  #
  def process
    headers = %w[jobseeker_id jobseeker_name job_id job_title matching_skill_count matching_skill_percent]

    CSV.open('output.csv', 'w') do |csv|
      csv << headers

      sorted_jobseekers.each do |jobseeker|
        job_matches = get_job_matches(jobseeker)

        sort_job_matches(job_matches).each do |job|
          csv << [
            jobseeker['id'],
            jobseeker['name'],
            job['id'],
            job['title'],
            job['matching_skill_count'],
            job['matching_skill_percentage']
          ]
        end
      end
    end
  end

  private

  attr_reader :jobseekers, :jobs

  def get_job_matches(jobseeker)
    [].tap do |matches|
      jobseeker_skills = jobseeker['skills'].split(',').map(&:strip)

      jobs.each do |job|
        required_skills = job['required_skills'].split(',').map(&:strip)
        matching_skills = required_skills & jobseeker_skills

        next unless matching_skills.any?

        matches << {
          'id' => job['id'],
          'title' => job['title'],
          'matching_skill_count' => matching_skills.size,
          'matching_skill_percentage' => ((matching_skills.size / required_skills.size.to_f) * 100).round(2)
        }
      end
    end
  end

  def read_csv(path, description)
    raise ArgumentError.new("Missing #{description} file") if !path || !File.exist?(path)

    CSV.read(path, headers: true)
  end

  def sort_job_matches(job_matches)
    job_matches.sort do |a, b|
      if a['matching_skill_percentage'] == b['matching_skill_percentage']
        a['id'].to_i <=> b['id'].to_i
      else
        b['matching_skill_percentage'] <=> a['matching_skill_percentage']
      end
    end
  end

  def sorted_jobseekers
    jobseekers.sort { |a,b| a['id'].to_i <=> b['id'].to_i }
  end
end

JobMatcher.new(ARGV[0], ARGV[1]).process
puts File.read('output.csv')
