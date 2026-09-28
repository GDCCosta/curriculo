# Changelog

Todas as mudanças relevantes deste projeto são registradas aqui.

O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/).

## [Não lançado]

### Adicionado
- SEO e prévia de link na página inicial (`site/index.html`): `meta description`,
  `author`, tags Open Graph (`og:title`, `og:description`, `og:locale`) e
  Twitter Card, melhorando o compartilhamento em LinkedIn, WhatsApp e similares.
- `description` passada ao Pandoc via `--metadata` em `build.ps1` e `build.sh`,
  populando a meta descrição dos HTMLs gerados.
- `print-color-adjust: exact` na página inicial, para que os fundos sejam
  impressos corretamente (mesmo comportamento dos currículos).
- `aria-label` distinto em cada botão da home ("Ver online" / "Baixar PDF"),
  melhorando a leitura por tecnologias assistivas.

### Alterado
- O GitHub Actions (`build.yml`) passou a reutilizar o `build.sh` em vez de
  duplicar o loop do Pandoc — uma só fonte de verdade para a geração.
- `preview.py` agora abre a página inicial (`build/index.html`) no navegador ao
  final, em vez da versão de engenharia.

### Corrigido
- Nome duplicado no cabeçalho dos currículos: o Pandoc renderizava o `title`
  como um `<h1>` no corpo, repetindo o nome que já vem do `cabecalho.md`. Trocado
  por `pagetitle` (só o `<title>` da aba) em `build.ps1` e `build.sh`.
- Versão do WeasyPrint fixada e atualizada para a estável mais recente
  (`weasyprint==70.0`) no CI, `build.ps1`, `build.sh` e `README.md`, tornando a
  renderização do PDF reproduzível e alinhando o build local ao publicado.
- CI passou a fixar o Python (`actions/setup-python@v5`, 3.12), exigência do
  WeasyPrint 70.0 (Python >= 3.10) e garantia de reprodutibilidade.
- Docstring de `gerar()` em `preview.py` corrigida: o resumo dizia "abre a de
  engenharia", agora reflete que abre a página inicial.

### Removido
- `hyphens: manual` de `h1 + p` e `h3 + p` no `estilo.css`, onde não tinha
  efeito (exige `&shy;` no texto).
- Lista `gerados` sem uso em `preview.py` (código morto).
