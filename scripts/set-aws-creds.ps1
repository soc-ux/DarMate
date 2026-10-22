param(
    [Parameter(Mandatory=$true)] [string]$AccessKey,
    [Parameter(Mandatory=$true)] [string]$SecretKey,
    [Parameter(Mandatory=$true)] [string]$SessionToken
)

$env:AWS_ACCESS_KEY_ID = $AccessKey
$env:AWS_SECRET_ACCESS_KEY = $SecretKey
$env:AWS_SESSION_TOKEN = $SessionToken
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "Identifiants AWS Academy recharges pour us-east-1 !" -ForegroundColor Green
