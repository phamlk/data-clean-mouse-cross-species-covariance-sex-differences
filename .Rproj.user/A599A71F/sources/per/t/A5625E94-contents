grab_cohorts <- function(data) {
  
  cohorts <- data %>% 
    # take those with an age range and calculate their average age (lower + upper/2)
    # keep only mice that are not super old (more than 200 days) 
    mutate(Mouse_Age = str_remove(Mouse_Age,"P")) %>%
    separate(Mouse_Age, c("a", "b"), fill = "right") %>%
    mutate(a = as.numeric(a), b = as.numeric(b)) %>%
    mutate(Mouse_Age = ifelse(is.na(b) == FALSE, (a + b)/2, a), 
           .after = Mouse_Sex) %>%
    select(-c(a,b)) %>% filter(Mouse_Age < 200 | is.na(Mouse_Age) == TRUE) %>% 
    # keep only the first scans of all mice using the distinct ID function
    # keep only WT mice 
    distinct(Mouse_ID, .keep_all = TRUE) %>% filter(Is_Wildtype == "WT") %>% 
    # filter to keep only control animals that have not been treated, or have mock/vehicle trtmnt
    filter(Treatment_Code %in% c(NA,
                                 "Control", "Saline","MOCK", "VEH")) %>%
    # now group the data by study name and filter out those with imbalanced sex 
    group_by(Study_Name, Mouse_Sex) %>% 
    summarise(count = n()) %>% ungroup() %>% filter(count > 4) %>%
    group_by(Study_Name) %>% filter(n() == 2)
  
    output <- unique(cohorts$Study_Name)
    
    return(output)
}