@echo off
echo ACNSMS Docker Diagnostics
echo ========================
echo.

echo 1. Checking Docker status...
docker --version
if errorlevel 1 (
    echo ERROR: Docker is not installed or not running
    goto :end
)

echo.
echo 2. Checking current containers...
docker ps -a --filter "name=acnsms"

echo.
echo 3. Checking Docker Compose status...
docker-compose ps

echo.
echo 4. Checking for port conflicts...
netstat -an | findstr ":5000"
netstat -an | findstr ":5432"

echo.
echo 5. Checking Docker volumes...
docker volume ls | findstr "postgres"

echo.
echo 6. Checking recent container logs...
echo --- PostgreSQL logs (last 20 lines) ---
docker logs acnsms_postgres --tail 20 2>nul
echo.
echo --- Web application logs (last 20 lines) ---
docker logs acnsms_web --tail 20 2>nul

echo.
echo 7. Docker Compose configuration validation...
docker-compose config

:end
echo.
echo Diagnostics complete. Press any key to exit...
pause >nul
