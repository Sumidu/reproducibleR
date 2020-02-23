library(tidyverse)
deps <- renv::dependencies()

pkgs <- deps$Package %>% unique()

#pkgs <- c("knitr", "tidyverse", "rmdformats", "kableExtra", "scales", "psych", "rmdtemplates", 
#          "sdcMicro", "webshot", "here", "DiagrammeR", "citr", "drake", "esquisse", "usethis", "gramr", "questionr", "ggstatsplot")

knitr::write_bib(pkgs, "bib/rpackages.bib", width = 120)



# notrun only to create dependencies for renv
if(F){
  esquisse::build_aes()
  kableExtra::add_footnote()
  scales::abs_area()
  psych::acs()
  sdcMicro::addGhostVars()
  citr::insert_citation()
  gramr::check_grammar()
  questionr::qload()
  ggstatsplot::as_tibble()
  packrat::clean()
  here::here()
  usethis::use_badge()
  webshot::appshot()
  renv::history()
  
}
