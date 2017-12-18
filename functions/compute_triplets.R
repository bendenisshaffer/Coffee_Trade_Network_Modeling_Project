#This function computes all of the triplets invloving a node "country" for a network "graph"
#With the option to specify the direction of the edge: "in", "out", "all".

compute_triplets = function(country, graph, edge1 = "in", edge2 = "in"){
        

        setAin = names(unlist(ego(graph, order = 1, nodes = country, mode = edge1)))[-1]
        if(length(setAin) > 0){
                setBin = mclapply(setAin, function(nd) names(unlist(ego(graph, order = 1, nodes = nd, mode = edge2)))[-1])
                
                ix = unlist(lapply(setBin, length)) > 0
                setBin = setBin[ix]
                setAin = setAin[ix]
                
                setBin = mclapply(setBin, function(x) remove_self_node(x, country))
                setBinSize = mclapply(setBin, length)
                
                col1 = rep(country, length(unlist(setBin)))
                col2 = unlist(map2(setAin, setBinSize, ~ rep(.x, each = .y)))
                col3 = unlist(setBin)
                edge_type = str_c(edge1, edge2)
                
                if(length(col1) > length(edge_type)){
                        triplets = data.frame(X = col1, Y = col2, Z = col3, edge_type)
                        return(triplets)
                }
                
        }
        
}




