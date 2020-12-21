extrairImagens <- function(path, outdir) {
  
  if (!dir.exists(file.path(outdir, 'images')))
    dir.create(file.path(outdir, 'images'))
  
  cmd <- paste("pdfimages -png -p -f 2", path, file.path(outdir, 'images', 'img'))
  system(cmd)
  
}