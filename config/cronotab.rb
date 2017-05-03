# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
# Crono.perform(TestJob).every 2.days, at: '15:30'
#

# Specify metadata harvest jobs in config/harvest.yml.
harvest = Rails.application.config_for(:harvest)

# GitHub
github_jobs = harvest.dig("jobs", "github") || []
github_jobs.each do |job|
  if job["github_org"].nil?
    Rails.logger.error "Invalid GitHub job in harvest.yml: #{job.inspect}"
  end
  Crono.perform(HarvestMetadataJob, job["github_org"], job["project_org"]).every 1.day, at: { hour: 3, min: 0 }
end
