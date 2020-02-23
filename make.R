# MAKE-FILE ############## 
#
# This is a drake make file that produces output and keeps track of dependencies
#
# Sat Feb 22 10:56:53 2020 ------------------------------


library(drake)
library(tidyverse)
library(osfr)

# Restart everyhing? run clean
# clean()


# loading data from the osf-repository
get_osf_data <- function() {
  # get the id (make sure it is publically available)
  id <- osf_retrieve_node("r49px")
  files <- osfr::osf_ls_files(id)
  osfr::osf_download(files, "data/", conflicts = "overwrite")
  read_csv("data/iris.csv")
}

# a plot that takes very long to create and is later used  
create_plot <- function(data){
  data %>% ggplot() +
    aes(x = Species) +
    aes(y = Sepal.Width) +
    geom_boxplot() +
    labs(title = "Example plot from drake")
}

gen_bib <- drake::code_to_function("bib/generate_bib_file.R")

# each step of the plan keeps track of what is used where.
plan <- drake_plan(
  
  # Download the data (note the comma at the end of each line)
  iris_data = get_osf_data(), 
  
  # read the data and to some transformation
  data = iris_data %>%
    mutate(Species = forcats::fct_inorder(Species)),
  
  # create a plot that is later used
  hist = create_plot(data),
  
  # fit a model
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),
  
  bibfile = gen_bib(drake::file_out("bib/rpackages.bib")),
   # render the pdf document
  report = rmarkdown::render(
    knitr_in("Paper/Paper.Rmd"),
    quiet = TRUE
  ),
  
  # render the open data website
  website = rmarkdown::render(
    knitr_in("Website/Website.Rmd"),
    quiet = TRUE
  ),
  # put the updated website into the docs folder for github pages.
  publish_website = file.copy(website, to="docs/", overwrite = T)
)


# run the plan
make(plan,lock_envir = FALSE)

# do not run this from a make file
if(interactive()) {

  # look at indiviual outputs
  readd(hist)
  readd(website)

  # what depends on what?
  vis_drake_graph(plan)

  # Show history
  drake_history(analyze = TRUE)
}

# run on multiple cores
# make(plan, jobs = 4)
