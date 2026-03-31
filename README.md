# ❄️ Geladeiras Usadas BH — SEO Programático com Hugo

Site estático de SEO programático para venda de geladeiras usadas em **Belo Horizonte e Região Metropolitana**. Gera 500+ landing pages únicas combinando modelos × bairros, cada uma otimizada para busca local.

---

## 📁 Estrutura do Projeto

```
geladeiras-seo/
├── hugo.toml                     # Configuração principal do Hugo
├── gerar-paginas.ps1             # Script PowerShell para gerar 500+ páginas
├── archetypes/
│   └── geladeiras.md             # Template de frontmatter
├── content/
│   ├── _index.md                 # Homepage
│   └── geladeiras/
│       ├── _index.md             # Seção /geladeiras/
│       └── [modelo]-[bairro].md  # Páginas geradas (500+)
├── data/
│   ├── geladeiras.json           # 10 modelos com preços e detalhes
│   ├── bairros.json              # 52 bairros de BH e RMBH
│   ├── depoimentos.json          # Depoimentos de clientes
│   └── faq.json                  # FAQ com Schema.org
├── layouts/
│   ├── index.html                # Layout da homepage
│   ├── 404.html                  # Página 404
│   ├── _default/
│   │   ├── baseof.html           # Layout base (head, header, footer)
│   │   ├── single.html           # Landing page produto+bairro
│   │   └── list.html             # Listagem de produtos
│   └── partials/
│       ├── header.html           # Cabeçalho com nav
│       ├── footer.html           # Rodapé completo
│       ├── schema-localbusiness.html  # Schema.org LocalBusiness
│       ├── schema-faq.html            # Schema.org FAQPage
│       └── whatsapp-float.html        # Botão WhatsApp flutuante
└── static/
    ├── css/main.css              # CSS mobile-first completo
    ├── js/main.js                # JS: carrossel, FAQ, lazy load
    ├── images/placeholder.svg    # Imagem placeholder
    ├── favicon.svg               # Favicon
    ├── robots.txt                # Robots.txt
    └── .htaccess                 # Configuração Apache (Hostinger)
```

---

## 🚀 Pré-requisitos

- **Hugo** v0.120+ (extended): https://gohugo.io/installation/
- **PowerShell** 5.1+ ou PowerShell Core (já incluso no Windows 10/11)
- **Git** (opcional, para controle de versão)

### Verificar instalação do Hugo
```powershell
hugo version
```

---

## ⚙️ Instalação

### 1. Instalar Hugo (Windows)

**Via Winget (recomendado):**
```powershell
winget install Hugo.Hugo.Extended
```

**Via Chocolatey:**
```powershell
choco install hugo-extended
```

**Manual:** Baixe o executável em https://github.com/gohugoio/hugo/releases e adicione ao PATH.

### 2. Entrar na pasta do projeto
```powershell
cd C:\projetos\geladeiras-seo
```

---

## 📄 Gerar as Páginas (500+)

Execute o script PowerShell para combinar todos os modelos com todos os bairros:

```powershell
# Gerar TODAS as páginas (10 modelos × 52 bairros = 520 páginas)
.\gerar-paginas.ps1

# Gerar páginas com limite (para teste)
.\gerar-paginas.ps1 -LimiteGeladeiras 3 -LimiteBairros 10

# Limpar e regenerar tudo do zero
.\gerar-paginas.ps1 -Limpar
```

O script cria automaticamente arquivos `.md` em `content/geladeiras/` com:
- Título SEO otimizado (modelo + bairro + preço)
- Meta description única por página
- Variação de preço por região (+3% Centro-Sul, -3% RMBH)
- Frontmatter com todos os dados necessários

---

## 🖥️ Desenvolvimento Local

```powershell
# Iniciar servidor local com live reload
hugo server -D

# Acessar em: http://localhost:1313
```

---

## 🏗️ Build para Produção

```powershell
# Build otimizado com minificação
hugo --minify

# Os arquivos ficam em: ./public/
```

---

## 🌐 Deploy na Hostinger

### Método 1: FTP Manual

1. Execute `hugo --minify` para gerar a pasta `public/`
2. Acesse o **hPanel da Hostinger** → File Manager
3. Navegue até `public_html/`
4. Faça upload de **todo o conteúdo** de `./public/` (não a pasta em si)
5. O arquivo `.htaccess` já está incluído em `static/`

### Método 2: Git + Deploy Automático (recomendado)

1. Crie um repositório no GitHub
2. No hPanel: **Git** → conecte o repositório
3. Configure o build command: `hugo --minify`
4. Publish directory: `public`

### Método 3: GitHub Actions

Crie `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Hostinger
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true
      - name: Build
        run: hugo --minify
      - name: Deploy via FTP
        uses: SamKirkland/FTP-Deploy-Action@v4.3.4
        with:
          server: ${{ secrets.FTP_SERVER }}
          username: ${{ secrets.FTP_USERNAME }}
          password: ${{ secrets.FTP_PASSWORD }}
          local-dir: ./public/
```

---

## 🔧 Personalização

### Trocar número de WhatsApp
Edite `hugo.toml`:
```toml
[params]
  whatsapp = "5531999999999"  # DDI+DDD+Número (sem espaços ou símbolos)
```

### Adicionar novos modelos de geladeira
Edite `data/geladeiras.json` — adicione um objeto seguindo o padrão existente.

### Adicionar novos bairros
Edite `data/bairros.json` — adicione um objeto com `slug`, `nome`, `cidade`, `uf`, `regiao` e `cep_base`.

### Trocar domínio
Edite `hugo.toml`:
```toml
baseURL = "https://seudominio.com.br/"
```

### Ativar Google Analytics
Edite `hugo.toml`:
```toml
[params]
  gaID = "G-XXXXXXXXXX"
```

E adicione em `layouts/partials/` um arquivo `analytics.html`:
```html
{{ if .Site.Params.gaID }}
<script async src="https://www.googletagmanager.com/gtag/js?id={{ .Site.Params.gaID }}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', '{{ .Site.Params.gaID }}');
</script>
{{ end }}
```

### Adicionar fotos reais
Coloque as fotos em `static/images/` seguindo a nomenclatura:
- `brastemp-420l-1.jpg`, `brastemp-420l-2.jpg`, `brastemp-420l-3.jpg`
- `consul-300l-1.jpg`, `consul-300l-2.jpg`, `consul-300l-3.jpg`
- (etc, conforme os slugs em `data/geladeiras.json`)

**Tamanho recomendado:** 800×600px, máximo 150KB (use WebP para melhor performance).

---

## 📈 SEO — Recursos Implementados

| Recurso | Status |
|---|---|
| H1 dinâmico (Modelo + Bairro) | ✅ |
| Meta title único por página | ✅ |
| Meta description única | ✅ |
| Canonical URL | ✅ |
| Schema.org Product | ✅ |
| Schema.org LocalBusiness | ✅ |
| Schema.org FAQPage | ✅ |
| Schema.org AggregateRating | ✅ |
| Open Graph / Twitter Card | ✅ |
| sitemap.xml automático | ✅ |
| robots.txt | ✅ |
| Lazy loading de imagens | ✅ |
| Mobile-first responsive | ✅ |
| HTTPS redirect (.htaccess) | ✅ |
| Cache headers | ✅ |
| GZIP compression | ✅ |
| Preço variável por região | ✅ |

---

## 🗺️ Estrutura de URLs

```
/                                          → Homepage
/geladeiras/                               → Listagem geral
/geladeiras/brastemp-frost-free-420l-savassi/   → Landing page
/geladeiras/samsung-french-door-460l-pampulha/  → Landing page
/geladeiras/lg-side-by-side-573l-betim-centro/  → Landing page
/sitemap.xml                               → Sitemap automático
/robots.txt                                → Robots
```

---

## 📊 Volume de Páginas

Com a configuração padrão (10 modelos × 52 bairros):

| Tipo | Quantidade |
|---|---|
| Landing pages produto+bairro | **520** |
| Páginas de seção | 1 |
| Homepage | 1 |
| **Total** | **~522** |

Para escalar ainda mais, adicione modelos em `data/geladeiras.json` e bairros em `data/bairros.json`.

---

## 🐛 Troubleshooting

**Hugo não encontra o tema:**
```
# hugo.toml já tem theme = "" (sem tema externo — correto)
```

**Erro de encoding no PowerShell:**
```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = "utf-8"
.\gerar-paginas.ps1
```

**Páginas não aparecem:**
```powershell
# Verifique se o frontmatter está correto
hugo --verbose 2>&1 | Select-String "ERROR|WARN"
```

**Build lento com 500+ páginas:**
```powershell
# Use o flag de paralelismo
hugo --numWorkers 8 --minify
```

---

## 📝 Licença

Projeto privado. Todos os direitos reservados.

---

*Gerado em {{ now.Format "2006-01-02" }} — Geladeiras Usadas BH*
