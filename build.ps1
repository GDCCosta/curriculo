# Build local do currículo (Windows / PowerShell)
# Gera HTML e PDF das versões Engenharia e TI a partir do conteúdo em /conteudo.
#
# Pré-requisitos:
#   - Pandoc:     https://pandoc.org/installing.html
#   - WeasyPrint (para gerar PDF): pip install "weasyprint==70.0"
#     (mesma versão fixada no CI, para o PDF local sair igual ao publicado)
#
# Uso:
#   .\build.ps1            # gera HTML e PDF
#   .\build.ps1 -SomenteHtml   # gera apenas HTML (não exige WeasyPrint)

param(
    [switch]$SomenteHtml
)

$ErrorActionPreference = "Stop"
$raiz = $PSScriptRoot
$saida = Join-Path $raiz "build"
New-Item -ItemType Directory -Force -Path $saida | Out-Null

$cabecalho = Join-Path $raiz "conteudo\cabecalho.md"
$corpo     = Join-Path $raiz "conteudo\corpo.md"
$css       = Join-Path $raiz "estilo.css"

$versoes = @(
    @{ Nome = "engenharia"; Objetivo = "conteudo\objetivo-eng.md"; Titulo = "Gustavo de Camargo Costa - Engenharia" },
    @{ Nome = "ti";         Objetivo = "conteudo\objetivo-ti.md";  Titulo = "Gustavo de Camargo Costa - Tecnologia" }
)

foreach ($v in $versoes) {
    $objetivo = Join-Path $raiz $v.Objetivo
    $html = Join-Path $saida ("curriculo-" + $v.Nome + ".html")
    $pdf  = Join-Path $saida ("curriculo-" + $v.Nome + ".pdf")

    $descricao = "Currículo profissional de Gustavo de Camargo Costa"

    Write-Host "Gerando HTML: $html"
    pandoc $cabecalho $objetivo $corpo `
        --standalone --embed-resources `
        --css $css `
        --metadata title="$($v.Titulo)" `
        --metadata description="$descricao" `
        --metadata lang=pt-BR `
        -o $html

    if (-not $SomenteHtml) {
        Write-Host "Gerando PDF: $pdf"
        pandoc $cabecalho $objetivo $corpo `
            --pdf-engine=weasyprint `
            --css $css `
            --metadata title="$($v.Titulo)" `
            --metadata description="$descricao" `
            --metadata lang=pt-BR `
            -o $pdf
    }
}

# Página inicial do site (links para as duas versões)
Copy-Item (Join-Path $raiz "site\index.html") (Join-Path $saida "index.html") -Force
Copy-Item $css (Join-Path $saida "estilo.css") -Force

Write-Host "`nConcluido. Arquivos em: $saida"
