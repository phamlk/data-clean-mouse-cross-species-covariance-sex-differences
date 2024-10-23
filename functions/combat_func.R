combat_func <- function(data_input, for_batching) { 
  
  # 8:263 are all volume information (TBV to regional volumes)
  mouse_vols_t <- t(as.matrix(data_input[,8:263]))
  # mouse_demo involve non-volume information
  mouse_demo <- data_input[,c(1:7)]
  # mouse_background is just the background column of the mouse data
  mouse_background <- data_input[,264]
  
  batch_col <- data_input[[for_batching]]
  
  combat_vols_t <- sva::ComBat(dat = mouse_vols_t, batch = batch_col)
  
  combat_vols <- t(combat_vols_t)
  
  combat_vols_fin <- mouse_demo %>%
    bind_cols(combat_vols, mouse_background) 
  
  return(combat_vols_fin)
}