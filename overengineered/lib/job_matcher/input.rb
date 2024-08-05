module JobMatcher
  class Input
    def self.get_input(options)
      if options && options[:jobseekers_file_path] && options[:jobs_file_path]
        Inputs::FileInput.new(options)
      else
        raise ArgumentError.new('No valid input')
      end
    end
  end
end
