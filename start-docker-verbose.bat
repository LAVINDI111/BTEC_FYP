@echo off
echo ACNSMS Docker Startup - Step by Step
echo ====================================
echo.

echo Step 1: Stopping any existing containers...
docker-compose down
echo.

echo Step 2: Building images...
docker-compose build
if errorlevel 1 (
    echo ERROR: Build failed
    pause
    exit /b 1
)
echo.

echo Step 3: Starting PostgreSQL database...
docker-compose up -d postgres
echo Waiting for database to be ready...

:wait_db
timeout /t 5 /nobreak >nul
docker exec acnsms_postgres pg_isready -U acnsms_user -d db_of_acnsms >nul 2>&1
if errorlevel 1 (
    echo Still waiting for database...
    goto :wait_db
)

echo Database is ready!
echo.

echo Step 4: Starting web application...
docker-compose up -d web
echo.

echo Step 5: Checking status...
docker-compose ps
echo.

echo Step 6: Checking logs...
echo --- Database logs (last 10 lines) ---
docker logs acnsms_postgres --tail 10
echo.
echo --- Web application logs (last 10 lines) ---
docker logs acnsms_web --tail 10
echo.

echo Setup complete!
echo.
echo Services should be running at:
echo - Application: http://localhost:5000
echo - PostgreSQL: localhost:5432
echo.
echo To view live logs: docker-compose logs -f
echo To stop services: docker-compose down
echo.

pause
