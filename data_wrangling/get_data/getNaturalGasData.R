####Get Natural Gas Trade Data ####

library(tidyverse)
source("../../functions/get_Comtrade.R")
## download the data for each country into a list of separate data frames.
## discard empty data frames (API returned no results)
## combine all separate datasets into one


coffee_data = lapply(173:254, function(i) get_Comtrade(r = country_id[i]))
dt = coffee_data[!is.na(coffee_data)]
DT = rbind(dt[[1]],dt[[2]])

for(i in 3:length(dt)){
        DT = rbind(DT,dt[[i]])
        
}

colnames(DT) = str_replace_all(names(DT),"\\.","_")

chunk1 = DT

chunk2 = DT

chunk12 = rbind(chunk1,chunk2)

chunk3 = DT

chunk12 = rbind(chunk1,chunk2)
chunk123 = rbind(chunk12,chunk3)

## write the combined dataset to a csv file:
## select columns of interest and filter rows where exporter or importer was 'world':
## write the clean dataset to a csv file:

DT = chunk123

write.csv(DT, file = "/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/Project/Data/coffee_trade.csv")
DTT = DT %>% select(Reporter,Partner,Trade_Value__US__,Netweight__kg_,
                    Reporter_ISO, Partner_ISO, Commodity, Year) %>% filter(Partner != "World", Reporter != "World")
write.csv(DTT, file = "/Users/bendenisshaffer/Box Sync/UM Fall 2017/SI 608/Project/Data/clean_coffee_trade.csv")













