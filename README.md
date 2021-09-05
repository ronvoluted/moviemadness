# STDS Group 5: Movie Madness

Group repository for Assignment 2: Data Analysis Project

## Members

- Ron Au
- Maggie Chen
- Jordan Daly
- Maria Dhaliwal
- Jean Koh
- Rashmi Madduma Patabedige

## Repository structure

- R: R scripts, functions
- Rmd: Rmarkdown, EDA, vignettes
- data: Data sources, generated datasets
- reports: Written documents, rendered visualisations/HTML/PDF

## Running instructions

### Setting up the project in RStudio

1. Load up RStudio and head to "File > New Project..."
2. Choose the "Version Control" option and then "Git"
3. Set the "Repository URL" to "https://github.com/ronvoluted/moviemadness"
4. Leave the name as-is and choose which directory on your computer you'd like it to be saved to

Git/version control operations are found in the "Git" tab of RStudio:

![RStudio interface showing Git tab](https://user-images.githubusercontent.com/5785323/131172131-581e0709-2609-4b2d-8e65-583d2d1e5034.png "Git tab in RStudio")

5. To keep the project on your computer up to date with code on GitHub, make sure you regularly:
a) Use the blue down arrow icon to pull all latest changes from the main brance of the repository
b) Run `renv::restore()` to ensure you have the same packages installed as other group members
-  You can find an [explanation of renv on Canvas](https://canvas.uts.edu.au/courses/20106/discussion_topics/154971#entry-348813)
-  You only need to install the [renv package](https://rstudio.github.io/renv/index.html) once:
```r
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_github("rstudio/renv")
```

### Managing the API key

_An API key to use has been posted in the Microsoft Teams chat, but ideally you will acquire your own._

1. Register for an account at [The Movie Database](https://www.themoviedb.org)
2. Request an API key on the [Settings > API page](https://www.themoviedb.org/settings/api) under "Request an API Key" using these details:
  - Application Name: University of Technology Sydney Project
  - Application URL: https://github.com/ronvoluted/moviemadness
  - Application Description: University of Technology Sydney Project
4. Run `keyring::key_set('tmdb_api_key')` in the RStudio console
5. Copy the [API key from TMDB](https://www.themoviedb.org/settings/api) into the window asking for a Password

The project on your computer will now be able to access your API key without it being exposed/hardcoded in the files we share.

## Getting and using data

### Saved dataset
[A TSV file in the data folder](https://github.com/ronvoluted/moviemadness/blob/tmdb-api/data/all_top_rated_movies_2021-08-28.tsv) contains all 9,040 movies listed in TMDB's "top rated" endpoint. We will work from this file to begin with.

### Reproducibility
To recreate the TSV file, take a look at the [`get-top-rated-movies.R` script in the R folder](https://github.com/ronvoluted/moviemadness/blob/tmdb-api/R/get-top-rated-movies.R). It contains functions to let us query some, or all of the "top rated" endpoint. With self-imposed rate limiting added, the ETA for building the entire dataset is 10 minutes.

![Console output showing progress of large API query for tope rated movies from TMDB](https://user-images.githubusercontent.com/5785323/131176750-e34af0ff-854a-409e-b0a6-100b5d451628.png "Querying TMDB API for top rated movies")

### Further details

The TSV is filtered to a 200 long subset of movies in [`filter-movies.R`](https://github.com/ronvoluted/moviemadness/blob/tmdb-api/R/filter-movies.R). With the fields made available in the "top rated" endpoint, the following filters could be applied:

- Released in 2019
- At least 500 user votes
- Not adult rated

Further data and filtering can be applied using the [`get-movie-details.R`](https://github.com/ronvoluted/moviemadness/blob/tmdb-api/R/get-movie-details.R) and [`get-movie-cast.R`](https://github.com/ronvoluted/moviemadness/blob/tmdb-api/R/get-movie-cast.R) scripts.
