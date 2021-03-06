####Get Sugar Trade Data ####

library(tidyverse)
source("../../functions/get_Comtrade.R")

## download the data for each country into a list of separate data frames.
## discard empty data frames (API returned no results)
## combine all separate datasets into one
sugar_data = lapply(1:101, function(i) get_Comtrade(r = country_id[i], cc = "170111")) #101
dt = sugar_data[!is.na(sugar_data)]
DT = rbind(dt[[1]],dt[[2]])

for(i in 3:length(dt)){
        
        DT = rbind(DT,dt[[i]])
        
}

colnames(DT) = str_replace_all(names(DT),"\\.","_")

## write the combined dataset to a csv file:
## select columns of interest and filter rows where exporter or importer was 'world':
## write the clean dataset to a csv file:

write.csv(DT, file = "../../data/raw/sugar_trade.csv")
DTT = DT %>% select(Reporter,Partner,Trade_Value__US__,Netweight__kg_,
                    Reporter_ISO, Partner_ISO, Commodity, Year) %>% filter(Partner != "World", Reporter != "World",
                                                                           Partner != "EU-28", Reporter != "EU-28")


DTT$Reporter = str_c(DTT$Reporter,DTT$Reporter_ISO, sep = ":")
DTT$Partner = str_c(DTT$Partner,DTT$Partner_ISO, sep = ":")
write.csv(DTT, file = "../../data/clean/clean_sugar_trade.csv")

