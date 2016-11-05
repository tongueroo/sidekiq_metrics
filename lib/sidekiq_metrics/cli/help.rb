module SidekiqMetrics
  class CLI < Thor
    class Help
      class << self
        def chart
<<-EOL
Example:

export REDIS_URL=redis://127.0.0.1:6379
export REDIS_NAMESPACE=sidekiq

bin/sidekiq_metrics chart --dimension gr-worker-prod

bin/sidekiq_metrics chart --dimension gr-worker-dev
EOL
        end
      end
    end
  end
end
