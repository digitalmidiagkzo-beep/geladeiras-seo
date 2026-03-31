# ============================================================
# deploy.ps1 — Build Hugo + Git Push automático
# Geladeira Usada BH
#
# USO:
#   .\deploy.ps1
#   .\deploy.ps1 -Mensagem "Adicionei novos produtos"
#   .\deploy.ps1 -ApenasVerificar   (dry-run, não faz push)
#   .\deploy.ps1 -PularBuild        (push direto sem rebuild)
#
# PRÉ-REQUISITOS:
#   - Hugo instalado e no PATH
#   - Git instalado e configurado
#   - Repositório GitHub já conectado (git remote add origin <url>)
# ============================================================

param(
    [string]$Mensagem      = "",
    [switch]$ApenasVerificar,
    [switch]$PularBuild,
    [switch]$Silencioso
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ── Configurações ──────────────────────────────────────────
$BRANCH        = "main"
$BUILD_DIR     = Join-Path $ScriptDir "public"
$LOG_FILE      = Join-Path $ScriptDir "deploy-log-$(Get-Date -Format 'yyyy-MM-dd').txt"
# ───────────────────────────────────────────────────────────

# ── Helpers ────────────────────────────────────────────────
function Write-Step($emoji, $msg) {
    $line = "$emoji  $msg"
    Write-Host $line -ForegroundColor Cyan
    Add-Content $LOG_FILE "$(Get-Date -Format 'HH:mm:ss') | $line" -Encoding UTF8
}
function Write-OK($msg) {
    Write-Host "   ✅ $msg" -ForegroundColor Green
    Add-Content $LOG_FILE "$(Get-Date -Format 'HH:mm:ss') | OK: $msg" -Encoding UTF8
}
function Write-Fail($msg) {
    Write-Host "   ❌ $msg" -ForegroundColor Red
    Add-Content $LOG_FILE "$(Get-Date -Format 'HH:mm:ss') | ERRO: $msg" -Encoding UTF8
    exit 1
}
function Write-Warn($msg) {
    Write-Host "   ⚠️  $msg" -ForegroundColor Yellow
    Add-Content $LOG_FILE "$(Get-Date -Format 'HH:mm:ss') | AVISO: $msg" -Encoding UTF8
}
function Run($cmd) {
    if (-not $Silencioso) { Write-Host "   > $cmd" -ForegroundColor DarkGray }
    Invoke-Expression $cmd
    if ($LASTEXITCODE -ne 0) { Write-Fail "Comando falhou: $cmd (código $LASTEXITCODE)" }
}
# ───────────────────────────────────────────────────────────

# ── Cabeçalho ──────────────────────────────────────────────
$inicio = Get-Date
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║   🚀  Geladeira Usada BH — Deploy        ║" -ForegroundColor Blue
Write-Host "║   $(Get-Date -Format 'dd/MM/yyyy HH:mm')                      ║" -ForegroundColor Blue
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

Set-Location $ScriptDir

# ── 1. Verificar pré-requisitos ────────────────────────────
Write-Step "🔍" "Verificando pré-requisitos..."

if (-not (Get-Command "hugo" -ErrorAction SilentlyContinue)) {
    Write-Fail "Hugo não encontrado no PATH. Instale via: winget install Hugo.Hugo.Extended"
}
Write-OK "Hugo: $(hugo version --short 2>$null)"

if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Fail "Git não encontrado no PATH. Baixe em: https://git-scm.com"
}
Write-OK "Git: $(git --version)"

# Verificar se é um repositório git
if (-not (Test-Path (Join-Path $ScriptDir ".git"))) {
    Write-Fail "Não é um repositório Git. Execute primeiro: git init && git remote add origin <URL>"
}

# Verificar remote
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Fail "Remote 'origin' não configurado. Execute: git remote add origin https://github.com/SEU-USUARIO/geladeiras-seo.git"
}
Write-OK "Remote: $remoteUrl"

# ── 2. Verificar arquivos pendentes ───────────────────────
Write-Step "📋" "Verificando status do repositório..."

$status = git status --porcelain 2>&1
$hasChanges = ($status | Where-Object { $_ -match "^\s*[MADRCU?]" }).Count -gt 0

if (-not $hasChanges) {
    Write-Warn "Nenhuma alteração detectada no repositório."
    if (-not $ApenasVerificar) {
        $resp = Read-Host "   Continuar mesmo assim? (s/N)"
        if ($resp -notmatch "^[sS]$") {
            Write-Host "   Abortado pelo usuário." -ForegroundColor Yellow
            exit 0
        }
    }
} else {
    $changedFiles = ($status | Where-Object { $_ -match "^\s*[MADRCU?]" }).Count
    Write-OK "$changedFiles arquivo(s) modificado(s) detectado(s)"
    if (-not $Silencioso) {
        git status --short
    }
}

if ($ApenasVerificar) {
    Write-Host ""
    Write-Host "   [Dry-run] Verificação concluída. Nenhuma ação executada." -ForegroundColor Yellow
    exit 0
}

# ── 3. Build Hugo ─────────────────────────────────────────
if (-not $PularBuild) {
    Write-Step "🏗️" "Executando build Hugo (produção)..."

    # Limpar build anterior
    if (Test-Path $BUILD_DIR) {
        Remove-Item $BUILD_DIR -Recurse -Force
        Write-OK "Build anterior removido"
    }

    $buildStart = Get-Date
    Run "hugo --minify --gc --cleanDestinationDir"
    $buildSec = [math]::Round(((Get-Date) - $buildStart).TotalSeconds, 1)

    # Verificar resultado
    if (-not (Test-Path (Join-Path $BUILD_DIR "index.html"))) {
        Write-Fail "Build falhou — index.html não gerado em /public/"
    }

    $totalPages = (Get-ChildItem $BUILD_DIR -Filter "*.html" -Recurse).Count
    $totalSize  = [math]::Round((Get-ChildItem $BUILD_DIR -Recurse | Measure-Object Length -Sum).Sum / 1MB, 2)
    Write-OK "Build concluído em ${buildSec}s — $totalPages páginas HTML — ${totalSize}MB"
} else {
    Write-Warn "Build pulado (flag -PularBuild)"
}

# ── 4. Git add + commit ───────────────────────────────────
Write-Step "📦" "Preparando commit..."

Run "git add -A"

# Montar mensagem de commit
if (-not $Mensagem) {
    $pagesCount = (Get-ChildItem (Join-Path $ScriptDir "content") -Filter "*.md" -Recurse | Where-Object { $_.Name -ne "_index.md" }).Count
    $Mensagem = "deploy: atualização automática — $pagesCount páginas — $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
}

# Verificar se há algo para commitar
$staged = git diff --cached --name-only 2>&1
if (-not $staged) {
    Write-Warn "Nada para commitar (staged area vazia)."
} else {
    Run "git commit -m `"$Mensagem`""
    Write-OK "Commit criado: $Mensagem"
}

# ── 5. Git push ───────────────────────────────────────────
Write-Step "🌐" "Enviando para o GitHub..."

# Verificar se a branch existe no remote
$remoteBranch = git ls-remote --heads origin $BRANCH 2>$null
if (-not $remoteBranch) {
    Write-Warn "Branch '$BRANCH' não existe no remote. Criando..."
    Run "git push -u origin $BRANCH"
} else {
    Run "git push origin $BRANCH"
}

Write-OK "Push concluído para origin/$BRANCH"

# ── 6. Resumo final ───────────────────────────────────────
$duracao = [math]::Round(((Get-Date) - $inicio).TotalSeconds, 0)
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅  Deploy concluído com sucesso!       ║" -ForegroundColor Green
Write-Host "║                                          ║" -ForegroundColor Green
Write-Host "║   ⏱️  Tempo total: ${duracao}s$((' ' * [Math]::Max(0, 22 - $duracao.ToString().Length)))║" -ForegroundColor Green
Write-Host "║   🔗  GitHub Actions irá fazer FTP       ║" -ForegroundColor Green
Write-Host "║   🌐  https://geladeirausada.com.br/     ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "   📋 Acompanhe o deploy em:" -ForegroundColor White
Write-Host "   https://github.com/SEU-USUARIO/geladeiras-seo/actions" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "   📄 Log salvo em: $LOG_FILE" -ForegroundColor DarkGray
Write-Host ""
