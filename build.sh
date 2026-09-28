#!/usr/bin/env bash
# Build local do currículo (macOS / Linux)
# Gera HTML e PDF das versões Engenharia e TI a partir do conteúdo em /conteudo.
#
# Pré-requisitos:
#   macOS:  brew install pandoc
#           pip3 install "weasyprint==70.0"
#   Linux:  sudo apt-get install pandoc && pip3 install "weasyprint==70.0"
#   (mesma versão fixada no CI, para o PDF local sair igual ao publicado)
#
# Uso:
#   ./build.sh             # gera HTML e PDF
#   ./build.sh --so-html   # gera apenas HTML (não exige WeasyPrint)

set -euo pipefail

raiz="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
saida="$raiz/build"
mkdir -p "$saida"

cabecalho="$raiz/conteudo/cabecalho.md"
corpo="$raiz/conteudo/corpo.md"
css="$raiz/estilo.css"

so_html="nao"
if [[ "${1:-}" == "--so-html" ]]; then
  so_html="sim"
fi

# nome:arquivo-objetivo:titulo
versoes=(
  "engenharia:objetivo-eng:Engenharia"
  "ti:objetivo-ti:Tecnologia"
)

for ver in "${versoes[@]}"; do
  nome="${ver%%:*}"
  resto="${ver#*:}"
  obj="${resto%%:*}"
  titulo="${resto#*:}"

  html="$saida/curriculo-${nome}.html"
  pdf="$saida/curriculo-${nome}.pdf"
  objetivo="$raiz/conteudo/${obj}.md"

  descricao="Currículo profissional de Gustavo de Camargo Costa"

  echo "Gerando HTML: $html"
  pandoc "$cabecalho" "$objetivo" "$corpo" \
    --standalone --embed-resources \
    --css "$css" \
    --metadata title="Gustavo de Camargo Costa - ${titulo}" \
    --metadata description="$descricao" \
    --metadata lang=pt-BR \
    -o "$html"

  if [[ "$so_html" == "nao" ]]; then
    echo "Gerando PDF: $pdf"
    pandoc "$cabecalho" "$objetivo" "$corpo" \
      --pdf-engine=weasyprint \
      --css "$css" \
      --metadata title="Gustavo de Camargo Costa - ${titulo}" \
      --metadata description="$descricao" \
      --metadata lang=pt-BR \
      -o "$pdf"
  fi
done

# Página inicial do site
cp "$raiz/site/index.html" "$saida/index.html"
cp "$css" "$saida/estilo.css"

echo ""
echo "Concluido. Arquivos em: $saida"
