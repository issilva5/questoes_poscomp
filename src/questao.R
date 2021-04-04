library(tidyverse)
library(jsonlite)
library(stringi)

# Quebra o texto de uma questão em enunciado e alternativas
# Junta essas informações com o gabarito
# E salva um JSON para a questão
# Parâmetros
#   questao - texto da questão
#   gabarito - tibble com o gabarito da prova
#   outdir - diretório de saída / ano de aplicação da prova
splitQuestao <- function(questao, gabarito, outdir) {
  
  partes <- unlist(strsplit(questao, '\n *[A-Z]) '))
  
  num_enun <- unlist(strsplit(partes[1], ' – '))
  num <- num_enun[1]
  enun <- unlist(strsplit(num_enun[2], '\n'))
  
  letra_a <- partes[2]
  letra_b <- partes[3]
  letra_c <- partes[4]
  letra_d <- partes[5]
  letra_e <- gsub('\nExecução: Fundatec.*', '', partes[6])
  letra_e <- stri_replace_last_fixed(letra_e, '\n.*', '')
  
  alternativas <- c(letra_a, letra_b, letra_c, letra_d, letra_e)
  
  resposta <- gabarito %>% filter(as.integer(Questão) == as.integer(num)) %>% pull(Respostas)
  
  resposta <- case_when(
    resposta == "A" ~ 0,
    resposta == "B" ~ 1,
    resposta == "C" ~ 2,
    resposta == "D" ~ 3,
    resposta == "E" ~ 4,
    TRUE ~ -1
  )
  
  componente <- gabarito %>% filter(as.integer(Questão) == as.integer(num)) %>% pull(Componente)
  
  subarea <- gabarito %>% filter(as.integer(Questão) == as.integer(num)) %>% pull(Subarea)
  
  write(toJSON(list("Ano" = outdir,
                    "Número" = num,
                    "Enunciado" = enun,
                    "Alternativas" = alternativas,
                    "Imagens" = c(),
                    "Resposta" = resposta,
                    "Componente" = componente,
                    "Subarea" = subarea),
               encoding = "UTF-8", auto_unbox = TRUE, pretty = TRUE),
        file.path(outdir, paste(num, '.json', sep = '')))
  
}