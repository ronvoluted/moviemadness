# Libraries ----

library(tidyverse)
library(lubridate)
source("R/get-movie-details.R")



# Filter saved movies ----

filtered_movies <- read_tsv("data/all_top_rated_movies_2021-09-01.tsv") %>%
  filter(
    year(.data[["release_date"]]) == 2019,
    vote_count > 500,
    runtime >= 60,
    runtime <= 180,
    adult == FALSE)
