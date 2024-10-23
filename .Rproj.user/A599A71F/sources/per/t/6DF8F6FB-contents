library(targets)

# setting target libraries
library(targets)
options(clustermq.scheduler = "multiprocess")

# loading custom functions for pipeline 
sapply(list.files(pattern="[.]R$", path="functions/", full.names=TRUE), source)

# setting packages required for pipeline
# configuring pipeline for more efficiency
options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "data.tree", "RMINC", "grid",
                            "ggplot2", "MRIcrotome", "broom", "sva",
                            "patchwork"))

list(
  #-----making the tree-----------
  load("data/Volumes_150.RData"),
  
  tar_target(defs, 
             "data/Dorr_2008_Steadman_2013_Ullmann_2013_Richards_2011_Qiu_2016_Egan_2015_40micron/mappings/DSURQE_40micron_R_mapping.csv"),
  
  tar_target(allen, "data/allen.json"),
  
  tar_target(hdefs_allen, makeMICeDefsHierachical(defs, allen)),
  
  tar_target(hdefs, addVolumesToHierarchy(hdefs_allen, vols)),
  
  tar_target(hdefsCopy, Clone(hdefs)),
  
  #----read demographics data------
  tar_target(gf, read_csv("data/NewScans4Jason.csv")),
  tar_target(background, read_background("data/background_strains.csv")),
  
  # background scanBase is another demographics data sheet that I 
  # received from Elisa at some point. Filtering for C57BL6 mice
  # using this sheet will result in less mice (~86 fewer animals) 
  # hence why truly only anything that is filtered using the background_strains.csv
  # sheet is used 
  tar_target(background_scanBase, read_background("scanbase_40um-Genotypes_Feb2023.csv")),

  #----make total brain volume------
  tar_target(tissues_total, grab_tbv(hdefsCopy)),
  
  #----grab cohorts to keep--------
  tar_target(cohort_names, grab_cohorts(gf)),
  
  tar_target(leaves, grab_leaves(tree = hdefsCopy, demo_data = gf, 
                                 tbv = tissues_total, names = cohort_names,
                                 strains = background)),
  
  tar_target(leaves_scanBase, grab_leaves(tree = hdefsCopy, demo_data = gf, 
                                      tbv = tissues_total, names = cohort_names,
                                      strains = background_scanBase)),
  
  #----filter leaves for just bl6 mice------
  tar_target(bl6, leaves %>% filter(Background %in% c("C57BL-6J", "C57BL-6N"))),
  tar_target(bl6_scanBase, leaves_scanBase %>% 
                           filter(Background %in% c("C57BL-6J", "C57BL-6N"))),
  
  #-----checking outliers-----------
  tar_target(all_subj_cooksd, too_many_cooks(9,263, bl6, "Mouse_ID", 
                              c("Is_Wildtype", "POND_Mouse_ID", "Study_Name", 
                                "Mouse_Sex","Mouse_Age", "Timepoint", "TBV", 
                                "Background"))),
  
  tar_target(subj_max_cooksd, all_maxCook(bl6, all_subj_cooksd, 
                                          "Mouse_ID")),
  
  tar_target(outlier_flags, flag_outliers(subj_max_cooksd)),
  tar_target(outliers, outlier_flags %>% filter(outlier == TRUE) %>% 
                       select(Subject)),
  
  
  #-----removing outliers----------
  tar_target(bl6_orm, bl6 %>% filter(!Mouse_ID %in% outliers$Subject)),
  tar_target(bl6j, bl6_orm %>% filter(Background == "C57BL-6J")),
  tar_target(bl6n,  bl6_orm %>% filter(Background == "C57BL-6N")),
  
  #-----apply combat to the data and produce final output--------
  
  # combat within strains 
  tar_target(bl6j_combat, combat_func(bl6j, "Study_Name")),
  tar_target(bl6n_combat, combat_func(bl6n, "Study_Name")),
  
  # combat between strains and then produce final output
  tar_target(study_combatted, bind_rows(bl6j_combat, bl6n_combat)),
  tar_target(leaves_final, combat_func(study_combatted, "Background")),
  
  tar_target(demo_table, print_demographics(leaves_final))
)