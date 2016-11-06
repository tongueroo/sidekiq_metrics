require "pp"
require "aws-sdk"
require "sidekiq/api"
require "byebug"

module SidekiqMetrics
  class Charter
    include Say
    include AwsServices

    def initialize(options)
      $stdout.sync = true
      @options = options
      @sleep_period = options[:sleep] || 60

      trap("INT") { puts "Shutting down."; exit }
    end

    def loop
      while true
        plot
        exit if @options[:once]
        say "Chart data sent!  Waiting for #{@sleep_period} seconds before sending metrics data again..."
        sleep(@sleep_period)
      end
    end

    def plot
      data = {
        queue_size: stats.enqueued,
        queues: stats.queues,
        busy: Sidekiq::Workers.new.size,
        retries: stats.retry_size,
        latency: total_latency
      }
      print_data(data)
      metrics = build_metrics(data)
      send_to_cloudwatch(metrics)
      puts "sidekiq metrics sent to CloudWatch"
    end

    def build_metrics(data)
      metrics = []
      data.each do |metric_name, count|
        # whitelist only the metrics I'm using to save costs
        next unless [:latency].include?(metric_name)
        metric = {
          metric_name: camelize(metric_name),
          timestamp: Time.now,
          value: count,
          unit: "Count"
        }
        metric[:dimensions] = [{
          name: "App",
          value: @options[:dimension]
        }] if @options[:dimension]
        metrics << metric
      end
      metrics
    end

    def camelize(snake_case)
      snake_case.to_s.split('_').collect(&:capitalize).join
    end

    # Send capacity metrics to CloudWatch
    def send_to_cloudwatch(metrics)
      if @options[:noop]
        say(metrics)
      else
        cloudwatch.put_metric_data(
          namespace: "Sidekiq",
          metric_data: metrics # required
        )
      end
    end

    def print_data(data)
      pp data
    end

    # total latency across all queues
    def total_latency
      queues = stats.queues.keys
      queues.inject(0) do |sum,queue_name|
        sum += Sidekiq::Queue.new(queue_name).latency
      end
    end

    def stats
      return @stats if @stats

      redis_url = ENV['REDIS_URL'] || 'redis://127.0.0.1:6379'
      sidekiq_options = {url: redis_url, namespace: ENV['REDIS_NAMESPACE']}
      Sidekiq.configure_client do |config|
        config.redis = sidekiq_options
      end
      Sidekiq.configure_server do |config|
        config.redis = sidekiq_options
      end
      @stats = Sidekiq::Stats.new
    end
  end
end
