# ACNSMS PostgreSQL Docker Setup

This setup migrates the ACNSMS application from MariaDB to PostgreSQL using Docker containers.

## Files Created/Modified

### New Files:
- `Dockerfile` - Flask application container
- `Dockerfile.postgres` - PostgreSQL database container
- `docker-compose.yml` - Orchestrates both services
- `postgres_init.sql` - PostgreSQL-compatible database schema and data
- `.dockerignore` - Optimizes Docker builds
- `start-docker.bat` - Windows batch script to start services
- `start-docker-verbose.bat` - Detailed startup script with logging
- `docker-diagnostics.bat` - Troubleshooting script
- `README-DOCKER.md` - This file

### Modified Files:
- `requirements.txt` - Added `psycopg2-binary` and `Flask-Migrate` for PostgreSQL support
- `.env` - Updated DATABASE_URL for PostgreSQL
- `config.py` - Updated default database configuration
- `models.py` - Updated ENUM definitions for PostgreSQL compatibility

## Quick Start

### Option 1: Using the batch script (Windows)
```bash
start-docker.bat
```

### Option 2: Using Docker Compose directly
```bash
# Build and start all services
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes (deletes data)
docker-compose down -v
```

## Database Connection Details

- **Host**: localhost
- **Port**: 5432
- **Database**: db_of_acnsms
- **Username**: acnsms_user
- **Password**: acnsms_password
- **Connection String**: `postgresql://acnsms_user:acnsms_password@localhost:5432/db_of_acnsms`

## Service URLs

- **Application**: http://localhost:5000
- **PostgreSQL**: localhost:5432

## Key Changes from MariaDB to PostgreSQL

1. **Data Types**:
   - `AUTO_INCREMENT` → `SERIAL`
   - `ENUM` types explicitly defined
   - `DATETIME` → `TIMESTAMP`
   - `TINYINT(1)` → `BOOLEAN`

2. **SQL Syntax**:
   - `REPLACE INTO` → `INSERT ... ON CONFLICT DO NOTHING`
   - Added sequence resets for auto-increment columns
   - Quoted reserved keywords like "user"

3. **Driver**:
   - `PyMySQL` → `psycopg2-binary`

## Troubleshooting

### Why Two Containers?
This is **normal and correct**:
- **`acnsms_postgres`** - Database service (PostgreSQL)
- **`acnsms_web`** - Application service (Flask app)

This follows Docker best practices for separation of concerns.

### Common Issues

#### Both Containers Should Run Together
Run the diagnostic script first:
```bash
docker-diagnostics.bat
```

#### Issue: Containers Not Starting Together
```bash
# Check what's running
docker ps -a

# Check logs
docker-compose logs

# Common solutions:
# 1. Stop all and restart
docker-compose down
docker-compose up --build

# 2. Check for port conflicts
netstat -an | findstr ":5000"
netstat -an | findstr ":5432"
```

#### Issue: Web Container Exits Immediately
This usually means the database isn't ready:
```bash
# Check database health
docker exec acnsms_postgres pg_isready -U acnsms_user

# Wait longer for database startup
docker-compose up postgres
# Wait 30-60 seconds, then:
docker-compose up web
```

#### Issue: Database Connection Refused
```bash
# Ensure both containers are on same network
docker network ls
docker-compose ps

# Check internal connectivity
docker exec acnsms_web ping postgres
```

### Database Connection Issues
```bash
# Check if PostgreSQL container is running
docker ps

# Check PostgreSQL logs
docker-compose logs postgres

# Connect to PostgreSQL directly
docker exec -it acnsms_postgres psql -U acnsms_user -d db_of_acnsms
```

### Application Issues
```bash
# Check application logs
docker-compose logs web

# Restart application
docker-compose restart web

# Debug inside container
docker exec -it acnsms_web /bin/bash
```

### Clean Start
```bash
# Stop everything and remove volumes
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Start fresh
docker-compose up --build
```

## Development Workflow

1. Make changes to your application code
2. Restart the application container:
   ```bash
   docker-compose restart web
   ```

3. For database schema changes:
   - Update `postgres_init.sql`
   - Recreate the database:
     ```bash
     docker-compose down postgres
     docker volume rm btec_fyp_postgres_data
     docker-compose up postgres -d
     ```

## Production Considerations

1. **Environment Variables**: Update `.env` with production values
2. **Secrets**: Use Docker secrets or external secret management
3. **Volumes**: Ensure PostgreSQL data is properly backed up
4. **Network**: Consider using custom networks for security
5. **Health Checks**: Already implemented in docker-compose.yml
6. **Resources**: Add memory and CPU limits if needed

## Backup and Restore

### Backup
```bash
docker exec acnsms_postgres pg_dump -U acnsms_user db_of_acnsms > backup.sql
```

### Restore
```bash
docker exec -i acnsms_postgres psql -U acnsms_user db_of_acnsms < backup.sql
```
