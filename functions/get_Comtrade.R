get_Comtrade  = function(url = "http://comtrade.un.org/api/get?", maxrec = 500, type = "C", freq = "A", px = "HS"
                         ,ps = "2015%2C2010%2C2005",r ,p = "all" ,rg = "2", cc = "090111%2C090112", fmt = "csv"){
        require(jsonlite)
        require(stringr)
        
        str = str_c(url, "max=", maxrec, "&" #maximum no. of records returned
                    ,"type=",type,"&" #type of trade (c=commodities)
                    ,"freq=",freq,"&" #frequency
                    ,"px=",px,"&" #classification
                    ,"ps=",ps,"&" #time period
                    ,"r=",r,"&" #reporting area
                    ,"p=",p,"&" #partner country
                    ,"rg=",rg,"&" #trade flow
                    ,"cc=",cc,"&" #classification code
                    ,"fmt=",fmt        #Format
                    ,sep = ""
        )
        
        dt = read.csv(str,header = TRUE)                     # API allowes csv file download
        if(str_detect(dt[,1],"Request JSON or XML format")){ # this case/error occures when API doesn't return data
                return(NA)
        }else{
                return(dt)
        }
}

library(jsonlite)
all_countries = fromJSON(url("https://comtrade.un.org/data/cache/reporterAreas.json"))
country_id = all_countries$results[,1][-1]