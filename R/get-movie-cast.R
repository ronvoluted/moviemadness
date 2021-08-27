get_movie_cast <- function(id, apikey=keyring::key_get('tmdb_api_key')) {
  response <- httr::GET("https://api.themoviedb.org",
                        path=list("3", "movie", id, "credits"),
                        query=list(api_key=apikey))

  httr::warn_for_status(response, task="GET movie cast")

  httr::content(response, 'parsed')[["cast"]]
}
