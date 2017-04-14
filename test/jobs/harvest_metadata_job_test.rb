require "test_helper"

class HarvestMetadataJobTest < ActiveJob::TestCase
  setup do
    @job = HarvestMetadataJob.new
    @cached_access_token = ENV["GITHUB_ACCESS_TOKEN"]
    @cached_client_id = ENV["GITHUB_CLIENT_ID"]
    @cached_client_secret = ENV["GITHUB_CLIENT_SECRET"]
    @cached_org = ENV["GITHUB_ORG"]
  end

  teardown do
    ENV["GITHUB_ACCESS_TOKEN"] = @cached_access_token
    ENV["GITHUB_CLIENT_ID"] = @cached_client_id
    ENV["GITHUB_CLIENT_SECRET"] = @cached_client_secret
    ENV["GITHUB_ORG"] = @cached_org
  end

  test "handles an access token in ENV" do
    ENV["GITHUB_ACCESS_TOKEN"] = "abcdef"
    auth = @job.find_auth
    assert_equal "abcdef", auth[:access_token]
  end

  test "handles application authentication in ENV" do
    ENV.delete("GITHUB_ACCESS_TOKEN")
    ENV["GITHUB_CLIENT_ID"] = "abcdef"
    ENV["GITHUB_CLIENT_SECRET"] = "123456"
    auth = @job.find_auth
    assert_equal "abcdef", auth[:client_id]
    assert_equal "123456", auth[:client_secret]
  end

  test "handles missing auth info in ENV" do
    ENV.delete("GITHUB_ACCESS_TOKEN")
    ENV.delete("GITHUB_CLIENT_ID")
    ENV.delete("GITHUB_CLIENT_SECRET")
    auth = @job.find_auth
    assert auth.nil?
  end

  test "finds the correct org in ENV" do
    ENV["GITHUB_ORG"] = "MyOrg"
    org = @job.find_org
    assert_equal "MyOrg", org
  end

  test "handles missing org in ENV" do
    ENV.delete("GITHUB_ORG")
    org = @job.find_org
    assert org.nil?
  end
end
