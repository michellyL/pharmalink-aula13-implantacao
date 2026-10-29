# PharmaLink — Aula 13: Implantação e mobilidade

Repositório de apoio para executar a atividade de implantação local do back-end PharmaLink. Os ambientes DEV, HOMOLOG e PROD são **pastas simuladas locais**, não servidores reais.

> Coloque uma cópia/clonagem do projeto PharmaLink na pasta `origem/`. Não altere o repositório original. Os scripts abaixo pressupõem um projeto Maven com `pom.xml` e, se disponível, `mvnw.cmd`. Se o projeto usar Gradle ou outra ferramenta, adapte os comandos ao build real.

## Estrutura

```text
pharmalink-aula13-implantacao/
├── origem/       # cópia local do back-end (não versionar código privado por engano)
├── artefatos/    # distribuição gerada
├── homolog/      # ambiente de homologação simulado
├── prod/         # produção simulada
├── backup/       # cópia de segurança
├── evidencias/   # prints reais das etapas
└── scripts/      # scripts PowerShell
```

## Uso no Windows PowerShell

1. Copie/clonе o projeto PharmaLink para `origem/`.
2. Execute `scripts/01-preparar.ps1`.
3. Execute `scripts/02-build.ps1`.
4. Copie o JAR gerado para HOMOLOG e execute-o conforme o README do projeto.
5. Depois dos testes em HOMOLOG, execute `scripts/03-promover.ps1`.
6. Para a falha controlada, execute `scripts/04-falha-recuperacao.ps1` **somente na pasta simulada**.
7. Faça capturas de tela reais e insira-as no relatório.

## Atenção

- Não coloque senhas, tokens, `.env`, dumps de banco ou dados reais no Git.
- Confira o nome do JAR e o comando de inicialização antes de executar.
- Os scripts não inventam aprovação: a validação funcional precisa ser feita manualmente ou com os testes existentes.
