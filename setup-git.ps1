# ============================================================
# setup-git.ps1 — Inicializar Git e conectar ao GitHub
# Execute UMA VEZ antes de usar o deploy.ps1
#
# USO:
#   .\setup-git.ps1 -GitHubUrl "https://github.com/SEU-USUARIO/geladeiras-seo.git"
# ============================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubUrl,
    [string]$NomeUsuario = "",
    [string]$EmailUsuario = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

function Write-Step($msg) { Write-Host "`n▶  $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "   ✅ $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "   ❌ $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "🔧  Setup Git — Geladeira Usada BH" -ForegroundColor Blue
Write-Host "    Pasta: $ScriptDir" -ForegroundColor DarkGray
Write-Host ""

# 1. Configurar identidade git (se fornecida)
if ($NomeUsuario) {
    Write-Step "Configurando identidade Git..."
    git config user.name  "$NomeUsuario"
    git config user.email "$EmailUsuario"
    Write-OK "Identidade: $NomeUsuario <$EmailUsuario>"
}

# 2. Inicializar repositório (se não existir)
Write-Step "Inicializando repositório Git..."
if (Test-Path (Join-Path $ScriptDir ".git")) {
    Write-Host "   ⚠️  Repositório já existe — pulando init" -ForegroundColor Yellow
} else {
    git init -b main
    Write-OK "Repositório inicializado (branch: main)"
}

# 3. Configurar remote
Write-Step "Configurando remote origin..."
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-Host "   ⚠️  Remote já existe: $existingRemote" -ForegroundColor Yellow
    $resp = Read-Host "   Substituir pelo novo? ($GitHubUrl) (s/N)"
    if ($resp -match "^[sS]$") {
        git remote set-url origin $GitHubUrl
        Write-OK "Remote atualizado: $GitHubUrl"
    }
} else {
    git remote add origin $GitHubUrl
    Write-OK "Remote adicionado: $GitHubUrl"
}

# 4. Primeiro commit
Write-Step "Criando commit inicial..."
git add -A
$staged = git diff --cached --name-only 2>&1
if ($staged) {
    git commit -m "init: projeto Hugo Geladeira Usada BH"
    Write-OK "Commit inicial criado"
} else {
    Write-Host "   ⚠️  Nada para commitar" -ForegroundColor Yellow
}

# 5. Instruções finais
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅  Repositório configurado!                    ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  Próximo passo — fazer o primeiro push:" -ForegroundColor White
Write-Host ""
Write-Host "    git push -u origin main" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Se o GitHub pedir autenticação, use:" -ForegroundColor White
Write-Host "  → GitHub → Settings → Developer settings → Personal access tokens" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Depois configure os Secrets do GitHub Actions:" -ForegroundColor White
Write-Host "  → FTP_SERVER, FTP_USERNAME, FTP_PASSWORD" -ForegroundColor DarkGray
Write-Host "  → (Veja INSTRUCOES_HOSTINGER.md para detalhes)" -ForegroundColor DarkGray
Write-Host ""
