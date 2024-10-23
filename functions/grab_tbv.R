grab_tbv <- function(tree) {
  
  output <- as.data.frame(tree$Get("volumes")) %>% 
  mutate(TBV = `Basic cell groups and regions`) %>% 
  select(TBV)
  
  return(output)
  
}