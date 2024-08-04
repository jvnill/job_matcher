module JobMatcher
  class Output
    def self.get_output(_)
      Outputs::FileOutput.new
    end
  end
end
