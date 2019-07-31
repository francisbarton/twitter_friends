library(twitteR)
library(tibble)
library(dplyr)
library(lubridate)

user <- twitteR::getUser("oddhack")
friends <- user$getFriends()
friend_data <- tibble(number = 1:length(friends))
friend_data$handle <- sapply(friends, `[[`, "screenName")
# friend_data <- tibble::rownames_to_column(friendcounts)
# friend_data <- dplyr::rename(friendcounts, "id" = 1, "handle" = 2)
friend_data$friends <- sapply(friends, `[[`, "friendsCount")
friend_data$created <- lubridate::as_datetime(sapply(friends, `[[`, "created"))
friend_data$latest <- lubridate::as_datetime(sapply(sapply(friends, `[[`, "lastStatus"), `[[`, ".->created"))

friend_data$hours_since <- round(
  as.numeric(
    lubridate::as.duration(
      lubridate::`%--%`(friend_data$latest, now())
    ),
  "hours"),
digits = 0)

friend_data$verified <- sapply(friends, `[[`, "verified")