require 'thor'
require 'sidekiq_metrics/cli/help'

module SidekiqMetrics

  class CLI < Thor
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "chart", "sends Sidekiq metrics to CloudWatch"
    long_desc Help.chart
    option :once, type: :boolean, desc: "Sends metric once and stops"
    option :dimension, desc: "CloudWatch app dimension for metric."
    def chart
      Charter.new(options).loop
    end
  end
end
