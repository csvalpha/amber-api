## Deploying
Deployments are done using GitHub Actions. To deploy a branch, follow the following steps:

* Go to the Continuous Delivery [workflow page](https://github.com/csvalpha/amber-api/actions/workflows/continuous-delivery.yml).
* Open the "Run workflow" modal.
* Choose a branch and if you want to merge the changes on the staging branch into the master branch (only possible when the branch chosen in previous step is master).
* Click the green button "Run workflow".

We use a continuous development cycle. That means: branch `master` is always in production. When a feature is merged through a PR to `staging`, merge its changes to `master` and deploy as soon as possible.

## Versioning

We do not use versioning in any way. In Slack the last deployed version can be looked up.


## Attaching to remote console
It is possible to connect with the remote rails console. This can be used for administrative tasks for example. Be careful doing this on production!

    mina production|staging rails:console

## Environments
Currently, AMBER is deployed in two environments: Staging and Production. The following applies to both API and UI:

| Environment | URL                 | Purpose                                                         | "Rules" |
| ----------- | ------------------- | --------------------------------------------------------------- | ------- |
| Production  | csvalpha.nl         | The website with production data. Available to members of Alpha | Should always run the latest version of the `master` branch. **Be careful with this environment, it is not a playground!** |
| Staging     | staging.csvalpha.nl | This version runs fake - filler - data, feel free to try out new features on this environment | It is not mandatory that this environment runs the latest version of the `staging` branch. |

> (API) Note on Staging and upgrading the DB: database migrations on Staging are done automatically on `deploy`. However, rollbacks are not. That means that migrating to a newer database `schema.rb` version is OK when trying out new features, but downgrading to an older version should be done manually with `bundle exec rails db:rollback` BEFORE deploying a different version of the API.
