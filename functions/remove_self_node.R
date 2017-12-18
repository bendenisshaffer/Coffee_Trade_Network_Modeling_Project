remove_self_node = function(set, node){
        
        if(as.logical(sum(str_detect(set, node)))){
                set = set[-str_which(unlist(set), node)]
                return(set)
        }else{
                return(set)
        }
        
}
