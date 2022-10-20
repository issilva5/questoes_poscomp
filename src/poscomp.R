# Script para converter as questões do PDF para JSON

library(pdftools)
library(here)

# Lê as funções de conversão a serem utilizadas
source(here('src/gabarito.R'))
source(here('src/questao.R'))
source(here('src/prova.R'))
source(here('src/imagens.R'))

# Este script recebe 3 argumentos na entrada
args <- commandArgs(trailingOnly=TRUE)
prova_path <- args[1] # Caminho absoluto para a prova em PDF
gabarito_path <- args[2] # Caminho absoluto para o gabarito da respectiva prova
ano <- args[3] # Ano de aplicação da prova

# Este script ainda não oferece suporte para provas anteriores a de 2016
if (as.integer(ano) < 2016)
  stop(paste("O ano de", ano, "ainda não é suportado!"))

# Cria um diretório com o número do ano de aplicação
# Neste diretório serão salvas as questões extraídas
if (!dir.exists(ano))
  dir.create(ano)

prova <- pdf_text(prova_path) # Lê o PDF da prova
gabarito <- leGabarito(gabarito_path, ano) # Lê o gabarito da prova
prova <- unlist(lapply(prova, splitProva)) # Quebra a prova em questões
prova <- lapply(prova, splitQuestao, gabarito = gabarito, outdir = ano) # Itera nas questões, criando seus arquivos JSON
extrairImagens(prova_path, ano) # Extrai as imagens da prova e as salva numa pasta imagens dentro do diretório de saída
