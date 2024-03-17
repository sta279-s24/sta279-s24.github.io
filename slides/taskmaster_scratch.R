library(rvest)
library(tidyverse)
library(data.table)

tm <- read_html("https://taskmaster.fandom.com/wiki/Series_11")

tm

tm |>
  html_elements("table")

results <- tm |> 
  html_element(".tmtable") |> 
  html_table()

results <- results |>
  mutate(episode = ifelse(startsWith(Task, "Episode"), Task, NA)) |>
  fill(episode, .direction = "down")

results <- results |>
  filter(!startsWith(Task, "Episode"), !(Task %in% c("Total", "Grand Total")))

results <- results |>
  pivot_longer(cols = -c(Task, Description, episode),
               names_to = "contestant",
               values_to = "score")



results <- tm |> 
  html_element(".tmtable") |> 
  html_table() |>
  mutate(episode = ifelse(startsWith(Task, "Episode"), Task, NA)) |>
  fill(episode, .direction = "down") |>
  filter(!startsWith(Task, "Episode"), !(Task %in% c("Total", "Grand Total"))) |>
  pivot_longer(cols = -c(Task, Description, episode),
               names_to = "contestant",
               values_to = "score") |>
  mutate(series = 11)




urls <- paste0("https://taskmaster.fandom.com/wiki/Series_", 1:15)
df_list <- list()
for(i in 1:15){
  df_list[[i]] <-read_html(urls[i]) |>
    html_element(".tmtable") |> 
    html_table() |>
    mutate(episode = ifelse(startsWith(Task, "Episode"), Task, NA)) |>
    fill(episode, .direction = "down") |>
    filter(!startsWith(Task, "Episode"), !(Task %in% c("Total", "Grand Total"))) |>
    pivot_longer(cols = -c(Task, Description, episode),
                 names_to = "contestant",
                 values_to = "score") |>
    mutate(series = i)
}

results <- rbindlist(df_list)

results |>
  group_by(series) |>
  summarize(num_episodes = n_distinct(episode))

tm <- read_html("https://taskmaster.fandom.com/wiki/Series_15")








results <- results |>
  separate_wider_regex(episode, patterns = c(".* ", episode = "[0-9]+", ": ", 
                                          episode_name = ".*", 
                                          "\\(", air_date = ".*", "\\)"))


#episode_names <- results |>
#  filter(startsWith(Task, "Episode")) |>
#  separate_wider_delim(Task, delim = ":", names = c("Episode", "Name"))

episode_info <- results |>
  select(Task) |>
  filter(startsWith(Task, "Episode")) |>
  separate_wider_regex(Task, patterns = c(".* ", episode = "[0-9]+", ": ", 
                                          episode_name = ".*", 
                                          "\\(", air_date = ".*", "\\)"))

episode_info <- results |>
  select(Task) |>
  filter(startsWith(Task, "Episode")) |>
  separate_wider_regex(Task, patterns = c(".* ", episode = "[0-9]+", ": ", 
                                          episode_name = ".*", 
                                          "[(]", air_date = ".*", "[)]"))

episode_names 





# getting contestant info

susan <- read_html("https://taskmaster.fandom.com/wiki/Susan_Wokoma")

susan |>
  html_element("[data-source^='born']") |>
  html_text() |>
  str_extract("[0-9]+.*[0-9]+")

susan |> html_elements("[data-source^='born'] > .pi-font") |> html_text()


contestant <- read_html("https://taskmaster.fandom.com/wiki/Lucy_Beaumont")

contestant |>
  html_element("[data-source^='born']") |>
  html_text() |>
  str_extract("[0-9]+.*[0-9]+")

contestant |> 
  html_elements("[data-source^='born'] > .pi-font") |> 
  html_text()


