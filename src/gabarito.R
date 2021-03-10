library(tabulizer)
library(tidyverse)

leGabarito <- function(path, ano) {
  
  leGabarito2019 <- function(path) {
    
    out <- extract_tables(path)
    final <- do.call(rbind, out) %>% as_tibble() %>% select(-V2, -V4) %>% filter(V1 != "")
    
    names <- final[1, ]
    final %>%
      set_names(., nm = names) %>%
      .[-1, ]
    
  }
  
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
             ))
    
  }
  
  leGabarito2017 <- function(path) {
    
    out <- extract_tables(path)
    p1 <- out[[1]] %>% as_tibble()
    p1 <- p1 %>% select(-V4) %>% rename(Questão = V1, Respostas = V2, Componente = V3) %>% tail(-4)
    p2 <- out[[2]] %>% as_tibble() %>% rename(Questão = V1, Respostas = V2, Componente = V3)
    bind_rows(p1, p2)
    
  }
  
  if (ano == 2018) leGabarito2018(path)
  else if (ano %in% c(2016, 2019)) leGabarito2019(path)
  else if (ano == 2017) leGabarito2017(path)
  
}