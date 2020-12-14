# Script para converter as questões do PDF para JSON

library(pdftools)
library(jsonlite)
library(stringi)

args <- commandArgs(trailingOnly=TRUE)
prova_path <- args[1]
outdir <- args[2]

if (!dir.exists(outdir))
  dir.create(outdir)

splitProva <- function(page) { lapply(strsplit(page, 'QUESTÃO '), grep, pattern = '^[0-9]+ – ', value = TRUE) }

splitQuestao <- function(questao) {
  
  partes <- unlist(strsplit(questao, '\n[A-Z]) '))
  
  num_enun <- unlist(strsplit(partes[1], ' – '))
  num <- num_enun[1]
  enun <- num_enun[2]
  
  letra_a <- partes[2]
  letra_b <- partes[3]
  letra_c <- partes[4]
  letra_d <- partes[5]
  letra_e <- gsub('\nExecução: Fundatec.*', '', partes[6])
  letra_e <- stri_replace_last_fixed(letra_e, '\n', '')
  
  write(toJSON(list("N" = num, "Enun" = enun, "A" = letra_a, "B" = letra_b, "C" = letra_c, "D" = letra_d, "E" = letra_e),
               encoding = "UTF-8", auto_unbox = TRUE, pretty = TRUE),
        file.path(outdir, paste(num, '.json', sep = '')))
  
}

prova <- pdf_text(prova_path)
prova <- unlist(lapply(prova, splitProva))
prova <- lapply(prova, splitQuestao)
