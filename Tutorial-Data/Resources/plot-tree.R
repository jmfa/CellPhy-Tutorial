#!/usr/bin/env Rscript
# CellPhy - Bootstrap support plot
# Created by: Alexey Kozlov, Joao M Alves, Alexandros Stamatakis & David Posada - 22.07.2020
# mailto: jalves@uvigo.es

# Load required libraries

if (!suppressMessages(require('ggtree', quietly = T))) { 
  message("ERROR: package not found: ggtree\nPlease run install.sh to fix.")
  quit()
}

usage <- function() 
{ 
  message ("CellPhy - Best tree plot - 15.06.2023")
  message ("Created by: Joao M Alves\n")
  message ("Usage: ./plot-tree.R BestTree Outgroup [OutputPrefix]\n")
}

#Read arguments:
args = commandArgs(trailingOnly=TRUE)
if (length(args) >= 2) {
  treef = args[1]
  outgr = args[2]
  if (length(args) >= 3) {
    prefix <- args[3]
  } else {
    prefix <- treef
  }
} else {
  usage()
  quit()
}

#Load Tree
tree <- read.tree(treef)

#Root tree with outgroup
if (outgr != "NONE" && ape::is.rooted(tree) == F) {
  outgr_taxa = strsplit(outgr, ",")[[1]]
  tree = ape::root(tree, outgroup=outgr_taxa, edgelabel=T, resolve.root=T)
}

message("Generating tree plot...")

#Plot and save
out_pdf = paste(prefix, ".pdf", sep="")
out_svg = paste(prefix, ".svg", sep="")

p = ggtree(tree) + geom_tiplab(size=1.8) 


pdf(out_pdf)

p

svg(out_svg)

p

dummy = dev.off()

message("Done!")
