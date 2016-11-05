module SidekiqMetrics
  module Say
    def say(msg)
      $stdout.sync = true
      if @options[:noop]
        puts "NOOP: #{msg}"
      else
        puts msg
      end
    end
  end
end
