class HarvestMetadataJob < ApplicationJob
  queue_as :default

  def perform(org)
    if Rails.application.secrets.github_auth.nil?
      err = "No authentication info found"
      Rails.logger.error(err)
      raise err
    end

    repo_count = 0
    create_count = 0
    update_count = 0
    error_count = 0

    harvester = MetadataHarvester.new(org, Rails.application.secrets.github_auth)
    harvester.harvest do |status|
      repo_count += 1
      if status.valid?
        if status.new_project?
          Rails.logger.info("Created: #{status.project.name}")
          create_count += 1
        else
          Rails.logger.info("Updated: #{status.project.name}")
          update_count +=1
        end
      else
        Rails.logger.error("Invalid metadata in repo: #{status.repository[:full_name]} (#{status.project.name}): #{status.metadata}")
        error_count +=1
      end
    end

    Rails.logger.info("New/updated repositories found: #{repo_count}")
    Rails.logger.info("New projects created: #{create_count}")
    Rails.logger.info("Existing projects updated: #{update_count}")
    Rails.logger.info("Repository metadata errors: #{error_count}")
  end
end
