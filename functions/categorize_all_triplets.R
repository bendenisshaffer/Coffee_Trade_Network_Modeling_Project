categorize_all_triplets = function(all_triplets, country){
        
        
        all_triplets$X = as.character(all_triplets$X)
        all_triplets$Y = as.character(all_triplets$Y)
        all_triplets$Z = as.character(all_triplets$Z)
        
        
        
        combinations1 = list(vector(length = nrow(all_triplets)))
        for(i in 1:nrow(all_triplets)){
                
                section =  all_triplets[all_triplets$X == country & 
                                                all_triplets$Y == all_triplets[i,"Y"] & 
                                                all_triplets$Z == all_triplets[i,"Z"],]
                combinations1[[i]] = str_c(as.character(as.integer(section$edge_type)), collapse = "")
        }
        
        
        combinations2 = list(vector(length = nrow(all_triplets)))
        for(i in 1:nrow(all_triplets)){
                
                section =  all_triplets[all_triplets$X == country & 
                                                all_triplets$Z == all_triplets[i,"Y"] & 
                                                all_triplets$Y == all_triplets[i,"Z"],]
                combinations2[[i]] = str_c(as.character(as.integer(section$edge_type)), collapse = "")
        }
        
        combinations3 = map2(combinations1, combinations2, ~ str_c(.x,.y, sep = ":"))
        
        
        combinations4 = list(vector(length = nrow(all_triplets)))
        for(i in 1:nrow(all_triplets)){
                section = all_triplets[all_triplets$X == all_triplets[i,"X"] & 
                                               all_triplets$Y == country & 
                                               all_triplets$Z == all_triplets[i,"Z"],]
                combinations4[[i]] = str_c(as.character(as.integer(section$edge_type)), collapse = "")
        }
        
        combinations5 = list(vector(length = nrow(all_triplets)))
        for(i in 1:nrow(all_triplets)){
                section = all_triplets[all_triplets$X == country & 
                                               all_triplets$Y == all_triplets[i,"Z"] & 
                                               all_triplets$Z == all_triplets[i,"X"],]
                combinations5[[i]] = str_c(as.character(as.integer(section$edge_type)), collapse = "")
        }
        
        combinations6 = map2(combinations4, combinations5, ~ str_c(.x,.y, sep = ":"))
        
        all_combinations = list(unlist(combinations3),unlist(combinations6))
        all_categories  = unlist(mclapply(unlist(all_combinations), categorize_triplet1))
}