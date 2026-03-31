param([switch]$Limpar)
$ScriptDir = "C:\projetos\geladeiras-seo"
$ContentDir = "$ScriptDir\content\geladeiras"
$geladeiras = Get-Content "$ScriptDir\data\geladeiras.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$bairros = Get-Content "$ScriptDir\data\bairros.json" -Raw -Encoding UTF8 | ConvertFrom-Json
if ($Limpar) { Get-ChildItem $ContentDir -Filter "*.md" | Where-Object { $_.Name -ne "_index.md" } | Remove-Item -Force; Write-Host "Limpou!" }
$contador = 0
foreach ($gel in $geladeiras) {
    foreach ($bairro in $bairros) {
        $slug = "$($gel.slug)-$($bairro.slug)"
        $file = "$ContentDir\$slug.md"
        if (Test-Path $file) { continue }
        $txt = "---`ntitle: `"$($gel.nome) em $($bairro.nome) - Entrega 24h`"`ndescription: `"Compre $($gel.nome) em $($bairro.nome), $($bairro.cidade). Revisada, $($gel.garantia) garantia. R$ $($gel.preco).`"`ndate: 2026-03-28`ngeladeira_slug: `"$($gel.slug)`"`nbairro_slug: `"$($bairro.slug)`"`nimage: `"$($gel.images[0])`"`nnoindex: false`n---`n"
        [System.IO.File]::WriteAllText($file, $txt, [System.Text.Encoding]::UTF8)
        $contador++
    }
}
Write-Host "Pronto! $contador paginas geradas!" -ForegroundColor Green
