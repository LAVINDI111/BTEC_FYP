@echo off
echo Starting ACNSMS with PostgreSQL...
echo.

echo Building and starting containers...
docker-compose up --build -d

echo.
echo Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo.
echo Services should be running at:
echo - Application: http://localhost:5000
echo - PostgreSQL: localhost:5432
echo.

echo To view logs:
echo   docker-compose logs -f
echo.
echo To stop services:
echo   docker-compose down
echo.

pause
