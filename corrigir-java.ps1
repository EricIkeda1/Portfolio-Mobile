$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Portfolio-Mobile - Configuracao Java 17+" -ForegroundColor Cyan
Write-Host ""

$candidates = @(
    "C:\Program Files\Android\Android Studio\jbr",
    "C:\Program Files\Java\jdk-21",
    "C:\Program Files\Java\jdk-17",
    "C:\Program Files\Eclipse Adoptium\jdk-21*",
    "C:\Program Files\Eclipse Adoptium\jdk-17*",
    "C:\Program Files\Microsoft\jdk-21*",
    "C:\Program Files\Microsoft\jdk-17*"
)

$jdk = $null

foreach ($candidate in $candidates) {
    if ($candidate.Contains("*")) {
        $found = Get-ChildItem -Path $candidate -Directory -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending |
            Select-Object -First 1
        if ($found) {
            $jdk = $found.FullName
            break
        }
    }
    elseif (Test-Path $candidate) {
        $jdk = $candidate
        break
    }
}

if (-not $jdk) {
    Write-Host "Nenhum Java 17+ foi encontrado." -ForegroundColor Red
    Write-Host "Instale o Android Studio ou JDK 17 e execute este script novamente."
    exit 1
}

Write-Host "JDK encontrado:" -ForegroundColor Green
Write-Host $jdk
Write-Host ""

$javaExe = Join-Path $jdk "bin\java.exe"
if (-not (Test-Path $javaExe)) {
    Write-Host "java.exe nao encontrado em $jdk" -ForegroundColor Red
    exit 1
}

$versionOutput = & $javaExe -version 2>&1
$versionLine = ($versionOutput | Select-Object -First 1).ToString()
Write-Host $versionLine

if ($versionLine -notmatch '"(\d+)') {
    Write-Host "Nao foi possivel detectar a versao do Java." -ForegroundColor Red
    exit 1
}

$major = [int]$matches[1]
if ($major -lt 17) {
    Write-Host "O Java encontrado e inferior ao 17." -ForegroundColor Red
    exit 1
}

$escapedJdk = $jdk.Replace("\", "\\")

$gradleProperties = Join-Path $PSScriptRoot "android\gradle.properties"
if (-not (Test-Path $gradleProperties)) {
    New-Item -ItemType File -Path $gradleProperties -Force | Out-Null
}

$content = Get-Content $gradleProperties -ErrorAction SilentlyContinue
$content = $content | Where-Object { $_ -notmatch '^org\.gradle\.java\.home=' }
$content += "org.gradle.java.home=$escapedJdk"
Set-Content -Path $gradleProperties -Value $content -Encoding UTF8

Write-Host ""
Write-Host "Configurando Flutter para usar o mesmo JDK..." -ForegroundColor Cyan
flutter config --jdk-dir "$jdk"

Write-Host ""
Write-Host "Limpando projeto..." -ForegroundColor Cyan
flutter clean
flutter pub get

Write-Host ""
Write-Host "Configuracao concluida." -ForegroundColor Green
Write-Host "Execute:"
Write-Host "  flutter run"
Write-Host ""
