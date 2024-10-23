read_background <- function(data) { 
    read_csv(data) %>% 
    filter(Is_Wildtype == "WT") %>% 
    select(Study_Name, Background) %>% 
    distinct(Study_Name, .keep_all = TRUE) %>%
    mutate(Background = ifelse(Background == "C57BL6-J",
                               "C57BL-6J",
                               ifelse(Background == "C57BL6-N",
                                      "C57BL-6N", Background)))}