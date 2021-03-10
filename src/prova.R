# Quebra uma página da prova em questões
# Considera que as questões iniciam com QUESTÃO nn -
# Onde nn é um número, o número da questão
# Parâmetros:
#   page - página da prova como string
splitProva <- function(page) { lapply(strsplit(page, 'QUESTÃO '), grep, pattern = '^[0-9]+ – ', value = TRUE) }