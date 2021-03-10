# Extrai as imagens contidas na prova em PDF
# Salva elas dentro da pasta de saida, em uma subpasta images
# O formato usado é png
# Parâmetros:
#   path - caminho absoluto para a prova
#   outdir - diretório de saída
extrairImagens <- function(path, outdir) {
  
  if (!dir.exists(file.path(outdir, 'images')))
    dir.create(file.path(outdir, 'images'))
  
  cmd <- paste("pdfimages -png -p -f 2", path, file.path(outdir, 'images', 'img'))
  system(cmd)
  
}