#!/usr/bin/env python3
"""
Gera um preview em HTML das duas versões do currículo, sem depender do Pandoc.

Serve para visualizar rapidamente o layout no navegador. A geração "oficial"
(HTML + PDF) continua sendo feita pelo Pandoc (build.ps1 / build.sh) e pelo
GitHub Actions. Este script usa apenas a biblioteca 'markdown' (pip install markdown).

Uso:
    python preview.py
"""

import shutil
import webbrowser
from pathlib import Path

import markdown

RAIZ = Path(__file__).resolve().parent
CONTEUDO = RAIZ / "conteudo"
SAIDA = RAIZ / "build"
CSS = (RAIZ / "estilo.css").read_text(encoding="utf-8")

VERSOES = [
    ("engenharia", "objetivo-eng.md", "Engenharia"),
    ("ti", "objetivo-ti.md", "Tecnologia"),
]

MODELO = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Gustavo de Camargo Costa - {titulo}</title>
<style>
{css}
</style>
</head>
<body>
{corpo}
</body>
</html>
"""


def gerar():
    """Gera os HTML de preview das duas versões e abre a página inicial.

    Para cada versão (engenharia e TI) concatena cabeçalho + objetivo + corpo,
    converte o Markdown para HTML aplicando o mesmo `estilo.css` do build oficial
    e grava o resultado em `build/curriculo-<versao>.html`. Também copia a página
    inicial (`site/index.html`) para `build/index.html` e a abre no navegador
    padrão.
    """
    SAIDA.mkdir(exist_ok=True)
    md = markdown.Markdown(extensions=["extra", "sane_lists"])

    cabecalho = (CONTEUDO / "cabecalho.md").read_text(encoding="utf-8")
    corpo_comum = (CONTEUDO / "corpo.md").read_text(encoding="utf-8")

    for nome, arq_obj, titulo in VERSOES:
        objetivo = (CONTEUDO / arq_obj).read_text(encoding="utf-8")
        fonte = f"{cabecalho}\n\n{objetivo}\n\n{corpo_comum}"
        md.reset()
        html_corpo = md.convert(fonte)
        pagina = MODELO.format(titulo=titulo, css=CSS, corpo=html_corpo)
        destino = SAIDA / f"curriculo-{nome}.html"
        destino.write_text(pagina, encoding="utf-8")
        print(f"Gerado: {destino}")

    # Página inicial com os links
    home = SAIDA / "index.html"
    shutil.copy(RAIZ / "site" / "index.html", home)
    print(f"Gerado: {home}")

    # Abre a página inicial (com os links para as duas versões) no navegador
    webbrowser.open(home.as_uri())


if __name__ == "__main__":
    gerar()
