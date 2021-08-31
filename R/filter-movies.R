# Libraries ----

library(tidyverse)
library(lubridate)



# Filter saved movies ----

filtered_movies <- read_tsv("data/all_top_rated_movies_2021-08-28.tsv") %>%
  filter(
    year(.data[["release_date"]]) == 2019,
    vote_count > 500,
    adult == FALSE)
