require(tmap)
require(plyr)
require(network)
require(igraph)
require(stringr)


#Import that data
data(World)
coffeeG05 = read_graph("data/igraphs/coffeeG05.gml", format = "gml")
coffeeG10 = read_graph("data/igraphs/coffeeG10.gml", format = "gml")

#Extract names of countries that are present in both the 2005 and 2010 networks
G10names = vertex.attributes(coffeeG10)$name
G05names = vertex.attributes(coffeeG05)$name
G10names = G10names[G10names %in% G05names]
iso_a3 = str_replace(str_extract(G10names,":[A-Z]*"),":","")
DT = data.frame(name = G10names, iso_a3)

#Join the World data and the data.frame of names by the ISO code
DT = join(DT, World@data, by = "iso_a3")

#Subset the network to cases that are present in both 2005 and 2010
coffeeG10sub = induced_subgraph(coffeeG10, vids = G10names)
coffeeG05sub = induced_subgraph(coffeeG05, vids = G10names)

#Add the data to the network data object
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Continent", value = DT$continent)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Subregion", value = DT$subregion)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Population", value = DT$pop_est)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "GDP", value = DT$gdp_cap_est)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Economy", value = DT$economy)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "IncomeLev", value = DT$income_grp)
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Area", value = DT$area)

#Adding centrality measures from previous year
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Betweenness", value = betweenness(coffeeG05sub))
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "Closeness", value = closeness(coffeeG05sub))
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "InDegree", value = degree(coffeeG05sub, mode = "in"))
coffeeG10sub = set_vertex_attr(coffeeG10sub, name = "OutDegree", value = degree(coffeeG05sub, mode = "out"))


#Subset the network further to cases that have complete data: There are 153 countries as a result
VDT = get.data.frame(coffeeG10sub, what = "vertices")
coffeeG10sub = induced_subgraph(coffeeG10sub, vids = VDT$name[complete.cases(VDT)])

#Converting the igraph to a network Object
A = get.adjacency(coffeeG10sub)
VDT = get.data.frame(coffeeG10sub, what = "vertices")
net = as.network(as.matrix(A), directed = TRUE)

network::set.vertex.attribute(net, "GDP", VDT$GDP)
network::set.vertex.attribute(net, "Subregion",VDT$Subregion)
network::set.vertex.attribute(net, "Population", VDT$Population)
network::set.vertex.attribute(net, "Economy", VDT$Economy)
network::set.vertex.attribute(net, "IncomeLev", VDT$IncomeLev)
network::set.vertex.attribute(net, "Continent", VDT$Continent)
network::set.vertex.attribute(net, "Betweenness", VDT$Betweenness)
network::set.vertex.attribute(net, "Closeness", VDT$Closeness)
network::set.vertex.attribute(net, "InDegree", VDT$InDegree)
network::set.vertex.attribute(net, "OutDegree", VDT$OutDegree)


write_graph(coffeeG10sub, "data/igraphs/coffeeG10sub.gml", format = "gml")
save(net, file = "saved_output/objects/net.RData")
