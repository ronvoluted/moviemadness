# Libraries and sources ----

library(tidyverse)
source("R/get-movie-details.R")
source("R/get-movie-cast.R")



# Functions ----

# Check total pages, total results and whether the request was successful

check_top_rated <- function(apikey = keyring::key_get('tmdb_api_key')) {
  response <- httr::GET("https://api.themoviedb.org/3/movie/top_rated",
                        query = list(api_key = apikey))

  httr::warn_for_status(response, task=paste("GET top rated results page", page))

  content <- httr::content(response, 'parsed')

  list(total_pages = content[["total_pages"]], total_results = content[["total_results"]])
}

# Get any page of results from API

get_top_rated <- function(page = 1, apikey = keyring::key_get('tmdb_api_key')) {
  response <- httr::GET("https://api.themoviedb.org/3/movie/top_rated",
                       query = list(api_key=apikey, page=page))

  httr::content(response, 'parsed')[["results"]]
}

# "Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"

# Save any number of pages of results to TSV and display progress

save_top_rated <- function(range=5, start=1, filename="top_rated_movies.tsv") {
  # If the input range is less than the total pages/results, set the totals to be used
  count <- check_top_rated()

  if (range < count[["total_pages"]]) {
    count[["total_pages"]] = range
    count[["total_results"]] = range * 20
  }

  # Set column headers
  # `columns` contains fields returned from the API endpoint
  # `genres`, tagline, runtime, budget and revenue fields are appended from separate endpoints

  columns <- list("id", "title", "original_title", "overview", "release_date", "original_language", "genre_ids", "adult", "poster_path", "backdrop_path", "popularity", "vote_count", "vote_average", "video")

  genres <- list("Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western")

  columns_appended <- c(columns, "tagline", "runtime", "budget", "revenue", genres)

  # Create empty TSV file with only column headers
  write.table(columns_appended, filename, sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE)

  # Initialise progress bar for console output
  pb <- progress::progress_bar$new(
    format="[:bar] :results/:result_total Page: :pages/:page_total ETA: :eta\n",
    clear=FALSE, total=range, width=70)

  # Request a page of results for the entire range
  for (i in start:(start + range - 1)) {
    results_page <- get_top_rated(i)

    for (result in results_page) {
      result <- result[unlist(columns)]

      # Get further movie details from separate endpoint
      details <- get_movie_details(result[["id"]])

      # Append expanded details to current result

      result["tagline"] <- details[["tagline"]]
      result["runtime"] <- details[["runtime"]]
      result["budget"] <- details[["budget"]]
      result["revenue"] <- details[["revenue"]]

      genre_names <- lapply(details[["genres"]], function(genre) {
        genre[["name"]]
      })

      for (genre in genres) {
        if (is.na(match(genre, genre_names))) {
          result[genre] <- FALSE
        } else {
          result[genre] <- TRUE
        }
      }

      # Parse the genre field which is a list, into a character
      result["genre_ids"] <- paste(result[["genre_ids"]], collapse=", ")

      # Handle NULL values which will error in `as_tibble()`
      result <- lapply(result, function(field) {
        if (is.null(field)) { field = '' }
        field
      })

      # Append result to TSV. Tab separated values due to heavy use of commas in dataset
      write_delim(
        as_tibble(result),
        filename,
        delim = "\t",
        append = TRUE
      )

      print(result[["title"]])
    }

    # Update progress bar
    pb$tick(tokens=list(results=i*20, result_total=count[["total_results"]], pages=i, page_total=count[["total_pages"]]))

    # While TMDB explicitly places no restrictions, rate limit the request out of courtesy
    Sys.sleep(5)
  }
}



# Test sample (uncomment to run) ----

# save_top_rated(range=3, start=1, filename="data/all_top_rated_movies_sample.tsv")



# Save every top rated movie from TMDB to a TSV file. Make some tea! ----

check_top_rated()[["total_pages"]] %>%
  save_top_rated(filename="data/all_top_rated_movies.tsv")
