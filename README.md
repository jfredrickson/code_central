# CodeCentral

A dashboard for CodeInventory.

## Development

### NPM Packages

To update NPM packages, run `rake assets:npm`. This task will grab the latest NPM packages and install them to `vendor/assets`. See the [assets.rake](/lib/tasks/assets.rake) task definitions for specifics on which packages come from NPM.

## Deployment

### GitHub API authentication

In order to pull project metadata from GitHub, you must set GitHub authentication information in the app's environment variables. Either of these will do:

* `GITHUB_ACCESS_TOKEN`: A [personal access token](https://github.com/settings/tokens)
* `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`: An [OAuth application](https://github.com/settings/developers) ID and secret
