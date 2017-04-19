require "octokit"
require "codeinventory"
require "codeinventory/github"

class MetadataHarvester
  def initialize(github_org, github_auth, project_org = nil)
    @github_org = github_org
    @github_auth = github_auth
    raise ArgumentError, "GitHub organization name cannot be nil" if @github_org.nil?
    raise ArgumentError, "authentication info must contain an access token, or a client id and client secret" unless auth_valid?
    @project_org = project_org || @github_org
  end

  def auth_valid?
    return false if @github_auth.nil?
    @github_auth.include?(:access_token) || (@github_auth.include?(:client_id) && @github_auth.include?(:client_secret))
  end

  def harvest
    organization_repositories.each do |repo|
      project = Project.find_or_initialize_by(source: source("GitHub"), source_identifier: repo[:id])
      if project.harvested_at.nil? || project.harvested_at < repo[:updated_at]
        metadata = project_metadata(repo[:full_name])
        metadata["organization"] = @project_org
        status = MetadataHarvesterStatus.new
        status.new_project = project.new_record?
        status.project = project
        status.repository = repo
        status.metadata = metadata
        status.valid = create_or_update!(project, metadata)
        yield status if block_given?
      end
    end
  end

  def organization_repositories
    Octokit.auto_paginate = true
    client = Octokit::Client.new(@github_auth)
    client.organization_repositories(@github_org)
  end

  def project_metadata(repo_name)
    github_source = CodeInventory::GitHub::Source.new(@github_auth, @github_org)
    github_source.project(repo_name)
  end

  def source(source_name)
    Source.find_by(name: "GitHub")
  end

  # Creates/updates a project with metadata from CodeInventory
  def create_or_update!(project, metadata)
    project.update_from_metadata(metadata)
    project.harvested_at = DateTime.now
    project.save
  end
end
