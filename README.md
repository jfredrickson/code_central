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
