
categorize_triplet1 = function(code){
        
        code = as.character(code)
        
        if(code %in% list("3")){
                return("ABD")
        }else if(code %in% list("4","1")){
                return("AAD")
        }else if(code %in% list("34:34","3:24","13:4","4:13","1:12","21:13","4:34","24:4","13:1","43:24")){
                return("AAC")
        }else if(code %in% list("34","13","24","3:4","4:3")){
                return("ACD")
        }else if(code %in% list("2")){
                return("BAD")
        }else if(code %in% list("1234:34","34:1234","1234:12","1234:1234","12:1234","2143:1234")){
                return("CCC")
        }else if(code %in% list("2:3","3:2","1234","2143")){
                return("CCD")
        }else if(code %in% list("24:3","1:4","2:34","21:24","24:3","3:12","1:24","24:1")){
                return("ABC")
        }else if(code %in% list("12","21","24","43")){
                return("CAD")
        }else if(code %in% list("12:34","34:12","12:12","24:13","13:24","13:12","21:1234","2143:13","2143:24","24:34","43:1234")){
                return("ACC")
        }else if(code %in% list("13:2","4:1","2:13","3:1","3:2","43:13")){
                return("ACB")
        }else if(code %in% list("1:2","2:1","2:4")){
                return("AAB")
        }else if(code %in% list("1:1","4:4","4:3")){
                return("AAA")
        }else{
                return(code)
        }
        
}