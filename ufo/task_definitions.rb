# There will be some special variables that are automatically available in this file.
#
# Some of variables are from the Dockerfile and some are from other places.
#
# * helper.full_image_name - Docker image name with the tag when docker image is built by ufo. This is defined in ufo/settings.yml.  The helper.full_image_name includes the git sha tongueroo/hi:ufo-[sha].
# * helper.dockerfile_port - Expose port in the Dockerfile.  Only supports one exposed port, the first one that is encountered.
#
# env_vars - is a helper method that generates the proper environment Array of Hashes

# common variables
common = {
  image: helper.full_image_name, # includes the git sha tongueroo/hi:ufo-[sha].
  cpu: 64,
  memory_reservation: 64,
  environment: env_file(".env.prod")
}

task_definition "sidekiq-chart" do
  source "main" # will use ufo/templates/main.json.erb
  variables(common.dup.deep_merge(
    family: task_definition_name,
    name: "chart",
    command: ["bin/chart"],
    awslogs_group: "app-sidekiq",
    awslogs_stream_prefix: "sidekiq",
  ))
end

