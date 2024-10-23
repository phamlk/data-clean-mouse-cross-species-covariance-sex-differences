print_demographics <- function(final_data) { 
  
  demo_main <- final_data %>% group_by(Mouse_Sex) %>% 
    mutate(Mouse_Age = ifelse(is.na(Mouse_Age) == TRUE, 60, Mouse_Age))
  
  demo_1 <- final_data %>% group_by(Mouse_Sex) %>% 
            mutate(Mouse_Age = ifelse(is.na(Mouse_Age) == TRUE, 60, Mouse_Age))%>%
  reframe(count = n(), 
          mean_age = mean(Mouse_Age),
          sd_age = sd(Mouse_Age),
          min_age = min(Mouse_Age),
          max_age = max(Mouse_Age))
  
  stats_age <- summary(aov(Mouse_Age ~ Mouse_Sex, data = demo_main))
    
  study_code <- data.frame(Study_Name = unique(final_data$Study_Name), 
                                code = LETTERS[1:length(unique(final_data$Study_Name))])
  
  demo_2 <- final_data %>% group_by(Mouse_Sex, Background) %>%
    reframe(count = n()) 
  
  stats_background <- demo_2 %>% pivot_wider(id_cols = Mouse_Sex, names_from = Background, 
                                             values_from = count) %>%
                      column_to_rownames("Mouse_Sex") %>% chisq.test(.)
  
  demo_3 <- final_data %>% group_by(Mouse_Sex, Background, Study_Name) %>%
  reframe(count = n()) %>% left_join(study_code, by = "Study_Name")
  
  stats_j <- demo_3 %>% filter(Background == "C57BL-6J") %>%
             pivot_wider(id_cols = Mouse_Sex, names_from = Study_Name, 
                                              values_from = count) %>%
             column_to_rownames("Mouse_Sex") %>% chisq.test(.)
  
  stats_n <- demo_3 %>% filter(Background == "C57BL-6N") %>%
    pivot_wider(id_cols = Mouse_Sex, names_from = Study_Name, 
                values_from = count) %>%
    column_to_rownames("Mouse_Sex") %>% chisq.test(.)
  
  
  return(list(demo_1, demo_2, demo_3, stats_age, stats_background, stats_j, stats_n))
  
  }