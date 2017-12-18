compute_all_triplets = function(graph, country){
        
        res1 = rbind(compute_triplets(country, graph, edge1 = "in", edge2 = "in"),
                     compute_triplets(country, graph, edge1 = "in", edge2 = "out"),
                     compute_triplets(country, graph, edge1 = "out", edge2 = "in"),
                     compute_triplets(country, graph, edge1 = "out", edge2 = "out"))
        
        setA = names(unlist(ego(graph, order = 1, nodes = country, mode = "all")))[-1]
        
        trans_triplets1 = mclapply(setA, function(nb) compute_triplets(nb, graph, edge1 = "in", edge2 = "out"))
        trans_triplets2 = mclapply(setA, function(nb) compute_triplets(nb, graph, edge1 = "in", edge2 = "in"))
        trans_triplets3 = mclapply(setA, function(nb) compute_triplets(nb, graph, edge1 = "out", edge2 = "out"))
        trans_triplets4 = mclapply(setA, function(nb) compute_triplets(nb, graph, edge1 = "out", edge2 = "in"))
        
        all_triplets21 = trans_triplets1[[1]]
        for(i in 2:length(trans_triplets1)){
                all_triplets21 = rbind(all_triplets21, trans_triplets1[[i]])
        }
        
        all_triplets22 = trans_triplets2[[1]]
        for(i in 2:length(trans_triplets2)){
                all_triplets22 = rbind(all_triplets22, trans_triplets2[[i]])
        }
        
        all_triplets23 = trans_triplets3[[1]]
        for(i in 2:length(trans_triplets3)){
                all_triplets23 = rbind(all_triplets23, trans_triplets3[[i]])
        }
        
        
        all_triplets24 = trans_triplets4[[1]]
        for(i in 2:length(trans_triplets4)){
                all_triplets24 = rbind(all_triplets24, trans_triplets4[[i]])
        }
        
        res2 = lapply(list(all_triplets21, all_triplets22,all_triplets23, all_triplets24), 
                      function(x) filter(x, Y == country))
        
        
        all_triplets = rbind(res1, res2[[1]], res2[[2]], res2[[3]], res2[[4]])
        all_triplets$category = categorize_all_triplets(all_triplets, country)
        
        return(all_triplets)
        
}