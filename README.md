# SidekiqMetrics

Sends sidekiq metrics to CloudWatch.

## Setup

```bash
git clone git@github.com:gitresolve/sidekiq_metrics.git
cd sidekiq_metrics
bundle
```

## Usage

Configure env variables in `.env` or `.env.prod`.  Important env variables are:

* REDIS_URL
* REDIS_NAMESPACE

```bash
sidekiq_metrics chart --dimension gr-prod
```

Send the metrics every 5 seconds

```bash
sidekiq_metrics chart --dimension gr-prod --sleep 5
```

## Custom Metric Names

A CloudWatch Metric has a namespace, metric name and dimensions.

For sidekiq metrics:

* namespace - Sidekiq
* metric name - QueueSize, Latency, Retries
* dimensions - gr-prod, funnel-prod
