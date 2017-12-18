library(igraph)
library(dplyr)
library(parallel)
library(purrr)
library(stringr)

source("Analysis/remove_self_node.R")
source("Analysis/compute_triplets.R")
source("Analysis/compute_all_triplets.R")
source("Analysis/categorize_all_triplets.R")
source("Analysis/categorize_triplet1.R")

coffeeG05 = read_graph("Data/iGraphs/coffeeG05.gml", format = "gml")
coffeeG10 = read_graph("Data/iGraphs/coffeeG10.gml", format = "gml")
gasG05 = read_graph("Data/iGraphs/gasG05.gml", format = "gml")



all_triplets = compute_all_triplets(coffeeG10, "Ethiopia:ETH")
plot(table(all_triplets$category)/sum(table(all_triplets$category)))

all_triplets_test = compute_all_triplets(gasG05, "USA:USA")

ids = unique(unlist(all_triplets %>% filter(category == "ABC") %>% select(X,Y,Z)))
subG = induced_subgraph(coffeeG05, vids = ids)
lay = layout.circle(subG)
par(mfrow = c(1,1))
plot(subG, layout = lay)




r = 14
plot(induced_subgraph(coffeeG05, vids = as.character(unlist(all_triplets[r,1:3]))), main = all_triplets[r,5])
