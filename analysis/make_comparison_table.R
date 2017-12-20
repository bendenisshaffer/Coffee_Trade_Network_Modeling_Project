require(igraph)
require(network)

load("saved_output/objects/net.RData")
load("saved_output/objects/ergm_models.RData")

coffeeG10sub = read_graph("data/igraphs/coffeeG10sub.gml", format = "gml")


resG = lapply(ergm_models[c(5,7)], function(x) graph_from_edgelist(as.edgelist(x$newnetwork)))

y = as.matrix(net)
dim(y) = c(ncol(y)^2,1)

ERgraph = sample_gnp(sqrt(length(y)), exp(ergm_models[[1]]$coef))
resG = list(coffeeG10sub, resG[[1]], resG[[2]], ERgraph)

resGsize = lapply(resG, ecount)
resGorder = lapply(resG, vcount)
resGtransitivity = lapply(resG, transitivity)
resGaverage_path_length = lapply(resG, average.path.length)
resGedge_density = lapply(resG, edge_density)

comparison_table =  data.frame(Size = unlist(resGsize), 
                               Order = unlist(resGorder), 
                               Transitivity = unlist(resGtransitivity),
                               Average_Path_Length = unlist(resGaverage_path_length), 
                               Edge_Density = unlist(resGedge_density),
                               Model = c("Original Network","Fith Model","GWESP Model","ER Model"))

save(comparison_table, file = "saved_output/objects/comparison_table.RData")
