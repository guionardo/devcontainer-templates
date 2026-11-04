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

O formato padrão é um template com `devcontainer-template.json` e `.devcontainer/devcontainer.json`, empacotado como artefato OCI. A estrutura `src/php-*` deste catálogo segue esse formato. A [especificação](https://containers.dev/implementors/templates/) define metadados e versões; a [CLI oficial](https://github.com/devcontainers/cli/blob/main/docs/templates/apply.md) aplica o pacote a uma pasta local.

O workflow **Publish Dev Container Templates** está preparado em `.github/workflows/publish-templates.yaml`. Ele é manual: enviar código ao GitHub não publica os pacotes automaticamente.

Para publicar pela primeira vez:

1. Conclua as validações desejadas e confira `version` no `devcontainer-template.json` de cada template (atualmente `0.1.0`).
2. No GitHub, abra **Actions → Publish Dev Container Templates → Run workflow**, selecionando `main`.
3. Aguarde o workflow concluir. Ele usa `GITHUB_TOKEN` com `packages: write`, sem precisar cadastrar um token pessoal no repositório.
4. Confira os pacotes em [Packages do mantenedor](https://github.com/guionardo?tab=packages). Para distribuição pública sem autenticação, configure a visibilidade dos pacotes e do pacote de metadados como **public**, conforme as permissões disponíveis.
5. Para novas publicações, incremente a versão dos templates alterados; não reutilize uma versão já publicada.

Após uma publicação bem-sucedida e os ajustes de visibilidade, o uso padrão será, na raiz do projeto:

```powershell
npx @devcontainers/cli templates apply --workspace-folder . --template-id ghcr.io/guionardo/devcontainer-templates/php-5.4:0.1.0
```

Troque o identificador por `php-5.1.6` ou `php-8.5`. Esse comando requer Node.js/npm e acesso ao pacote. Use uma branch do projeto e revise arquivos existentes antes de aplicá-lo: os backups e a preservação de arquivos descritos acima pertencem ao nosso instalador, não são garantias da CLI oficial.

Depois, abra no VS Code e use **Dev Containers: Reopen in Container**. O VS Code consome os arquivos locais resultantes; não é necessário criar uma extensão própria. Ter o repositório GitHub ou o pacote GHCR não garante que o template apareça automaticamente na lista pública de templates do VS Code. A seleção por identificador depende do suporte da versão da extensão; a CLI é o caminho explícito documentado aqui.

Publicar um template OCI distribui configurações, não imagens PHP pré-compiladas. Com os Dockerfiles atuais, o primeiro uso ainda constrói as imagens localmente. Publicar imagens pré-compiladas seria uma etapa adicional.

Fontes oficiais: [template-starter](https://github.com/devcontainers/template-starter), [ação de publicação](https://github.com/devcontainers/action) e [especificação de distribuição](https://github.com/devcontainers/spec/blob/main/docs/specs/devcontainer-templates-distribution.md).
