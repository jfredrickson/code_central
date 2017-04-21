# CodeCentral

A dashboard for CodeInventory.

## Development

### USWDS

To update USWDS, use `npm` and `package.json` to grab the desired USWDS version, then run `rake npm:assets` to copy the new USWDS files into the `vendor/assets` directory.

## Deployment

### GitHub API authentication

In order to pull project metadata from GitHub, you must set GitHub authentication information in the app's environment variables. Either of these will do:

* `GITHUB_ACCESS_TOKEN`: A [personal access token](https://github.com/settings/tokens)
* `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`: An [OAuth application](https://github.com/settings/developers) ID and secret
