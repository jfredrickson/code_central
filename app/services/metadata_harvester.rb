require "octokit"
require "codeinventory"
require "codeinventory/github"

class MetadataHarvester
  def initialize(org, auth)
    @org = org
    @auth = auth
    raise ArgumentError, "organization name cannot be nil" if @org.nil?
    raise ArgumentError, "authentication info must contain an access token, or a client id and client secret" unless auth_valid?
  end

  def auth_valid?
    return false if @auth.nil?
    @auth.include?(:access_token) || (@auth.include?(:client_id) && @auth.include?(:client_secret))
  end

  def harvest
    organization_repositories.each do |repo|
      project = Project.find_or_initialize_by(source: source("GitHub"), source_identifier: repo[:id])
      if project.harvested_at.nil? || project.harvested_at < repo[:updated_at]
        status = MetadataHarvesterStatus.new
        status.new_project = project.new_record?
        status.project = project
        status.repository = repo
        metadata = project_metadata(repo[:full_name])
        status.metadata = metadata
        status.valid = create_or_update!(project, metadata)
        yield status if block_given?
      end
    end
  end

  def organization_repositories
    Octokit.auto_paginate = true
    client = Octokit::Client.new(@auth)
    client.organization_repositories(@org)
  end

  def project_metadata(repo_name)
    github_source = CodeInventory::GitHub::Source.new(@auth, @org)
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
