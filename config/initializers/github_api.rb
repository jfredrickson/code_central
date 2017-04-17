# Search secrets.yml for GitHub API authentication information and make the auth
# data available throughout the app via Rails.application.secrets.github_auth.
#
# The resulting auth hash has one of the following formats, either of which can
# be used for Octokit or CodeInventory:
#
# { client_id: client_id, client_secret: client_secret }
# or
# { access_token: access_token }
#
# If no auth info is configured in secrets.yml, github_auth will be nil.

access_token = Rails.application.secrets.github_access_token
client_id = Rails.application.secrets.github_client_id
client_secret = Rails.application.secrets.github_client_secret

if !client_id.nil? && !client_secret.nil?
  Rails.application.secrets.github_auth = { client_id: client_id, client_secret: client_secret }
elsif !access_token.nil?
  Rails.application.secrets.github_auth = { access_token: access_token }
else
  Rails.application.secrets.github_auth = nil
end
