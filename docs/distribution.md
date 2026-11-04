# Instalação e distribuição dos templates

## Instalador imediato: GitHub + shell

Execute em **Git Bash, WSL, Linux ou macOS**, dentro do projeto existente. Requer `curl` para baixar o script, Git para obter o catálogo e ferramentas POSIX. No Windows, estes comandos são para o Git Bash/WSL, não para o PowerShell.

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 5.4 --smoke
```

Troque `5.4` por `5.1` ou `8.5`. O diretório atual é o destino por padrão. Para outro projeto:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 8.5 --project "/c/dev/minha aplicacao"
```

Para baixar e revisar o script antes de executá-lo:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh -o install-php-devcontainer.sh
sh install-php-devcontainer.sh --help
sh install-php-devcontainer.sh --php 5.4 --project ./minha-aplicacao --smoke
```

O instalador copia apenas as configurações necessárias e, com `--smoke`, o exemplo de diagnóstico. Não executa Docker, Composer, código PHP ou migrações. O código da aplicação não é modificado.

Se existir `.devcontainer`, a instalação é recusada por padrão. Para atualizar uma configuração existente:

```sh
sh install-php-devcontainer.sh --php 5.4 --project ./minha-aplicacao --update
```

Com `--update`, o script:

- Cria `.devcontainer-backup.XXXXXX` no projeto antes de substituir os arquivos conhecidos do template.
- Atualiza `devcontainer.json`, `Dockerfile` e, quando incluído na versão escolhida, `compose.yaml`. Suas edições nesses arquivos precisam ser reaplicadas a partir do backup.
- Preserva `.env`, arquivos personalizados, código PHP e o `launch.json` existente.
- Grava a nova configuração de debug em `.devcontainer/launch.template.json` quando já existe um `launch.json`. Mescle o array `configurations` manualmente.
- Registra template, referência e commit em `.devcontainer/template-source.txt`.

O script não faz mescla automática de JSON/JSONC e não remove arquivos antigos ao trocar de versão. Ao migrar de um legado para PHP 8.5, por exemplo, um `compose.yaml` anterior pode permanecer, mas o novo `devcontainer.json` não o utiliza. Revise o diff antes de versionar. Não versione backups que contenham configurações locais ou segredos; mova-os para fora do repositório ou ignore-os no `.gitignore` do projeto.

Os legados recebem um nome Compose exclusivo quando `.env` ainda não existe. As portas padrão são 8051 e 8054: altere `PHP_HTTP_PORT` se outros projetos já estiverem usando a mesma porta. Quando `.env` já existe, seus valores são mantidos; confira `COMPOSE_PROJECT_NAME` e `PHP_HTTP_PORT`.

Para usar um catálogo já clonado, sem download:

```sh
sh /c/dev/devcontainer-templates/scripts/install.sh --php 5.4 --source /c/dev/devcontainer-templates --project /c/dev/minha-aplicacao
```

`--ref` aceita branch, tag ou SHA Git. `main` acompanha as mudanças do catálogo. Para uma instalação fixada, baixe o próprio script por um SHA completo e passe o mesmo SHA em `--ref`; assim o instalador e os templates vêm da mesma revisão. Uma versão Git/tag só pode ser usada depois de criada no repositório. Referência Git e versão OCI são identificadores distintos.

Depois da instalação, abra a raiz do projeto no VS Code e execute **Dev Containers: Reopen in Container**. Após uma atualização, use **Dev Containers: Rebuild Container**. O [README](../README.md) detalha execução e debug.

## Distribuição oficial: Dev Container Templates em OCI/GHCR

O formato padrão é um template com `devcontainer-template.json` e `.devcontainer/devcontainer.json`, empacotado como artefato OCI. A estrutura `src/php-*` deste catálogo segue esse formato. A [CLI oficial](https://github.com/devcontainers/cli/blob/main/docs/templates/apply.md) baixa o pacote e aplica a configuração em um projeto existente.

### Aplicar usando npx

Instale Node.js/npm, entre na raiz do projeto e escolha **apenas um** dos comandos abaixo. Os comandos funcionam no PowerShell, Git Bash, WSL, Linux e macOS. A versão OCI indicada deve estar publicada no GHCR e acessível à sua conta (ou pública para download sem autenticação).

PHP 5.1.6:

```powershell
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.1.6:0.1.0
```

PHP 5.4:

```powershell
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.4:0.1.0
```

PHP 8.5:

```powershell
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-8.5:0.1.0
```

Para outro projeto, substitua `--workspace-folder .` por `--workspace-folder "C:\dev\minha-aplicacao"`, por exemplo. Não é necessário clonar o catálogo. A versão após `:` é a versão do template, não a versão do PHP nem a versão da CLI baixada pelo npx.

Use uma branch do projeto e revise configurações existentes antes de aplicar. Os backups e a preservação de arquivos oferecidos pelo instalador shell não são garantias da CLI oficial. Para atualizar uma configuração já personalizada, prefira o instalador com `--update` ou aplique o pacote OCI em uma pasta temporária e mescle as diferenças.

Nos legados, configure `.devcontainer/.env` com `COMPOSE_PROJECT_NAME` exclusivo e a porta `PHP_HTTP_PORT`, conforme o README. A CLI copia o template, mas não gera esses valores por projeto como faz o instalador shell.

Depois, abra a raiz do projeto no VS Code e execute **Dev Containers: Reopen in Container**. Após atualizar arquivos de um ambiente existente, execute **Dev Containers: Rebuild Container**. A aplicação do pacote não inicia containers nem instala dependências da aplicação automaticamente.

### Publicação automática por tags Git

O workflow [Publish Dev Container Templates](../.github/workflows/publish-templates.yaml) é disparado ao enviar uma tag `vMAJOR.MINOR.PATCH`, por exemplo `v0.1.0`. Um push comum em `main` executa as verificações aplicáveis, mas não publica pacotes.

Este catálogo usa **versão única por release**: a tag `v0.1.0` exige `"version": "0.1.0"` no `devcontainer-template.json` dos três templates. A versão é independente dos runtimes PHP. Nas próximas releases, incremente os três metadados juntos, mesmo quando apenas um template tiver alterações.

Procedimento para o mantenedor:

1. Atualize a versão nos três arquivos `src/php-*/devcontainer-template.json` e revise a documentação. Para a primeira release, os arquivos já usam `0.1.0`.
2. Faça commit e envie as alterações para `main`. Aguarde o workflow de validação passar.
3. Atualize o checkout local e confira o commit que deseja publicar. Para a primeira release:

```powershell
git switch main
git pull --ff-only origin main
node scripts/validate-release.cjs v0.1.0
git tag -a v0.1.0 -m "Release Dev Container Templates 0.1.0"
git push origin v0.1.0
```

4. Acompanhe o workflow na aba **Actions**. A tag precisa apontar para um commit do histórico de `main`; o workflow recusa referências de branch, tags incompletas, prereleases e versões diferentes dos metadados. Os testes do instalador, o validador de release, os JSONs e os arquivos Compose são verificados antes da publicação. Builds PHP e breakpoints não são testados por esse workflow.
5. Confira os pacotes em [Packages do mantenedor](https://github.com/guionardo?tab=packages). Para download público sem autenticação, configure a visibilidade dos três templates e do pacote de metadados como **public**, conforme as permissões disponíveis.
6. Teste um dos comandos `npx` acima em uma pasta temporária vazia antes de distribuir a release à equipe.

O workflow usa `GITHUB_TOKEN` com `packages: write`, sem um token pessoal cadastrado no repositório. A ação não cria tags adicionais no Git; a tag enviada pelo mantenedor é o gatilho de release. As tags OCI são gerenciadas pela ação oficial conforme os metadados; os exemplos fixam a versão completa para tornar explícita a release escolhida.

Para a próxima release, use, por exemplo, `0.1.1` nos três metadados e a tag Git `v0.1.1`. Não mova tags publicadas nem reutilize uma versão para conteúdo diferente. Pacotes com uma versão já existente podem ser ignorados pela ferramenta de publicação.

O gatilho manual é mantido para repetir uma publicação da mesma tag após corrigir uma falha de infraestrutura/permissão. Use **Re-run jobs** na execução original ou, com GitHub CLI autenticado:

```powershell
gh workflow run publish-templates.yaml --ref v0.1.0 --repo guionardo/devcontainer-templates
```

Executar manualmente com `main` é recusado. Se a correção alterar os arquivos do template, prepare uma nova versão e uma nova tag.

### Tags Git e instalador shell

Após a tag existir, o instalador também pode aplicar exatamente essa release:

```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/v0.1.0/scripts/install.sh | sh -s -- --php 5.4 --ref v0.1.0
```

Nesse caso, tanto o script quanto o catálogo vêm da mesma tag Git. O pacote equivalente usa `:0.1.0` no endereço GHCR, sem o prefixo `v`.

O VS Code consome os arquivos locais resultantes; não é necessário criar uma extensão própria. Ter o repositório GitHub ou o pacote GHCR não garante que o template apareça automaticamente na lista pública de templates do VS Code. A CLI é o caminho explícito documentado aqui.

Publicar um template OCI distribui configurações, não imagens PHP pré-compiladas. Com os Dockerfiles atuais, o primeiro uso ainda constrói as imagens localmente.

Fontes oficiais: [template-starter](https://github.com/devcontainers/template-starter), [ação de publicação](https://github.com/devcontainers/action) e [especificação de distribuição](https://github.com/devcontainers/spec/blob/main/docs/specs/devcontainer-templates-distribution.md).
