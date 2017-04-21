require "test_helper"
require "octokit"

class MetadataHarvesterTest < ActiveSupport::TestCase
  setup do
    Source.create(name: "GitHub")
    @octokit_org_repos_updated = JSON.parse(file_fixture("octokit/two_repos_updated.json").read, { symbolize_names: true })
    @octokit_org_repos_unchanged = JSON.parse(file_fixture("octokit/two_repos_unchanged.json").read, { symbolize_names: true })
    @octokit_org_repos_new = JSON.parse(file_fixture("octokit/three_repos_one_new.json").read, { symbolize_names: true })
    @new_project_metadata = JSON.parse(file_fixture("codeinventory/new_project_metadata.json").read, { symbolize_names: false })
    @harvester = MetadataHarvester.new("MyOrg", { access_token: "abc123" })
  end

  test "requires an org name" do
    assert_raise ArgumentError do
      MetadataHarvester.new(nil, { access_token: "abc123" })
    end
  end

  test "requires authentication data" do
    assert_raise ArgumentError do
      MetadataHarvester.new("org", nil)
    end
  end

  test "rejects invalid authentication data" do
    assert_raise ArgumentError do
      MetadataHarvester.new("org", { client_id: "missing_client_secret" })
    end
  end

  test "accepts an access token for authentication" do
    assert_nothing_raised do
      MetadataHarvester.new("org", { access_token: "abc123" })
    end
  end

  test "accepts client id/secret for authentication" do
    assert_nothing_raised do
      MetadataHarvester.new("org", { client_id: "abc123", client_secret: "abc123" })
    end
  end

  test "updates changed projects" do
    Octokit::Client.any_instance.stubs(:organization_repositories).returns(@octokit_org_repos_updated)
    project1 = projects(:project_one)
    project1.description = "shiny new description"
    CodeInventory::GitHub::Source.any_instance.stubs(:project).with("GSA/project-one").returns(project1.as_json)

    travel_to DateTime.new(2017, 11, 30, 01, 01, 01) do
      @harvester.harvest
    end
    assert_equal DateTime.new(2017, 11, 30, 01, 01, 01), Project.find_by(name: "Project One").harvested_at
    assert Project.find_by(name: "Project One").description =~ /shiny new description/
  end

  test "adds new projects" do
    Octokit::Client.any_instance.stubs(:organization_repositories).returns(@octokit_org_repos_new)
    CodeInventory::GitHub::Source.any_instance.stubs(:project).with("GSA/new-project").returns(@new_project_metadata)

    travel_to DateTime.new(2017, 11, 30, 01, 01, 01) do
      @harvester.harvest
    end
    assert new_project = Project.find_by(name: "New Project")
    assert_equal DateTime.new(2017, 11, 30, 01, 01, 01), new_project.harvested_at
    assert new_project.description =~ /brand new project/
  end

  test "does not update a project if its repo metadata contains an error" do
    Octokit::Client.any_instance.stubs(:organization_repositories).returns(@octokit_org_repos_updated)
    project1 = projects(:project_one)
    project1.open_source = nil
    CodeInventory::GitHub::Source.any_instance.stubs(:project).with("GSA/project-one").returns(project1.as_json)

    p1_harvested_at = project1.harvested_at
    travel_to DateTime.new(2017, 11, 30, 01, 01, 01) do
      @harvester.harvest
    end
    assert_equal p1_harvested_at, Project.find_by(name: "Project One").harvested_at
    assert Project.find_by(name: "Project One").open_source = 1
  end

  test "does not perform any updates if there are no changes" do
    Octokit::Client.any_instance.stubs(:organization_repositories).returns(@octokit_org_repos_unchanged)

    p1_harvested_at = projects(:project_one).harvested_at
    p2_harvested_at = projects(:project_two).harvested_at
    p3_harvested_at = projects(:project_three).harvested_at
    travel_to DateTime.new(2017, 11, 30, 01, 01, 01) do
      @harvester.harvest
    end
    assert_equal p1_harvested_at, Project.find_by(name: "Project One").harvested_at
    assert_equal p2_harvested_at, Project.find_by(name: "Project Two").harvested_at
    assert_equal p3_harvested_at, Project.find_by(name: "Project Three").harvested_at
  end

  test "creates or updates a project with new metadata" do
    project1 = projects(:project_one)
    project1.description = "shiny new description"
    project1_metadata = project1.as_json

    project = projects(:project_one)
    result = @harvester.create_or_update!(project, project1_metadata)
    assert project.description =~ /shiny new description/
    assert result
  end
end
