$:.unshift(File.expand_path("../", __FILE__))
require "sidekiq_metrics/version"

module SidekiqMetrics
  autoload :AwsServices, 'sidekiq_metrics/aws_services'
  autoload :CLI, 'sidekiq_metrics/cli'
  autoload :Charter, 'sidekiq_metrics/charter'
  autoload :Say, 'sidekiq_metrics/say'
end
