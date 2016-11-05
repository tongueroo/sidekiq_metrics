require 'spec_helper'

# to run specs with what's remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
describe SidekiqMetrics::CLI do
  before(:all) do
    @args = "--noop --once"
  end

  describe "sidekiq_metrics" do
    it "chart sends sidekiq metrics to cloudwatch" do
      out = execute("bin/sidekiq_metrics chart #{@args}")
      expect(out).to include("sidekiq metrics sent to CloudWatch")
    end
  end
end
