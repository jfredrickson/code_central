# CodeCentral

A dashboard for CodeInventory.

## Development

### NPM Packages

To update NPM packages, run `rake assets:npm`. This task will grab the latest NPM packages and install them to the `vendor` or `public` folders as appropriate. See the [assets.rake](/lib/tasks/assets.rake) task definitions for specifics on which packages come from NPM.

## Deployment

### Configuration

Set the following environment variables:

* `AGENCY_ACRONYM`: Your agency acronym used in the [code.json](https://code.gov/#/policy-guide/docs/compliance/inventory-code) output (e.g., "GSA")
* `GITHUB_ACCESS_TOKEN`: A [GitHub access token](https://github.com/settings/tokens) with "repo" scope (the "repo" scope is required if you want to inventory your private repositories)

You can use a tool to create an access token for the app using an OAuth client ID and secret. Or you can use a personal access token. See the [GitHub documentation](https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization) for more details. Here is a brief example using `curl` to obtain an authorization token:

* `YOUR_USERNAME` is your GitHub username (you will be prompted for your password separately)
* `YOUR_OTP` is your current 2FA token, if you have 2FA enabled on your organization (remove the `-H` argument if you don't use 2FA)
* `CLIENT_ID` and `CLIENT_SECRET` are from the [GitHub OAuth application settings]((https://github.com/settings/developers)

```bash
curl --user "YOUR_USERNAME" -H "X-GitHub-OTP: YOUR_OTP" -X POST -d '{ "note": "CodeCentral", "client_id": "CLIENT_ID", "client_secret": "CLIENT_SECRET", "scopes": ["repo"] }' "https://api.github.com/authorizations"
```

### Harvesting Metadata

To initiate a metadata harvest job that will pull repository metadata from GitHub, use `rake metadata:harvest[ORG]`, where `ORG` is the name of the GitHub organization. This will also set the Code.gov `organization` metadata field to `ORG`. If you want to use a different identifier for the Code.gov `organization` field, use `rake metadata:harvest[ORG,DIFFERENT_ORG_IDENTIFIER]`.

Examples:

Harvest metadata from the GSA GitHub organization. By default, this will use "GSA" as the value of the Code.gov `organization` field:

```bash
$ rake metadata:harvest[GSA]
```

Harvest metadata from the presidential-innovation-fellows GitHub organization, but use "PIF" as the value of the Code.gov `organization` field:

```bash
$ rake metadata:harvest[presidential-innovation-fellows,PIF]
```

This can be done on Cloud Foundry using a one-off task such as:

```bash
$ cf run-task APPNAME "bundle exec rake metadata:harvest[ORG]"
```
