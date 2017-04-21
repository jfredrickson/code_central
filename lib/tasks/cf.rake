# Tasks specific to Cloud Foundry

namespace :cf do
  desc "Invoke db:migrate only on the first app instance"
  task :migrate do
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"]
    Rake::Task["db:migrate"].invoke if instance_index == 0
  end
end
