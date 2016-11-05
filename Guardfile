guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})      { "spec/sidekiq_metrics_spec.rb" }
  watch(%r{^lib/sidekiq_metrics/(.+)\.rb$})  { "spec/sidekiq_metrics_spec.rb" }
  watch('spec/spec_helper.rb')   { "spec/sidekiq_metrics_spec.rb" }
  watch(%r{^lib/sidekiq_metrics/(.+)\.rb$})   { |m| "spec/lib/#{m[1]}_spec.rb" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end