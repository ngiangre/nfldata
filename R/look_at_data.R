library(tidyverse)
library(nflreadr)
library(arrow)

datasets <-
    nflreadr::nflverse_releases()[['release_name']]

purrr::walk(
    datasets,~{
        do.call(
            nflreadr::nflverse_download,
            list(
                ... = .x,
                folder_path = "data/",file_type = "parquet")
        )
    }
)

# View data that's available ----------------------------------------------

fs::dir_ls('data/')

# Weekly rosters ----------------------------------------------------------
nflreadr::dictionary_rosters
data_dir <- arrow::open_dataset("data/weekly_rosters")
data_dir |>
    filter(season==2023L,
           week==1L,
           team=="BUF") |>
    collect() |>
    pivot_wider(
        id_cols = c(team,status),
        names_from = depth_chart_position,
        values_from = full_name
    )

# combine -----------------------------------------------------------------

nflreadr::dictionary_combine
data_dir <- arrow::open_dataset("data/combine")
data_dir |>
    filter(season==2023L,grepl("Buf",draft_team)) |>
    collect()

# injuries -----------------------------------------------------------------

nflreadr::dictionary_injuries
data_dir <- arrow::open_dataset("data/injuries/season=2023/")
data_dir |>
    filter(team=="BUF") |>
    collect() |> View()

# play by play -----------------------------------------------------------------

nflreadr::dictionary_pbp
data_dir <- arrow::open_dataset("data/pbp")
data_dir |>
    filter(home_team=="BUF",grepl("2023",game_id),week==19) |>
    select(play_id,game_id,contains('player_name')) |>
    collect() |>
    pivot_longer(
        cols = contains('player_name'),
        names_to = "play_action",
        values_to = "player_name"
    ) |>
    mutate(
        play_id = factor(play_id),
        play_action = stringr::str_remove(play_action,"_player_name"),
        play_action = stringr::str_remove(play_action,"_[0-9]$")
    ) |>
    drop_na()
