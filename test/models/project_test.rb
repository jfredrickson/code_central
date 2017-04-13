require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "projects require a name" do
    project = projects(:project_one)
    project.name = nil
    assert !project.valid?
  end

  test "projects require a description" do
    project = projects(:project_one)
    project.description = nil
    assert !project.valid?
  end

  test "projects require a repository if open source" do
    project = projects(:project_one)
    project.repository = nil
    assert !project.valid?
  end

  test "projects don't require a repository if closed source" do
    project = projects(:project_three)
    assert project.valid?
  end

  test "project repository should be a valid URL" do
    project = projects(:project_one)
    project.repository = "not a URL"
    assert !project.valid?
  end

  test "project license, if there is one, should be a valid URL" do
    project = projects(:project_one)
    project.license = "not a URL"
    assert !project.valid?
  end

  test "projects should either be open source (1) or closed source (0)" do
    project = projects(:project_one)
    project.open_source = nil
    assert !project.valid?
    project.open_source = 2
    assert !project.valid?
    project.open_source = 1
    assert project.valid?
    project.open_source = 0
    assert project.valid?
  end

  test "projects should either be government-wide reuse (1) or not (0)" do
    project = projects(:project_one)
    project.government_wide_reuse = nil
    assert !project.valid?
    project.government_wide_reuse = 2
    assert !project.valid?
    project.government_wide_reuse = 1
    assert project.valid?
    project.government_wide_reuse = 0
    assert project.valid?
  end

  test "projects should have a contact email" do
    project = projects(:project_one)
    project.contact_email = nil
    assert !project.valid?
  end

  test "project contact email should be a valid email address" do
    project = projects(:project_one)
    project.contact_email = "not an email"
    assert !project.valid?
  end

  test "projects should have a source" do
    project = projects(:project_one)
    project.source = nil
    assert !project.valid?
  end

  test "projects should have a source identifier" do
    project = projects(:project_one)
    project.source_identifier = nil
    assert !project.valid?
  end
end
