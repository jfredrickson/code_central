require "codeinventory"
require "codeinventory/github"

class HarvestMetadataJob < ApplicationJob
  queue_as :default

  def perform(*)
    @auth = find_auth
    @org = find_org
    @inventory = CodeInventory::GitHub::Source.new(@auth, @org)
    @github_source = Source.find_by(name: "GitHub")

    Rails.logger.error("No authentication info found") && return if @auth.nil?
    Rails.logger.error("No organization found") && return if @org.nil?

    create_count = 0
    update_count = 0
    error_count = 0

    repositories.each do |repo|
      project = Project.find_or_initialize_by(source: @github_source, source_identifier: repo[:id])
      new_project = project.new_record?
      if project.harvested_at.nil? || project.harvested_at < repo[:updated_at]
        if create_or_update(project, repo)
          if new_project
            Rails.logger.info("Created: #{project.name}")
            create_count += 1
          else
            Rails.logger.info("Updated: #{project.name}")
            update_count += 1
          end
        else
          Rails.logger.error("Invalid metadata in repo: #{repo[:full_name]} (#{project.name})")
          error_count += 1
        end
      end
    end

    Rails.logger.info("New projects created: #{create_count}")
    Rails.logger.info("Existing projects updated: #{update_count}")
    Rails.logger.info("Repository metadata errors: #{error_count}")
  end

  def create_or_update(project, repo)
    metadata = @inventory.project(repo[:full_name])
    project.update_from_metadata(metadata)
    project.harvested_at = DateTime.now
    project.save
  end

  def repositories
    @inventory.client.org_repos(@org)
  end

  def find_auth
    access_token = ENV["GITHUB_ACCESS_TOKEN"]
    client_id = ENV["GITHUB_CLIENT_ID"]
    client_secret = ENV["GITHUB_CLIENT_SECRET"]
    if !access_token.nil?
      return { access_token: access_token }
    elsif !client_id.nil? && !client_secret.nil?
      return { client_id: client_id, client_secret: client_secret }
    else
      return nil
    end
  end

  def find_org
    ENV["GITHUB_ORG"]
  end
end
