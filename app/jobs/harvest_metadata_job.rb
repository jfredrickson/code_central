require "octokit"
require "codeinventory"
require "codeinventory/github"

class HarvestMetadataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    auth = find_auth
    Rails.logger.error("No authentication info found") && return if auth.nil?

    org = find_org
    Rails.logger.error("No organization found") && return if org.nil?

    repos_for_update = []
    repos_for_create = []
    github_source = Source.find_by(name: "GitHub")

    repositories(auth, org).each do |repo|
      project = Project.find_by(source: github_source, source_identifier: repo[:id])
      if project.nil?
        Rails.logger.info("New repository: #{repo[:full_name]}")
        repos_for_create << repo
      else
        if project.harvested_at == nil || project.harvested_at < repo[:updated_at]
          Rails.logger.info("Updated repository: #{repo[:full_name]}")
          repos_for_update << repo
        end
      end
    end

    Rails.logger.info("New repositories found: #{repos_for_create.count}")
    Rails.logger.info("Updated repositories found: #{repos_for_update.count}")

    github_inventory = CodeInventory::GitHub::Source.new(auth, org)

    repos_for_update.each do |repo_for_update|
      metadata = github_inventory.project(repo_for_update[:full_name])
      project = Project.find_by(source: github_source, source_identifier: repo_for_update[:id])
      project.update_from_metadata(metadata)
      project.harvested_at = DateTime.now
      if project.save
        Rails.logger.info("Updated: #{project.name}")
      else
        Rails.logger.error("Invalid project: #{project.name} (#{repo_for_update[:full_name]})")
      end
    end

    repos_for_create.each do |repo_for_create|
      metadata = github_inventory.project(repo_for_create[:full_name])
      project = Project.new_from_metadata(metadata, github_source, repo_for_create[:id])
      project.harvested_at = DateTime.now
      if project.save
        Rails.logger.info("Created: #{project.name}")
      else
        Rails.logger.error("Invalid project: #{project.name} (#{repo_for_create[:full_name]})")
      end
    end
  end

  def repositories(auth, org)
    Octokit.auto_paginate = true
    client = Octokit::Client.new(auth)
    client.org_repos(org)
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
    org_env = ENV["GITHUB_ORG"]
    return nil if org_env.nil?
    org_env
  end
end
