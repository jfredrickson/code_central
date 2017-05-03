# Tasks specific to Cloud Foundry

namespace :cf do
  desc "Invoke db:migrate only on the first app instance"
  task :migrate do
    Rake::Task["db:migrate"].invoke if instance_index == 0
  end

  desc "Start crono daemon only on the first app instance"
  task :crono do
    sh "bundle exec crono start" if instance_index == 0
  end

  def instance_index
    vcap_app = ENV["VCAP_APPLICATION"]
    return 0 if vcap_app.nil?
    JSON.parse(vcap_app).dig("instance_index")
  end
end
