# 🚀 Deploy Automático: GitHub → Hostinger
## Geladeira Usada BH — Passo a Passo Completo

> **Tempo estimado:** 20–30 minutos na primeira vez  
> **Resultado:** cada `git push` publica o site automaticamente em https://geladeirausada.com.br/

---

## Visão Geral do Fluxo

```
Você edita arquivos
      │
      ▼
 deploy.ps1        ← script local
 (hugo build)
      │
      ▼
  git push ──────→  GitHub (repositório)
                          │
                          ▼
                   GitHub Actions         ← automático
                   (hugo --minify)
                          │
                    FTP Deploy
                          │
                          ▼
                   Hostinger /public_html/
                          │
                          ▼
              🌐 geladeirausada.com.br
```

---

## PARTE 1 — Criar Repositório no GitHub

### Passo 1.1 — Criar conta (se não tiver)
1. Acesse **https://github.com**
2. Clique em **Sign up** e crie sua conta gratuita
3. Confirme o e-mail

### Passo 1.2 — Criar o repositório
1. Após logar, clique no **+** (canto superior direito) → **New repository**
2. Preencha:
   - **Repository name:** `geladeiras-seo`
   - **Description:** `Site Hugo SEO programático — Geladeiras Usadas BH`
   - **Visibility:** `Private` ← recomendado (seus dados de negócio ficam protegidos)
   - **NÃO marque** "Add a README file" (já temos um)
   - **NÃO marque** .gitignore nem license
3. Clique em **Create repository**

4. **Copie a URL** do repositório que aparece na tela:
   ```
   https://github.com/SEU-USUARIO/geladeiras-seo.git
   ```

---

## PARTE 2 — Configurar Git Local (PowerShell)

Abra o **PowerShell** na pasta do projeto:

```powershell
cd C:\projetos\geladeiras-seo
```

### Passo 2.1 — Executar o script de setup

```powershell
.\setup-git.ps1 -GitHubUrl "https://github.com/SEU-USUARIO/geladeiras-seo.git" `
                -NomeUsuario "Seu Nome" `
                -EmailUsuario "seu@email.com"
```

> Substitua `SEU-USUARIO`, `Seu Nome` e `seu@email.com` pelos seus dados reais.

### Passo 2.2 — Primeiro push

```powershell
git push -u origin main
```

Se o terminal pedir senha, use um **Personal Access Token** do GitHub:

1. GitHub → clique na foto de perfil → **Settings**
2. Role até o final → **Developer settings**
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token (classic)**
5. Marque: `repo` (acesso completo ao repositório)
6. Clique **Generate token** e **copie o token** (aparece só uma vez!)
7. Use o token como senha quando o git pedir

---

## PARTE 3 — Obter Dados FTP da Hostinger

### Passo 3.1 — Acessar hPanel

1. Acesse **https://hpanel.hostinger.com**
2. Faça login com sua conta Hostinger

### Passo 3.2 — Encontrar dados FTP

1. No painel, clique em **Hospedagem** (ou selecione seu plano)
2. Clique em **Gerenciar** ao lado do domínio `geladeirausada.com.br`
3. No menu lateral esquerdo, procure **Arquivos** → **Contas FTP**
   - OU use a barra de busca do hPanel e pesquise "FTP"

4. Você verá (ou precisará criar):
   | Campo | O que anotar |
   |---|---|
   | **Servidor FTP** | Ex: `ftp.geladeirausada.com.br` ou `files.hostinger.com` |
   | **Usuário FTP** | Ex: `u123456789` ou `u123456789.geladeirausada.com.br` |
   | **Senha FTP** | A senha que você definiu (ou clique em "Alterar Senha") |
   | **Porta** | Geralmente `21` (padrão FTP) |

### Passo 3.3 — Criar conta FTP (se necessário)

Se não houver uma conta FTP criada:
1. Clique em **Criar conta FTP**
2. Defina:
   - Usuário: `geladeiras` (ou qualquer nome)
   - Senha: crie uma senha forte (anote!)
   - Diretório: `/public_html` (pasta raiz do site)
3. Clique em **Criar**

---

## PARTE 4 — Configurar Secrets no GitHub

Os Secrets são variáveis criptografadas que o GitHub Actions usa sem expor suas credenciais.

### Passo 4.1 — Acessar configurações do repositório

1. Acesse seu repositório no GitHub
2. Clique na aba **Settings** (engrenagem)
3. No menu lateral: **Secrets and variables** → **Actions**
4. Clique em **New repository secret**

### Passo 4.2 — Adicionar os 3 Secrets obrigatórios

Adicione um de cada vez:

---

**Secret 1:**
```
Name:  FTP_SERVER
Value: ftp.geladeirausada.com.br
       (use o servidor FTP anotado no Passo 3.2)
```
→ Clique **Add secret**

---

**Secret 2:**
```
Name:  FTP_USERNAME
Value: u123456789
       (use o usuário FTP anotado no Passo 3.2)
```
→ Clique **Add secret**

---

**Secret 3:**
```
Name:  FTP_PASSWORD
Value: SuaSenhaFTPAqui
       (use a senha FTP definida no Passo 3.2)
```
→ Clique **Add secret**

---

Após adicionar os 3, a tela deve mostrar:

```
✅ FTP_PASSWORD    Updated X minutes ago
✅ FTP_SERVER      Updated X minutes ago
✅ FTP_USERNAME    Updated X minutes ago
```

---

## PARTE 5 — Verificar Deploy no GitHub Actions

### Passo 5.1 — Acionar o primeiro deploy

Faça qualquer alteração no projeto e execute o deploy:

```powershell
cd C:\projetos\geladeiras-seo
.\deploy.ps1 -Mensagem "primeiro deploy"
```

### Passo 5.2 — Acompanhar execução

1. Acesse o repositório no GitHub
2. Clique na aba **Actions**
3. Você verá o workflow **"🚀 Deploy Hugo → Hostinger"** rodando
4. Clique nele para ver os logs em tempo real

O workflow executa em ~3–5 minutos e mostra:
```
✅ 📥 Checkout do repositório
✅ 🔧 Instalar Hugo Extended
✅ ✅ Verificar Hugo
✅ 🏗️ Build Hugo (produção)
✅ 📊 Arquivos gerados
✅ 🌐 Deploy FTP → Hostinger
✅ 🎉 Deploy concluído
```

### Passo 5.3 — Verificar o site

Acesse **https://geladeirausada.com.br/** e confirme que está no ar!

---

## PARTE 6 — Apontar Domínio para Hostinger (se ainda não fez)

Se o domínio `geladeirausada.com.br` ainda não aponta para a Hostinger:

### Opção A — Domínio registrado na própria Hostinger
Já deve estar configurado automaticamente.

### Opção B — Domínio em outro registrador (Registro.br, GoDaddy, etc.)

1. No **hPanel**, vá em **Hospedagem** → **Gerenciar** → **Visão Geral**
2. Anote os **Nameservers** da Hostinger:
   ```
   ns1.dns-parking.com
   ns2.dns-parking.com
   ```
   (os nameservers reais aparecem no hPanel — use os que estão lá)

3. No painel do seu registrador de domínio, altere os nameservers para os da Hostinger
4. Aguarde propagação DNS: **2 a 48 horas**

### Ativar SSL (HTTPS) na Hostinger

1. hPanel → **SSL** → **Gerenciar**
2. Clique em **Instalar** ao lado do domínio
3. Selecione **Let's Encrypt** (gratuito)
4. Aguarde alguns minutos

---

## PARTE 7 — Fluxo de Trabalho do Dia a Dia

Depois da configuração inicial, publicar atualizações é simples:

### Adicionar nova geladeira ou bairro

```powershell
cd C:\projetos\geladeiras-seo

# 1. Edite data/geladeiras.json ou data/bairros.json

# 2. Regenere as páginas
.\gerar-paginas.ps1

# 3. Deploy automático
.\deploy.ps1 -Mensagem "Novo modelo: Consul 480L"
```

### Alterar preços

```powershell
# 1. Edite data/geladeiras.json

# 2. Regenere e faça deploy
.\gerar-paginas.ps1 -Limpar
.\deploy.ps1 -Mensagem "Atualização de preços"
```

### Atualizar apenas textos/layout

```powershell
# Edite os layouts/partials diretamente
# Deploy sem regenerar páginas:
.\deploy.ps1 -Mensagem "Ajuste no layout mobile"
```

---

## Troubleshooting — Problemas Comuns

### ❌ "Authentication failed" no FTP

**Causa:** Senha ou usuário FTP incorreto nos Secrets.

**Solução:**
1. Teste o FTP com um cliente como FileZilla:
   - Host: `ftp.geladeirausada.com.br`
   - Usuário e senha dos seus dados FTP
   - Porta: 21
2. Se funcionar no FileZilla, atualize os Secrets no GitHub
3. Re-execute o workflow: Actions → workflow → **Re-run all jobs**

---

### ❌ "Connection timeout" no FTP

**Causa:** Servidor FTP incorreto ou firewall.

**Solução:**
1. Verifique o endereço do servidor FTP no hPanel
2. Alguns planos Hostinger usam `files.hostinger.com` em vez do domínio
3. Tente também usar o IP direto (encontrado no hPanel)

---

### ❌ Site mostra conteúdo antigo após deploy

**Causa:** Cache do navegador ou CDN.

**Solução:**
1. Limpe o cache: `Ctrl + Shift + R` (hard refresh)
2. Teste em aba anônima: `Ctrl + Shift + N`
3. No hPanel, procure **Cache** e clique em **Limpar Cache**

---

### ❌ GitHub Actions falha no step "Build Hugo"

**Causa:** Erro no código Hugo (template, TOML, etc.)

**Solução:**
1. Teste localmente primeiro: `hugo --minify`
2. O erro aparece no terminal com a linha exata do problema
3. Corrija e faça novo push

---

### ❌ Páginas retornam 404 no site

**Causa:** Arquivos enviados para a pasta errada no FTP.

**Solução:**
1. Acesse hPanel → **File Manager**
2. Confirme que os arquivos `.html` estão em `/public_html/` (não em `/public_html/public/`)
3. Se estiverem na pasta errada, edite `server-dir` no workflow:
   ```yaml
   server-dir: /public_html/  # ← confirme este caminho no hPanel
   ```

---

## Resumo — Comandos Essenciais

```powershell
# CONFIGURAÇÃO INICIAL (uma vez só)
.\setup-git.ps1 -GitHubUrl "https://github.com/USUARIO/geladeiras-seo.git"
git push -u origin main

# DEPLOY DO DIA A DIA
.\deploy.ps1

# DEPLOY COM MENSAGEM CUSTOMIZADA
.\deploy.ps1 -Mensagem "descrição do que mudou"

# GERAR PÁGINAS + DEPLOY
.\gerar-paginas.ps1
.\deploy.ps1 -Mensagem "novas páginas geradas"

# VERIFICAR SEM FAZER NADA
.\deploy.ps1 -ApenasVerificar

# PUSH SEM REBUILD (apenas código)
.\deploy.ps1 -PularBuild -Mensagem "ajuste de layout"
```

---

## Checklist de Configuração

Use para não esquecer nenhuma etapa:

- [ ] Repositório GitHub criado (privado)
- [ ] `setup-git.ps1` executado com sucesso
- [ ] Primeiro `git push -u origin main` feito
- [ ] Dados FTP anotados do hPanel (servidor, usuário, senha)
- [ ] Secret `FTP_SERVER` configurado no GitHub
- [ ] Secret `FTP_USERNAME` configurado no GitHub
- [ ] Secret `FTP_PASSWORD` configurado no GitHub
- [ ] Primeiro `.\deploy.ps1` executado
- [ ] GitHub Actions concluiu sem erros (aba Actions ✅)
- [ ] Site acessível em https://geladeirausada.com.br/
- [ ] SSL (HTTPS) ativado na Hostinger
- [ ] `hugo.toml` atualizado com WhatsApp, telefone e e-mail reais
- [ ] `gerar-paginas.ps1` executado para gerar as 530 páginas

---

*Geladeira Usada BH — Documentação de Deploy*  
*Última atualização: Março 2026*
