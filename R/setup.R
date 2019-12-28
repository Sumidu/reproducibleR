###########
# Setup Script to install the required packages


if(!require(devtools)){
  install.packages("devtools")
}
devtools::install_github("statisticsforsocialscience/rmd_templates")
devtools::install_github("statisticsforsocialscience/sssverse")
library(rmdtemplates)
