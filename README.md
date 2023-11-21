# example-ts-express

Basic TS Express API equipped with Docker and Amazon ECS deployment capabilities

To deploy to AWS:

1. Edit the deploy/env.sh file with data about your ECR repository & your ECS container
2. Make sure your AWS profile in `~/.aws/config` matches what is in your `deploy/deploy.sh` file (search for each occurance of `--profile`)
3. Run `make deploy`

To run locally:

```
npm install
npm run dev
```
