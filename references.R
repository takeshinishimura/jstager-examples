library(jstager)

d <- jstage_references("10.1241/johokanri.49.63", depth = 3)

outdir <- "./data"
dir.create(outdir, showWarnings = FALSE)

write.csv(d, file = file.path(outdir, "data.csv"), row.names = FALSE)
