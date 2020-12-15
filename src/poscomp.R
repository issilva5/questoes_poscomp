# Script para converter as questões do PDF para JSON

library(pdftools)
library(jsonlite)
library(stringi)
library(tabulizer)
library(tidyverse)

source('gabarito.R')
source('questao.R')
source('prova.R')

args <- commandArgs(trailingOnly=TRUE)
prova_path <- args[1]
gabarito_path <- args[2]
ano <- args[3]

if (!dir.exists(ano))
  dir.create(ano)

prova <- pdf_text(prova_path)
gabarito <- leGabarito(gabarito_path, ano)
prova <- unlist(lapply(prova, splitProva))
prova <- lapply(prova, splitQuestao, gabarito = gabarito, outdir = ano)
