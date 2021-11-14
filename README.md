# FARS
No matter what I did, Travis continues to gie me his non-sense error "We are unable to start your build at this time. You exceeded the number of users allowed for your plan. Please review your plan details and follow the steps to resolution."
travis badge: ![example workflow](https://app.travis-ci.com/Motiche/FARS.svg?branch=main)




```{r setup}
library(FARS)
```
### fars_read
This function reads a csv file form a given directory, to a data table, and returns a data.frame, if the filename does not exist either for wrong name or wrong directory, returns error.

Parameters = filename: A character string giving directory and name of the csv

example:
```{r}
# Navigate to your data directory
fars_read("accident_2013.csv.bz2")
```


### make_filename
This function gets a year and generates filename for that given year, returns a filename based on the given year in .csv format.

Parameters = year: as a number, or a list of numbers,in form of integer of character
```{r}
# make_filename(c(2013,2014))
```


### fars_read_years
This function gets years and fetches datasets corresponding to the given years, returns a list in which each item is correspond to a year, each item is a dataframe containing two columns: Month and year

Parameters = years: as a number, or a list of numbers, in form of integer of character
```{r}
# fars_read_years(2013)
```


### fars_summarize_years
This function gets a vector of years/year and returns a summary of quantity of accidents, columns being the years and rows being months. This function returns a list in which each item is correspond to a year, each item is a dataframe containing two columns: Month and year

Parameters = year as a number, or a list of numbers, in form of integer of character
```{r}
# fars_summarize_years(2013)
```

### fars_map_state
This function gets a number of of USA stat and a year, and visualize  state map, with accidents as points in it on that year. returns a map of a state, with points as location of accidents

Parametes: state.num: number of a USA state in form of integer of character
year: year as a number in form of integer of character

```{r}
# fars_map_state(10,2014)
```


