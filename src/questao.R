library(tidyverse)
library(jsonlite)
library(stringi)

splitQuestao <- function(questao, gabarito, outdir) {
  
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
  
  resposta <- gabarito %>% filter(as.integer(Questão) == as.integer(num)) %>% pull(Respostas)
  
  componente <- gabarito %>% filter(as.integer(Questão) == as.integer(num)) %>% pull(Componente)
  
  write(toJSON(list("N" = num,
                    "Enun" = enun,
                    "A" = letra_a, "B" = letra_b, "C" = letra_c, "D" = letra_d, "E" = letra_e,
                    "Resposta" = resposta,
                    "Componente" = componente),
               encoding = "UTF-8", auto_unbox = TRUE, pretty = TRUE),
        file.path(outdir, paste(num, '.json', sep = '')))
  
}