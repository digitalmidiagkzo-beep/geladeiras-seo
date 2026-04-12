# Fase 1 — Template SEO de Bairros
## geladeirausada.com.br

---

## O que está neste pacote

```
geladeirausada/
├── data/bairros/           ← 43 arquivos YAML (um por bairro)
│   ├── barreiro.yaml
│   ├── contagem.yaml
│   ├── betim.yaml
│   └── ... (43 total)
├── content/bairros/        ← 43 arquivos .md (gatilhos Hugo)
│   ├── barreiro.md
│   └── ...
├── layouts/bairros/
│   └── single.html         ← Template único que gera todas as páginas
└── assets/css/
    └── bairros.css         ← CSS das páginas de bairro
```

---

## Instalação passo a passo

### 1. Copiar os data files
```bash
# No seu repositório local:
cp -r data/bairros/  C:/Users/gleic/OneDrive/Documentos/GitHub/geladeiras-seo/data/bairros/
```

### 2. Copiar os content files
```bash
cp -r content/bairros/  C:/Users/gleic/OneDrive/Documentos/GitHub/geladeiras-seo/content/bairros/
```

### 3. Copiar o template
```bash
cp layouts/bairros/single.html  C:/Users/gleic/OneDrive/Documentos/GitHub/geladeiras-seo/layouts/bairros/single.html
```

### 4. Copiar o CSS
```bash
cp assets/css/bairros.css  C:/Users/gleic/OneDrive/Documentos/GitHub/geladeiras-seo/assets/css/bairros.css
```

### 5. Incluir o CSS no template base
No seu `layouts/partials/head-extra.html` (ou onde você importa CSS), adicione:
```html
{{ if eq .Section "bairros" }}
  {{ $css := resources.Get "css/bairros.css" | minify }}
  <link rel="stylesheet" href="{{ $css.RelPermalink }}">
{{ end }}
```

### 6. Atualizar o número de WhatsApp
Nos arquivos YAML gerados, o WhatsApp está como `5531999999999`.
Substitua pelo número real em todos os YAMLs:

**Windows (PowerShell):**
```powershell
Get-ChildItem -Path "data\bairros\*.yaml" -Recurse |
  ForEach-Object {
    (Get-Content $_.FullName) -replace '5531999999999', 'SEU_NUMERO_AQUI' |
    Set-Content $_.FullName
  }
```

**Mac/Linux:**
```bash
find data/bairros/ -name "*.yaml" -exec sed -i 's/5531999999999/SEU_NUMERO/g' {} \;
```

### 7. Testar localmente
```bash
cd C:/Users/gleic/OneDrive/Documentos/GitHub/geladeiras-seo
hugo server -D
```
Acesse: `http://localhost:1313/bairros/barreiro/`
Acesse: `http://localhost:1313/bairros/contagem/`

### 8. Verificar geração
```bash
hugo --minify
# Deve aparecer algo como:
# Pages: 872 + 43 = 915 pages
```

---

## Bairros gerados (43 total)

### Belo Horizonte (27 bairros)
barreiro, venda-nova, pampulha, noroeste, norte, nordeste, leste,
centro-sul, oeste, caicara, alipio-de-melo, sao-paulo, conjunto-california,
jardim-america, buritis, cabana-do-pai-tomas, taquaril, floresta,
santa-efigenia, itapoa, ribeiro-de-abreu, jatoba, jardim-leblon,
ceu-azul, lagoinha, sao-luis, prado

### Contagem (7 bairros)
contagem, eldorado, sede, nacional, petrolandia, ressaca, cite

### Betim (6 bairros)
betim, imbirucu, citrolandia, braunas, jardim-teresopolis, duque-de-caxias

### Vespasiano (3 bairros)
vespasiano, caetano-furquim, varzea

---

## URLs geradas
Cada bairro cria a URL: `/bairros/{slug}/`

Exemplos:
- geladeirausada.com.br/bairros/barreiro/
- geladeirausada.com.br/bairros/contagem/
- geladeirausada.com.br/bairros/betim/
- geladeirausada.com.br/bairros/venda-nova/

---

## O que cada página tem

✅ H1 único com bairro + "Entrega 24h"
✅ Meta title e description únicos
✅ Schema JSON-LD: LocalBusiness + FAQPage + BreadcrumbList
✅ Texto SEO único por bairro (anti-duplicate content)
✅ FAQ com 4 perguntas únicas por bairro
✅ Internal linking para bairros vizinhos
✅ CTA WhatsApp fixo (flutuante no mobile)
✅ Prova social (500+ clientes, 4.9★, 24h, 60% economia)
✅ Seção de benefícios
✅ CSS responsivo mobile-first

---

## Próximos passos após deploy

1. **Submeter sitemap** no Google Search Console
2. **Verificar rich results** em: https://search.google.com/test/rich-results
3. **Checar mobile** no Google Mobile-Friendly Test
4. **Monitorar indexação** — primeiras páginas indexam em 2-4 semanas
5. **Fase 2**: adicionar páginas por marca (/marcas/brastemp/, /marcas/consul/)
