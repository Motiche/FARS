#' fars_read
#'
#' This function reads a csv file form a given directory, to a data table
#' data frame
#'
#'
#' @param filename A character string giving directory and name of the csv
#' file which is needed to be read
#'
#' @return This function returns a data.frame, if the filename does not exist
#' either for wrong name or wrong directory, returns error.
#'
#' @examples
#' \dontrun{fars_read("accident_2013.csv.bz2")}
#' \dontrun{fars_read("data/accident_2013.csv.bz2")}
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @export

STATE = year = MONTH = NULL

fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}


#' make_filename
#'
#' This function gets a year and generates filename for that given year
#'
#'
#' @param year year as a number, or a list of numbers,
#' in form of integer of character
#'
#' @examples
#' \dontrun{make_filename("2013")}
#' \dontrun{make_filename(2013)}
#' \dontrun{make_filename(c(2013,2014))}
#'
#' @return This function returns a filename based on the given year in .csv format.
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' fars_read_years
#'
#' This function gets years and fetches datasets corresponding to the
#' given years
#'
#'
#' @param years years as a number, or a list of numbers,
#' in form of integer of character
#' @param MONTH selected month
#'
#' @return This function returns a list in which each item is correspond to
#' a year, each item is a dataframe containing two columns: Month and year
#'
#' @examples
#' \dontrun{fars_read_years("2013")}
#' \dontrun{fars_read_years(2013)}
#' \dontrun{fars_read_years(c(2013,2014))}
#'
#' @importFrom tidyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(.data$MONTH, .data$year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' fars_summarize_years
#'
#' This function gets a vector of years/year and returns a summary of
#' quantity of accidents, columns being the years and rows being months
#'
#'
#' @param year year as a number, or a list of numbers,
#' in form of integer of character
#' @param MONTH selected month
#' @param n observed numbers
#'
#' @return This function returns a list in which each item is correspond to
#' a year, each item is a dataframe containing two columns: Month and year
#'
#' @examples
#' \dontrun{fars_summarize_years("2013")}
#' \dontrun{fars_summarize_years(2013)}
#' \dontrun{fars_summarize_years(c(2013,2014,2015))}
#'
#' @importFrom tidyr %>%
#' @importFrom tidyr spread
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr n
#'
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(.data$year, .data$MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' fars_map_state
#'
#' This function gets a number of of USA stat and a year, and visualize
#' state map, with accidents as points in it on that year.
#'
#' @param state.num number of a USA state in form of integer of character
#' @param year year as a number in form of integer of character
#' @param STATE selected state
#'
#' @examples
#' \dontrun{fars_map_state("53","2013")}
#' \dontrun{fars_map_state("4",2015)}
#' \dontrun{fars_map_state(10,2014)}
#'
#' @return This function returns a map of a state, with points as location of
#' accidents
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(.data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
