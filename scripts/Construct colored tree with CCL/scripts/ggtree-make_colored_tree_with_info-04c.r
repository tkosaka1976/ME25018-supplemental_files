library(ggtree)
library(optparse)

optslist <- list(
    make_option("--nwk", type="character"),
    make_option("--info", type="character"),
    make_option("--clcolorccl", type="character"),
    make_option("--outpng", type="character")
    )
#    make_option(c("-f", "--flag2"),
#                action="store",
#                default=FALSE,
#                type="logical",
#                help="A Flag"),
#    make_option("--num",
#                type="integer",
#                default=1,
#                help="A Number"),
#    make_option("--raw-data",
#                type="character",
#                default="piyo",
#                help="a string")
#    )
parser <- OptionParser(option_list=optslist)
opts <- parse_args(parser)
#names(opts)
print(opts$outpng)

#setwd("/Volumes/USB_C&B/Hyd\ maturation\ factors\ classification/ggtree-cluster1")

tree <- read.tree(opts$nwk)
#tree

info_df <- read.csv(opts$info)
#names(info_df)

tc2color <- read.csv(opts$clcolorccl)
clades_df <- data.frame(
  clade=sort(tc2color$new_tc_id),
  node=NA
)
#clades_df
#tc2color

for (i in 1:length(clades_df$clade)) {
  print(i)
  print(info_df$SequenceName[info_df$new_tc_id == clades_df$clade[i]])
  clades_df$node[i] <- MRCA(
    tree,
    info_df$SequenceName[info_df$new_tc_id == clades_df$clade[i]]
    )
}

branches <- list()
for(i in clades_df$clade){
  branches[[i]] <- info_df$SequenceName[info_df$new_tc_id == i]
}
#branches

tree <- groupOTU(tree, branches)

g <- ggtree(
  tree,
  layout="equal_angle",
  aes(color = group), show.legend = FALSE
  ) +

scale_color_manual(
  values = c("black", tc2color$color)
) +

geom_cladelab(
  data=clades_df,
  mapping=aes(node=node, label=clade),
  fontsize=2,
  offset=0
) +

geom_treescale()

#g

ggsave(opts$outpng, dpi = 300)