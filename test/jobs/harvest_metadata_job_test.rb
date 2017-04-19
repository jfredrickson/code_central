require "test_helper"

class HarvestMetadataJobTest < ActiveJob::TestCase
  setup do
    Rails.application.secrets.github_auth = { access_token: "abc123" }
    @org = "MyExampleOrg"
    @octokit_org_repos_updated = JSON.parse(file_fixture("octokit/two_repos_updated.json").read, { symbolize_names: true })
    @octokit_org_repos_unchanged = JSON.parse(file_fixture("octokit/two_repos_unchanged.json").read, { symbolize_names: true })
    @octokit_org_repos_new = JSON.parse(file_fixture("octokit/three_repos_one_new.json").read, { symbolize_names: true })
    @new_project_metadata = JSON.parse(file_fixture("codeinventory/new_project_metadata.json").read, { symbolize_names: false })
    @new_project_metadata_invalid = JSON.parse(file_fixture("codeinventory/new_project_metadata_invalid_repository.json").read, { symbolize_names: false })
  end

  test "raises an exception when no authentication data is available" do
    @cached_access_token = ENV.delete "GITHUB_ACCESS_TOKEN"
    @cached_client_id = ENV.delete "GITHUB_CLIENT_ID"
    @cached_client_secret = ENV.delete "GITHUB_CLIENT_SECRET"
    Rails.application.secrets.github_auth = nil
    assert_raise RuntimeError do
      HarvestMetadataJob.perform_now(@org)
    end
    ENV["GITHUB_ACCESS_TOKEN"] = @cached_access_token
    ENV["GITHUB_CLIENT_ID"] = @cached_client_id
    ENV["GITHUB_CLIENT_SECRET"] = @cached_client_secret
  end

  test "harvests metadata" do
    MetadataHarvester.any_instance.stubs(:organization_repositories).returns(@octokit_org_repos_unchanged)
    MetadataHarvester.any_instance.stubs(:project_metadata).with("GSA/project-one").returns(projects(:project_one).as_json)
    MetadataHarvester.any_instance.stubs(:project_metadata).with("GSA/project-two").returns(projects(:project_two).as_json)
    Project.delete_all

    HarvestMetadataJob.perform_now(@org)
    assert_equal 2, Project.count
  end
end
