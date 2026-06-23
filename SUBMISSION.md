# Submission

## What I changed and why

### App

- Fixed note ownership so users only see their own notes.
- Corrected note creation and editing behavior.
- Added tests and updated the settings so tests run against SQLite while the application uses PostgreSQL.
- Removed secrets from the repository and added a `.env.example` file instead.

### Docker

- Added a `Dockerfile` and a `docker-compose.yml` file.
- Configured the application to run under Gunicorn with PostgreSQL.
- Added a health check and configured the container to run as a non-root user.

### CI

- Added a GitHub Actions workflow.
- Configured it to run `python manage.py check`, execute the pytest suite, build the Docker image, and run a dependency audit.

## Tradeoffs

I focused on making the application easy to run and easy to verify rather than adding new features. I tried to keep the Docker and CI setup straightforward so it would be easy for someone else to understand and maintain.

## What I'd do with another day

- Add more test coverage.
- Add separate Django settings files for development, test, and production.
- Add linting and code coverage reporting to the CI pipeline.
- Add structured logging and a few more health checks.

## How to run

### Local

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Docker

```bash
docker-compose up --build -d
docker-compose exec web python manage.py migrate
```

### Tests

```bash
pytest
```

or

```bash
docker-compose exec web pytest
```

## Deployment plan

For production, I'd package the application as a container and run it on ECS Fargate behind an Application Load Balancer. PostgreSQL would move to RDS instead of running inside Docker.

Secrets would be stored outside the repository, ideally in AWS Secrets Manager or Parameter Store, and injected into the container at runtime.

I'd use rolling deployments and run database migrations before switching traffic to the new version. If something went wrong, rolling back would simply mean deploying the previous image.

Logs and metrics would go to CloudWatch, with alarms configured for things like high error rates or unhealthy tasks.

Before exposing the application to real users, I'd want HTTPS in place, automated backups, a staging environment, and monitoring so problems are visible before users start reporting them.
