get_movie_details <- function(id, apikey=keyring::key_get('tmdb_api_key')) {
  response <- httr::GET("https://api.themoviedb.org",
                        path=list("3", "movie", id),
                        query=list(api_key=apikey))

  httr::warn_for_status(response, task="GET movie details")

  httr::content(response, 'parsed')
}
