## Example Use case for a Laravel Project.

Add `Dockerfile` file and `docker/` directory to your root directory for your laravel project. (same level with your compose.json file.)

Then you can use this setup anywhere you use docker. (Google Cloud Run, AWS ElasticBeanstalk, AWS EKS, etc...)

The example Dockerfile and configs in the docker directory are optimized for production. You might want to create additional files if you want to use docker in local development as well.
