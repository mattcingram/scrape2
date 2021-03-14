##############################
# Replication code for Ingram: 
# GS citations  
# Matthew C. Ingram
# University at Albany, SUNY
# contact: mingram@albany.edu
# Date started: 202012
# Last updated: 20210310
# items in this file: setup
##############################


#################################
#
# SET WORKING DIRECTORY and SUBDIRECTORIES
# 
################################## 

# working directory
# on cluster
#path <- "/network/rit/home/mi122167/ingramlab/webscrape"
# on machine
path <- "B:/webscrape"

setwd(path)

dir()

# create subdirectories
dir.create('./code', showWarnings = TRUE)
dir.create('./data', showWarnings = TRUE)
dir.create('./data/original', showWarnings = TRUE)
dir.create('./data/working', showWarnings = TRUE)
dir.create('./figures', showWarnings = TRUE)
dir.create('./tables', showWarnings = TRUE)
dir.create('./shapefiles', showWarnings = TRUE)



###########################################################
#
# Environment and Session Information
#
###########################################################


#install.packages("pacman")
library(pacman)

p_load(RSelenium,
       rvest, 
       stringr,
       plyr, dplyr,
       gender,
       genderizeR,
       data.table,
       devtools,
       emmeans, car,
       ggplot2, forcats, vioplot, caroline,
       reticulate,
       stargazer, xtable, interplot,
       tictoc)

#end
