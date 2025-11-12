# Setup and Run Script for Online Auction System
# This script helps set up and run the application

Write-Host "Online Auction System - Setup and Run Script" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Check Java
Write-Host "Checking Java installation..." -ForegroundColor Yellow
$javaVersion = java -version 2>&1 | Select-Object -First 1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Java is installed: $javaVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Java 21 from: https://www.oracle.com/java/technologies/downloads/#java21" -ForegroundColor Yellow
    exit 1
}

# Check Maven
Write-Host "`nChecking Maven installation..." -ForegroundColor Yellow
$mavenVersion = mvn --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Maven is installed" -ForegroundColor Green
    $mavenVersion | Select-Object -First 1
} else {
    Write-Host "✗ Maven is not installed" -ForegroundColor Red
    Write-Host "`nTo install Maven:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://maven.apache.org/download.cgi" -ForegroundColor Cyan
    Write-Host "2. Extract to a folder (e.g., C:\Program Files\Apache\maven)" -ForegroundColor Cyan
    Write-Host "3. Add the 'bin' folder to your PATH environment variable" -ForegroundColor Cyan
    Write-Host "4. Restart your terminal and run this script again" -ForegroundColor Cyan
    Write-Host "`nOr install Chocolatey first, then run: choco install maven" -ForegroundColor Cyan
    exit 1
}

# Check MongoDB
Write-Host "`nChecking MongoDB..." -ForegroundColor Yellow
try {
    $mongoCheck = mongosh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ MongoDB client is installed" -ForegroundColor Green
    } else {
        throw "MongoDB not found"
    }
} catch {
    try {
        $mongoCheck = mongo --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ MongoDB client is installed (legacy)" -ForegroundColor Green
        } else {
            throw "MongoDB not found"
        }
    } catch {
        Write-Host "⚠ MongoDB client not found in PATH" -ForegroundColor Yellow
        Write-Host "Please ensure MongoDB is installed and running" -ForegroundColor Yellow
        Write-Host "Download from: https://www.mongodb.com/try/download/community" -ForegroundColor Cyan
    }
}

# Check if MongoDB is running
Write-Host "`nChecking if MongoDB is running..." -ForegroundColor Yellow
try {
    $mongoConnection = Test-NetConnection -ComputerName localhost -Port 27017 -WarningAction SilentlyContinue
    if ($mongoConnection.TcpTestSucceeded) {
        Write-Host "✓ MongoDB appears to be running on port 27017" -ForegroundColor Green
    } else {
        Write-Host "⚠ MongoDB may not be running on port 27017" -ForegroundColor Yellow
        Write-Host "Please start MongoDB service" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Could not verify MongoDB connection" -ForegroundColor Yellow
}

# Build the project
Write-Host "`nBuilding the project..." -ForegroundColor Yellow
Set-Location $PSScriptRoot
mvn clean install

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Build failed. Please check the errors above." -ForegroundColor Red
    exit 1
}

Write-Host "✓ Build successful!" -ForegroundColor Green

# Ask if user wants to run
Write-Host "`nBuild completed successfully!" -ForegroundColor Green
$run = Read-Host "Do you want to run the application now? (Y/N)"
if ($run -eq "Y" -or $run -eq "y") {
    Write-Host "`nStarting the application..." -ForegroundColor Yellow
    Write-Host "The application will be available at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    mvn tomcat10:run
} else {
    Write-Host "`nTo run the application later, use: mvn tomcat10:run" -ForegroundColor Cyan
}


