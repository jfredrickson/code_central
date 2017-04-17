require "octokit"
require "codeinventory"
require "codeinventory/github"

class HarvestMetadataJob < ApplicationJob
  queue_as :default

  def perform(org)
    auth = Rails.application.secrets.github_auth
    if auth.nil?
      err = "No authentication info found"
      Rails.logger.error(err)
      raise err
    end

    inventory = CodeInventory::GitHub::Source.new(auth, org)
    github = Source.find_by(name: "GitHub")
    client = Octokit::Client.new(auth)

    create_count = 0
    update_count = 0
    error_count = 0

    client.org_repos(org).each do |repo|
      project = Project.find_or_initialize_by(source: github, source_identifier: repo[:id])
      new_project = project.new_record?
      if project.harvested_at.nil? || project.harvested_at < repo[:updated_at]
        metadata = inventory.project(repo[:full_name])
        if create_or_update(project, metadata)
          if new_project
            Rails.logger.info("Created: #{project.name}")
            create_count += 1
          else
            Rails.logger.info("Updated: #{project.name}")
            update_count += 1
          end
        else
          Rails.logger.error("Invalid metadata in repo: #{repo[:full_name]} (#{project.name}): #{metadata}")
          error_count += 1
        end
      end
    end

    Rails.logger.info("New projects created: #{create_count}")
    Rails.logger.info("Existing projects updated: #{update_count}")
    Rails.logger.info("Repository metadata errors: #{error_count}")
  end

  # Creates/updates a project with metadata from CodeInventory
  def create_or_update(project, metadata)
    project.update_from_metadata(metadata)
    project.harvested_at = DateTime.now
    project.save
  end
end
