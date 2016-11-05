$:.unshift(File.expand_path("../", __FILE__))
require "sidekiq_metrics/version"

module SidekiqMetrics
  autoload :CLI, 'sidekiq_metrics/cli'
end