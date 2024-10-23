grab_leaves <- function(tree, demo_data, tbv, names, strains) {
  
  # first, grab just the "leaves" regions of the data 
  leaves_pre <- as.data.frame(tree$
                                `Basic cell groups and regions`$
                                Get("volumes", filterFun = isLeaf))
  
  # then, append the demographic data to the leaves regions 
  # select for only the first scan of any mouse that have repeated scans 
  output <- demo_data %>% select(Mouse_ID, Is_Wildtype, POND_Mouse_ID, 
                          Study_Name,Mouse_Sex, Mouse_Age, Timepoint) %>%
    bind_cols(tbv, leaves_pre) %>% distinct(Mouse_ID, .keep_all = TRUE) %>%
    mutate(Mouse_Age = str_remove(Mouse_Age,"P")) %>%
    separate(Mouse_Age, c("a", "b"), fill = "right") %>%
    mutate(a = as.numeric(a), b = as.numeric(b)) %>%
    mutate(Mouse_Age = ifelse(is.na(b) == FALSE, 
                              (a + b)/2, a), .after = Mouse_Sex) %>%
    select(-c(a,b)) %>%
    
    # and then filter for only wild type animals 
    # using the corhort_names, keep the cohorts that have no sex imbalance in the original data 
    
    filter(Is_Wildtype == "WT") %>% filter(Study_Name %in% names) %>%
    # and join with study name
    left_join(strains, by = "Study_Name") 
  
  return(output)
  
}