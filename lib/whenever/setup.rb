# Environment variable defaults to RAILS_ENV
set :environment_variable, "RAILS_ENV"
# Environment defaults to production
set :environment, "production"
# Path defaults to the directory `whenever` was run from
set :path, Whenever.path

# All jobs are wrapped in this template.
# http://blog.scoutapp.com/articles/2010/09/07/rvm-and-cron-in-production
set :job_template, "/bin/bash -l -c ':job'"

job_type :command, ":task :output"

# Run rake through bundler if possible
if Whenever.bundler?
  job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task --silent :output"
  job_type :script, "cd :path && :environment_variable=:environment bundle exec script/:task :output"
else
  job_type :rake, "cd :path && :environment_variable=:environment rake :task --silent :output"
  job_type :script, "cd :path && :environment_variable=:environment script/:task :output"
end

# Create a runner job that's appropriate for the Rails version,
if Whenever.rails3?
  job_type :runner, "cd :path && script/rails runner -e :environment ':task' :output"
elsif Whenever.rails_binstub?
  job_type :runner, "cd :path && bin/rails runner -e :environment ':task' :output"
else
  job_type :runner, "cd :path && script/runner -e :environment ':task' :output"
end
