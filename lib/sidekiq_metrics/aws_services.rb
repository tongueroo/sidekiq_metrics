module SidekiqMetrics
  module AwsServices
    def cloudwatch
      @cloudwatch ||= Aws::CloudWatch::Client.new(region: region)
    end

    def region
      ENV['REGION'] || 'us-east-1'
    end
  end
end
