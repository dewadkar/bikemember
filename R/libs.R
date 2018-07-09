ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
# usage
packages <- c("ggplot2", "scales", "grid", "gridExtra", "RColorBrewer", "corrplot")
packages <- c(packages, "dplyr", "readr", "tibble", "tidyr", "stringr", "forcats")
packages <- c(packages,"alluvial","ggrepel","ggforce","ggridges","gganimate","gridExtra","GGally","ggExtra")
packages <- c(packages,"lazyeval","broom","purrr","reshape2","rlang", "foreach","doParallel")
ipak(packages)



# general visualisation
library('ggplot2') # visualisation
library('scales') # visualisation
library('grid') # visualisation
library('gridExtra') # visualisation
library('RColorBrewer') # visualisation
library('corrplot') # visualisation

# general data manipulation
library('dplyr') # data manipulation
library('readr') # input/output
library('data.table') # data manipulation
library('tibble') # data wrangling
library('tidyr') # data wrangling
library('stringr') # string manipulation
library('forcats') # factor manipulation

# specific visualisation
library('alluvial') # visualisation
library('ggrepel') # visualisation
library('ggforce') # visualisation
library('ggridges') # visualisation
library('gganimate') # animations
library('gridExtra') # visualisation
library('GGally') # visualisation
library('ggExtra') # visualisation

# specific data manipulation
library('lazyeval') # data wrangling
library('broom') # data wrangling
library('purrr') # string manipulation
library('reshape2') # data wrangling
library('rlang') # data wrangling

# parallel
library('foreach')
library('doParallel')





