require_relative "../../config/environment"

namespace :metadata do
  desc "Initiate a metadata harvest job"
  task :harvest do
    HarvestMetadataJob.perform_now
  end
end
