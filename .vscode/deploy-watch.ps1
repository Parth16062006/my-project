# deploy-watch.ps1
# Simple FileSystemWatcher-based watcher that runs Maven build and robocopy on file changes.
# Usage: run the VS Code task "watch-and-deploy" which runs this script in a terminal.

param()

$tomcatPath = 'C:\Users\siddh\.rsp\redhat-community-server-connector\runtimes\installations\tomcat-11.0.0-M6_3\apache-tomcat-11.0.0-M6'
$source = Join-Path -Path (Join-Path $PWD 'target') 'Online-Auction-System-1.0.0'
$dest = Join-Path -Path $tomcatPath 'webapps\Online-Auction-System'

Write-Host "Watching workspace: $PWD"
Write-Host "Source (built app): $source"
Write-Host "Tomcat dest: $dest"

# File types to watch
$extensions = @('*.java','*.jsp','*.xml','*.properties','*.html','*.css','*.js')

# Create a watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $PWD
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.Filter = '*.*'

$action = {
    $path = $Event.SourceEventArgs.FullPath
    foreach ($ext in $extensions) {
        if ($path -like $ext) {
            Write-Host "Change detected: $path"

            # Run mvn build
            Write-Host "Running: mvn -DskipTests clean package"
            $mvnExit = & mvn -DskipTests clean package

            if ($LASTEXITCODE -ne 0) {
                Write-Host "Maven build failed (exit $LASTEXITCODE). Skipping deploy." -ForegroundColor Red
                return
            }

            # Ensure source exists
            if (-not (Test-Path $source)) {
                Write-Host "Built source not found: $source" -ForegroundColor Yellow
                return
            }

            # Run robocopy to update changed files only (no deletions)
            $robocopyArgs = @(
                "`"$source`"",
                "`"$dest`"",
                "/E",
                "/XO",
                "/FFT",
                "/Z",
                "/W:2",
                "/R:2",
                "/NP",
                "/NFL",
                "/NDL"
            )
            Write-Host "Running robocopy to sync changed files..."
            & robocopy @robocopyArgs

            Write-Host "Deploy complete. Tomcat should detect the changes and reload the webapp if auto-deploy is enabled."

            break
        }
    }
}

# Register events
$null = Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action -SourceIdentifier FSChanged
$null = Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action -SourceIdentifier FSCreated
$null = Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $action -SourceIdentifier FSRenamed

Write-Host "Watcher started. Press Ctrl+C to stop."

# Keep script alive
while ($true) { Start-Sleep -Seconds 1 }
