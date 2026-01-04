# Go Gin Application - Docker Setup

Complete Docker setup with separate development and production environments.

## Prerequisites

- Docker (v24+)
- Docker Compose (v2+)
- Make (optional, but recommended)

## Project Structure

```
.
├── Dockerfile                    # Multi-stage build for dev and prod
├── docker-compose.dev.yml       # Development configuration
├── docker-compose.prod.yml      # Production configuration
├── .air.toml                    # Hot-reload config for development
├── .env.example                 # Environment variables template
├── .env.dev                     # Development environment (create from example)
├── .env.prod                    # Production environment (create from example)
├── Makefile                     # Convenient commands
└── backups/                     # Database backups directory
```

## Quick Start

### Development

```bash
# One-command setup and start
make dev

# Or step by step:
make setup-dev    # Create .env.dev
make dev-build    # Build images
make dev-up       # Start containers
make dev-logs     # View logs
```

Access your services:
- **App**: https://yourdomain.com (or your configured domain)
- **HTTP**: Automatically redirects to HTTPS
- **SSL**: Automatic Let's Encrypt certificates

**Before first deployment:**
1. Update `DOMAIN` in `.env.prod` with your actual domain
2. Ensure DNS points to your server
3. Start with `HTTPS_PORTAL_STAGE=staging` to test
4. Once working, change to `HTTPS_PORTAL_STAGE=production`

### Production

```bash
# One-command setup and start
make prod

# Or step by step:
make setup-prod   # Create .env.prod
# ⚠️ IMPORTANT: Edit .env.prod and change all passwords!
make prod-build   # Build images
make prod-up      # Start containers
make prod-logs    # View logs
```

## Environment Configuration

### Development (.env.dev)

Created automatically with `make setup-dev`. Uses weak passwords and exposed ports for easy debugging.

### Production (.env.prod)

Created automatically with `make setup-prod`, but **you must update all passwords and secrets**:

```bash
# Generate strong passwords
openssl rand -base64 32  # For database/redis passwords
openssl rand -base64 64  # For JWT secret
```

Update these in `.env.prod`:
- `DOMAIN` - Your production domain (e.g., api.yourdomain.com)
- `HTTPS_PORTAL_STAGE` - Set to `staging` for testing, `production` for real SSL
- `POSTGRES_PASSWORD`
- `REDIS_PASSWORD`
- `JWT_SECRET`
- `CORS_ALLOWED_ORIGINS`

#### HTTPS/SSL Configuration

The production setup includes automatic HTTPS via Let's Encrypt:

1. **Point your domain to your server** - Ensure DNS A record points to your server's IP
2. **Set DOMAIN** in `.env.prod` - e.g., `DOMAIN=api.yourdomain.com`
3. **Choose SSL stage**:
   - `HTTPS_PORTAL_STAGE=staging` - Use Let's Encrypt staging (for testing, avoids rate limits)
   - `HTTPS_PORTAL_STAGE=production` - Use Let's Encrypt production (real SSL certificate)
4. **Start the stack** - `make prod-up`

SSL certificates are automatically obtained and renewed. The https-portal container handles:
- Automatic SSL certificate generation
- HTTP to HTTPS redirect
- Certificate auto-renewal
- WebSocket support

**Note**: Let's Encrypt has rate limits (5 certificates per domain per week). Always test with `staging` first!

## Available Commands

Run `make help` to see all commands:

### Development
- `make dev` - Quick start development
- `make dev-up` - Start development environment
- `make dev-down` - Stop development environment
- `make dev-logs` - View logs (follows)
- `make dev-shell` - Access app container shell
- `make db-shell-dev` - Access PostgreSQL shell
- `make redis-cli-dev` - Access Redis CLI

### Production
- `make prod` - Quick start production
- `make prod-up` - Start production environment
- `make prod-down` - Stop production environment
- `make prod-logs` - View logs (follows)
- `make db-backup-prod` - Backup database
- `make db-restore-prod BACKUP_FILE=path/to/backup.sql` - Restore database

### Cleanup
- `make clean-dev` - Remove development data
- `make clean-prod` - Remove production data (⚠️ dangerous!)
- `make clean` - Full cleanup

## Development Features

- **Hot Reload**: Code changes automatically restart the server (via Air)
- **Volume Mounting**: Source code is mounted, edit locally and see changes instantly
- **Database GUI**: Adminer included at http://localhost:8081
- **Debug Logging**: Verbose logs for troubleshooting
- **Exposed Ports**: All services accessible for debugging

## Production Features

- **Optimized Build**: Multi-stage build produces minimal Alpine image
- **Health Checks**: All services monitored with health checks
- **Resource Limits**: CPU and memory limits defined
- **Log Rotation**: Automatic log file rotation (10MB max, 3 files)
- **Auto Restart**: Containers restart automatically on failure
- **Security**: No external database ports, password-protected Redis
- **Performance**: Optimized PostgreSQL configuration

## Database Operations

### Backup Production Database

```bash
make db-backup-prod
# Creates backup in ./backups/backup_YYYYMMDD_HHMMSS.sql
```

### Restore Production Database

```bash
make db-restore-prod BACKUP_FILE=./backups/backup_20240115_143022.sql
```

## Troubleshooting

### Port Already in Use

```bash
# Check what's using the port
lsof -i :8080

# Kill the process or change the port in docker-compose
```

### Container Won't Start

```bash
# Check logs
make dev-logs  # or make prod-logs

# Check container status
make dev-ps    # or make prod-ps

# Rebuild from scratch
make dev-down
docker system prune -f
make dev-build
make dev-up
```

### Permission Issues

```bash
# Fix ownership of backups directory
sudo chown -R $USER:$USER ./backups
```

### Reset Everything

```bash
# Development
make clean-dev
make dev

# Production (⚠️ deletes all data!)
make clean-prod
make prod
```

## Docker Compose Without Make

If you prefer using `docker compose` directly:

```bash
# Development
docker compose -f docker-compose.dev.yml up -d
docker compose -f docker-compose.dev.yml logs -f
docker compose -f docker-compose.dev.yml down

# Production
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml logs -f
docker compose -f docker-compose.prod.yml down
```

## Health Checks

Production includes health checks for all services. Check status:

```bash
docker compose -f docker-compose.prod.yml ps
```

Healthy services show "(healthy)" in the status column.

## Security Notes

1. **Never commit** `.env.dev` or `.env.prod` to version control
2. **Always change** default passwords in production
3. **Use strong passwords** (min 32 characters)
4. **Restrict CORS** origins in production
5. **Keep secrets** in environment variables, never in code
6. **Regular backups** of production database

## CI/CD Integration

For automated deployments:

```bash
# Build and deploy production
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d
```

Add to your CI/CD pipeline (GitHub Actions, GitLab CI, etc.).