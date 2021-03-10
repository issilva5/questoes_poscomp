library(tabulizer)
library(tidyverse)

# Lê o gabarito das questões e retorna um tibble com as colunas Questão, Resposta, Componente e Subarea
# Para os anos diferentes de 2019, Subarea é igual a Componente
# Parâmetros:
#   path - caminho absoluto para o gabarito
#   ano - ano de aplicação da prova
leGabarito <- function(path, ano) {
  
  # Lê o formato de gabarito dos anos 2016 e 2019
  leGabarito2019 <- function(path) {
    
    out <- extract_tables(path)
    final <- do.call(rbind, out) %>% as_tibble() %>% select(-V2, -V4) %>% filter(V1 != "")
    
    names <- final[1, ]
    final %>%
      set_names(., nm = names) %>%
      .[-1, ] %>% mutate(Subarea = Componente,
                         Componente = case_when(
                           Questão <= 20 ~ 'Matemática',
                           Questão <= 50 ~ 'Fundamentos de Computação',
                           TRUE ~ 'Tecnologia da Computação'
                         ))
    
  }
  
  # Lê o formato de gabarito do ano de 2018
  leGabarito2018 <- function(path) {
    
    out <- extract_tables(path)
    final <- do.call(cbind, out) %>% t() %>% as_tibble()
    final %>%
      rename(Questão = V1, Respostas = V2) %>%
      mutate(Questão = as.integer(Questão),
             Componente = case_when(
               Questão <= 20 ~ 'Matemática',
               Questão <= 50 ~ 'Fundamentos de Computação',
               TRUE ~ 'Tecnologia da Computação'
             ),
             Subarea = Componente)
    
  }
  
  # Lê o formato de gabarito do ano de 2017
  leGabarito2017 <- function(path) {
    
    out <- extract_tables(path)
    p1 <- out[[1]] %>% as_tibble()
    p1 <- p1 %>% select(-V4) %>% rename(Questão = V1, Respostas = V2, Componente = V3) %>% tail(-4)
    p2 <- out[[2]] %>% as_tibble() %>% rename(Questão = V1, Respostas = V2, Componente = V3)
    bind_rows(p1, p2) %>% mutate(Subarea = Componente)
    
  }
  
  # Decide qual função utilizar
  if (ano == 2018) leGabarito2018(path)
  else if (ano %in% c(2016, 2019)) leGabarito2019(path)
  else if (ano == 2017) leGabarito2017(path)
  
}