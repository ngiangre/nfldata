README
================

``` r
library(tidyverse)
library(nflreadr)
library(arrow)
```

``` r
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
```

    ## Warning: Could not find files of type "parquet" for the following release: "test".
    ## Please try another file type.

``` r
# View data that's available ----------------------------------------------

fs::dir_ls('data/')
```

    ## data/combine            data/contracts          data/depth_charts       
    ## data/draft_picks        data/espn_data          data/ftn_charting       
    ## data/injuries           data/misc               data/nextgen_stats      
    ## data/officials          data/pbp                data/pbp_participation  
    ## data/pfr_advstats       data/player_stats       data/players            
    ## data/players_components data/rosters            data/snap_counts        
    ## data/test               data/weekly_rosters

``` r
# Weekly rosters ----------------------------------------------------------
nflreadr::dictionary_rosters
```

    ##                   field data_type
    ## 1                season   numeric
    ## 2                  team character
    ## 3              position character
    ## 4  depth_chart_position character
    ## 5         jersey_number   numeric
    ## 6                status character
    ## 7             full_name character
    ## 8            first_name character
    ## 9             last_name character
    ## 10           birth_date      date
    ## 11               height character
    ## 12               weight character
    ## 13              college character
    ## 14          high_school character
    ## 15              gsis_id character
    ## 16         headshot_url character
    ## 17           sleeper_id character
    ## 18              espn_id   numeric
    ## 19             yahoo_id   numeric
    ## 20          rotowire_id   numeric
    ## 21               pff_id   numeric
    ## 22      fantasy_data_id   numeric
    ## 23            years_exp   numeric
    ## 24        sportradar_id character
    ## 25               pfr_id character
    ##                                                                                   description
    ## 1               NFL season. Defaults to current year after March, otherwise is previous year.
    ## 2                                        NFL team. Uses official abbreviations as per NFL.com
    ## 3                                                     Primary position as reported by NFL.com
    ## 4                                      Position assigned on depth chart. Not always accurate!
    ## 5                                  Jersey number. Often useful for joins by name/team/jersey.
    ## 6  Roster status: describes things like Active, Inactive, Injured Reserve, Practice Squad etc
    ## 7                                                                    Full name as per NFL.com
    ## 8                                                                   First name as per NFL.com
    ## 9                                                                    Last name as per NFL.com
    ## 10                                                      Birthdate, as recorded by Sleeper API
    ## 11                                                                 Official height, in inches
    ## 12                                                                 Official weight, in pounds
    ## 13                                           Official college (usually the last one attended)
    ## 14                                                                                High school
    ## 15                      Game Stats and Info Service ID: the primary ID for play-by-play data.
    ## 16              A URL string that points to player photos used by NFL.com (or sometimes ESPN)
    ## 17                                                                  Player ID for Sleeper API
    ## 18                                                                     Player ID for ESPN API
    ## 19                                                                    Player ID for Yahoo API
    ## 20                                                                     Player ID for Rotowire
    ## 21                                                           Player ID for Pro Football Focus
    ## 22                                                                  Player ID for FantasyData
    ## 23                                                                     Years played in league
    ## 24                                                               Player ID for Sportradar API
    ## 25                                                       Player ID for Pro Football Reference

``` r
data_dir <- arrow::open_dataset("data/weekly_rosters")
data_dir |>
    filter(season==2023L,
           week==19L,
           team=="BUF") |>
    collect() |>
    pivot_wider(
        id_cols = c(team,status),
        names_from = depth_chart_position,
        values_from = full_name
    )
```

    ## Warning: Values from `full_name` are not uniquely identified; output will contain
    ## list-cols.
    ## • Use `values_fn = list` to suppress this warning.
    ## • Use `values_fn = {summary_fun}` to summarise duplicates.
    ## • Use the following dplyr code to identify duplicates.
    ##   {data} |>
    ##   dplyr::summarise(n = dplyr::n(), .by = c(team, status, depth_chart_position))
    ##   |>
    ##   dplyr::filter(n > 1L)

    ## # A tibble: 6 × 21
    ##   team  status NT        OLB    CB     FS     P      SS     RB     DT     WR    
    ##   <chr> <chr>  <list>    <list> <list> <list> <list> <list> <list> <list> <list>
    ## 1 BUF   ACT    <chr [1]> <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr> 
    ## 2 BUF   DEV    <chr [1]> <NULL> <chr>  <NULL> <NULL> <NULL> <chr>  <NULL> <chr> 
    ## 3 BUF   RES    <NULL>    <NULL> <chr>  <NULL> <NULL> <NULL> <chr>  <chr>  <chr> 
    ## 4 BUF   RET    <NULL>    <NULL> <NULL> <NULL> <NULL> <NULL> <NULL> <NULL> <NULL>
    ## 5 BUF   INA    <NULL>    <NULL> <chr>  <NULL> <NULL> <chr>  <NULL> <NULL> <chr> 
    ## 6 BUF   CUT    <NULL>    <NULL> <NULL> <NULL> <NULL> <NULL> <NULL> <chr>  <NULL>
    ## # ℹ 10 more variables: C <list>, MLB <list>, G <list>, T <list>, LS <list>,
    ## #   DE <list>, QB <list>, TE <list>, K <list>, FB <list>

``` r
# combine -----------------------------------------------------------------

nflreadr::dictionary_combine
```

    ##          field data_type
    ## 1       season   numeric
    ## 2   draft_year   numeric
    ## 3   draft_team character
    ## 4  draft_round   numeric
    ## 5    draft_ovr   numeric
    ## 6       pfr_id   numeric
    ## 7       cfb_id   numeric
    ## 8  player_name character
    ## 9          pos character
    ## 10      school character
    ## 11          ht   numeric
    ## 12          wt   numeric
    ## 13       forty   numeric
    ## 14       bench   numeric
    ## 15    vertical   numeric
    ## 16  broad_jump   numeric
    ## 17        cone   numeric
    ## 18     shuttle   numeric
    ##                                                                  description
    ## 1  4 digit number indicating which season(s) the specified combine occurred.
    ## 2                                               Year that player was drafted
    ## 3                                                   Team that drafted player
    ## 4                                           Round that player was drafted in
    ## 5                                                      Pick number of player
    ## 6                                       Pro-Football-Reference ID for player
    ## 7                                       Sports Reference (CFB) ID for player
    ## 8                                                        Full name of player
    ## 9                                                         Position of player
    ## 10                                                         College of player
    ## 11                                        Height of player (feet and inches)
    ## 12                                                    Weight of player (lbs)
    ## 13                           Player's 40 yard dash time at combine (seconds)
    ## 14                                         Reps benched by player at combine
    ## 15                                Player's vertical jump at combine (inches)
    ## 16                                   Player's broad jump at combine (inches)
    ## 17                           Player's 3 cone drill time at combine (seconds)
    ## 18                            Player's shuttle run time at combine (seconds)

``` r
rqdata_dir <- arrow::open_dataset("data/combine")
rqdata_dir |>
    filter(season==2023L,grepl("Buf",draft_team)) |>
    collect()
```

    ## # A tibble: 6 × 18
    ##   season draft_year draft_team   draft_round draft_ovr pfr_id cfb_id player_name
    ## *  <int>      <dbl> <chr>              <dbl>     <dbl> <chr>  <chr>  <chr>      
    ## 1   2023       2023 Buffalo Bil…           7       252 AustA… alex-… Alex Austin
    ## 2   2023       2023 Buffalo Bil…           7       230 BroeN… nick-… Nick Broek…
    ## 3   2023       2023 Buffalo Bil…           1        25 KincD… dalto… Dalton Kin…
    ## 4   2023       2023 Buffalo Bil…           5       150 ShorJ… justi… Justin Sho…
    ## 5   2023       2023 Buffalo Bil…           2        59 TorrO… ocyru… O'Cyrus To…
    ## 6   2023       2023 Buffalo Bil…           3        91 WillD… doria… Dorian Wil…
    ## # ℹ 10 more variables: pos <chr>, school <chr>, ht <chr>, wt <dbl>,
    ## #   forty <dbl>, bench <dbl>, vertical <dbl>, broad_jump <dbl>, cone <dbl>,
    ## #   shuttle <dbl>

``` r
# injuries -----------------------------------------------------------------

nflreadr::dictionary_injuries
```

    ##                        field data_type
    ## 1                     season   numeric
    ## 2                season_type   numeric
    ## 3                       team character
    ## 4                       week   numeric
    ## 5                    gsis_id   numeric
    ## 6                   position character
    ## 7                  full_name character
    ## 8                 first_name character
    ## 9                  last_name character
    ## 10     report_primary_injury character
    ## 11   report_secondary_injury character
    ## 12             report_status character
    ## 13   practice_primary_injury character
    ## 14 practice_secondary_injury character
    ## 15           practice_status character
    ## 16             date_modified character
    ##                                                                         description
    ## 1  4 digit number indicating to which season(s) the specified timeframe belongs to.
    ## 2        REG or POST indicating if the timeframe belongs to regular or post season.
    ## 3                                                            Team of injured player
    ## 4                                                         Week that injury occurred
    ## 5             Game Stats and Info Service ID: the primary ID for play-by-play data.
    ## 6                                                        Position of injured player
    ## 7                                                               Full name of player
    ## 8                                                              First name of player
    ## 9                                                               Last name of player
    ## 10                                  Primary injury listed on official injury report
    ## 11                                Secondary injury listed on official injury report
    ## 12                               Player's status for game on official injury report
    ## 13                                  Primary injury listed on practice injury report
    ## 14                                Secondary injury listed on practice injury report
    ## 15                                               Player's participation in practice
    ## 16                                Date and time that injury information was updated

``` r
data_dir <- arrow::open_dataset("data/injuries/season=2023/")
data_dir |>
    filter(team=="BUF") |>
    collect()
```

    ## # A tibble: 161 × 16
    ##    season game_type team   week gsis_id  position full_name first_name last_name
    ##  *  <int> <chr>     <chr> <int> <chr>    <chr>    <chr>     <chr>      <chr>    
    ##  1   2023 REG       BUF       1 00-0030… S        Micah Hy… Micah      Hyde     
    ##  2   2023 REG       BUF       2 00-0031… C        Mitch Mo… Mitch      Morse    
    ##  3   2023 REG       BUF       3 00-0030… S        Jordan P… Jordan     Poyer    
    ##  4   2023 REG       BUF       3 00-0033… CB       Tre'Davi… Tre'Davio… White    
    ##  5   2023 REG       BUF       3 00-0037… LB       Terrel B… Terrel     Bernard  
    ##  6   2023 REG       BUF       3 00-0036… T        Spencer … Spencer    Brown    
    ##  7   2023 REG       BUF       3 00-0037… RB       James Co… James      Cook     
    ##  8   2023 REG       BUF       3 00-0033… DE       Leonard … Leonard    Floyd    
    ##  9   2023 REG       BUF       3 00-0030… S        Micah Hy… Micah      Hyde     
    ## 10   2023 REG       BUF       3 00-0035… TE       Dawson K… Dawson     Knox     
    ## # ℹ 151 more rows
    ## # ℹ 7 more variables: report_primary_injury <chr>,
    ## #   report_secondary_injury <chr>, report_status <chr>,
    ## #   practice_primary_injury <chr>, practice_secondary_injury <chr>,
    ## #   practice_status <chr>, date_modified <dttm>

``` r
# play by play -----------------------------------------------------------------

nflreadr::dictionary_pbp
```

    ##                                    Field
    ## 1                                play_id
    ## 2                                game_id
    ## 3                            old_game_id
    ## 4                              home_team
    ## 5                              away_team
    ## 6                            season_type
    ## 7                                   week
    ## 8                                posteam
    ## 9                           posteam_type
    ## 10                               defteam
    ## 11                         side_of_field
    ## 12                          yardline_100
    ## 13                             game_date
    ## 14             quarter_seconds_remaining
    ## 15                half_seconds_remaining
    ## 16                game_seconds_remaining
    ## 17                             game_half
    ## 18                           quarter_end
    ## 19                                 drive
    ## 20                                    sp
    ## 21                                   qtr
    ## 22                                  down
    ## 23                            goal_to_go
    ## 24                                  time
    ## 25                                 yrdln
    ## 26                               ydstogo
    ## 27                                ydsnet
    ## 28                                  desc
    ## 29                             play_type
    ## 30                          yards_gained
    ## 31                               shotgun
    ## 32                             no_huddle
    ## 33                           qb_dropback
    ## 34                              qb_kneel
    ## 35                              qb_spike
    ## 36                           qb_scramble
    ## 37                           pass_length
    ## 38                         pass_location
    ## 39                             air_yards
    ## 40                     yards_after_catch
    ## 41                          run_location
    ## 42                               run_gap
    ## 43                     field_goal_result
    ## 44                         kick_distance
    ## 45                    extra_point_result
    ## 46                 two_point_conv_result
    ## 47               home_timeouts_remaining
    ## 48               away_timeouts_remaining
    ## 49                               timeout
    ## 50                          timeout_team
    ## 51                               td_team
    ## 52                        td_player_name
    ## 53                          td_player_id
    ## 54            posteam_timeouts_remaining
    ## 55            defteam_timeouts_remaining
    ## 56                      total_home_score
    ## 57                      total_away_score
    ## 58                         posteam_score
    ## 59                         defteam_score
    ## 60                    score_differential
    ## 61                    posteam_score_post
    ## 62                    defteam_score_post
    ## 63               score_differential_post
    ## 64                         no_score_prob
    ## 65                           opp_fg_prob
    ## 66                       opp_safety_prob
    ## 67                           opp_td_prob
    ## 68                               fg_prob
    ## 69                           safety_prob
    ## 70                               td_prob
    ## 71                      extra_point_prob
    ## 72             two_point_conversion_prob
    ## 73                                    ep
    ## 74                                   epa
    ## 75                        total_home_epa
    ## 76                        total_away_epa
    ## 77                   total_home_rush_epa
    ## 78                   total_away_rush_epa
    ## 79                   total_home_pass_epa
    ## 80                   total_away_pass_epa
    ## 81                               air_epa
    ## 82                               yac_epa
    ## 83                          comp_air_epa
    ## 84                          comp_yac_epa
    ## 85               total_home_comp_air_epa
    ## 86               total_away_comp_air_epa
    ## 87               total_home_comp_yac_epa
    ## 88               total_away_comp_yac_epa
    ## 89                total_home_raw_air_epa
    ## 90                total_away_raw_air_epa
    ## 91                total_home_raw_yac_epa
    ## 92                total_away_raw_yac_epa
    ## 93                                    wp
    ## 94                                def_wp
    ## 95                               home_wp
    ## 96                               away_wp
    ## 97                                   wpa
    ## 98                             vegas_wpa
    ## 99                        vegas_home_wpa
    ## 100                         home_wp_post
    ## 101                         away_wp_post
    ## 102                             vegas_wp
    ## 103                        vegas_home_wp
    ## 104                  total_home_rush_wpa
    ## 105                  total_away_rush_wpa
    ## 106                  total_home_pass_wpa
    ## 107                  total_away_pass_wpa
    ## 108                              air_wpa
    ## 109                              yac_wpa
    ## 110                         comp_air_wpa
    ## 111                         comp_yac_wpa
    ## 112              total_home_comp_air_wpa
    ## 113              total_away_comp_air_wpa
    ## 114              total_home_comp_yac_wpa
    ## 115              total_away_comp_yac_wpa
    ## 116               total_home_raw_air_wpa
    ## 117               total_away_raw_air_wpa
    ## 118               total_home_raw_yac_wpa
    ## 119               total_away_raw_yac_wpa
    ## 120                         punt_blocked
    ## 121                      first_down_rush
    ## 122                      first_down_pass
    ## 123                   first_down_penalty
    ## 124                 third_down_converted
    ## 125                    third_down_failed
    ## 126                fourth_down_converted
    ## 127                   fourth_down_failed
    ## 128                      incomplete_pass
    ## 129                            touchback
    ## 130                         interception
    ## 131                   punt_inside_twenty
    ## 132                      punt_in_endzone
    ## 133                   punt_out_of_bounds
    ## 134                          punt_downed
    ## 135                      punt_fair_catch
    ## 136                kickoff_inside_twenty
    ## 137                   kickoff_in_endzone
    ## 138                kickoff_out_of_bounds
    ## 139                       kickoff_downed
    ## 140                   kickoff_fair_catch
    ## 141                        fumble_forced
    ## 142                    fumble_not_forced
    ## 143                 fumble_out_of_bounds
    ## 144                          solo_tackle
    ## 145                               safety
    ## 146                              penalty
    ## 147                     tackled_for_loss
    ## 148                          fumble_lost
    ## 149                 own_kickoff_recovery
    ## 150              own_kickoff_recovery_td
    ## 151                               qb_hit
    ## 152                         rush_attempt
    ## 153                         pass_attempt
    ## 154                                 sack
    ## 155                            touchdown
    ## 156                       pass_touchdown
    ## 157                       rush_touchdown
    ## 158                     return_touchdown
    ## 159                  extra_point_attempt
    ## 160                    two_point_attempt
    ## 161                   field_goal_attempt
    ## 162                      kickoff_attempt
    ## 163                         punt_attempt
    ## 164                               fumble
    ## 165                        complete_pass
    ## 166                        assist_tackle
    ## 167                    lateral_reception
    ## 168                         lateral_rush
    ## 169                       lateral_return
    ## 170                     lateral_recovery
    ## 171                     passer_player_id
    ## 172                   passer_player_name
    ## 173                        passing_yards
    ## 174                   receiver_player_id
    ## 175                 receiver_player_name
    ## 176                      receiving_yards
    ## 177                     rusher_player_id
    ## 178                   rusher_player_name
    ## 179                        rushing_yards
    ## 180           lateral_receiver_player_id
    ## 181         lateral_receiver_player_name
    ## 182              lateral_receiving_yards
    ## 183             lateral_rusher_player_id
    ## 184           lateral_rusher_player_name
    ## 185                lateral_rushing_yards
    ## 186               lateral_sack_player_id
    ## 187             lateral_sack_player_name
    ## 188               interception_player_id
    ## 189             interception_player_name
    ## 190       lateral_interception_player_id
    ## 191     lateral_interception_player_name
    ## 192              punt_returner_player_id
    ## 193            punt_returner_player_name
    ## 194      lateral_punt_returner_player_id
    ## 195    lateral_punt_returner_player_name
    ## 196         kickoff_returner_player_name
    ## 197           kickoff_returner_player_id
    ## 198   lateral_kickoff_returner_player_id
    ## 199 lateral_kickoff_returner_player_name
    ## 200                     punter_player_id
    ## 201                   punter_player_name
    ## 202                   kicker_player_name
    ## 203                     kicker_player_id
    ## 204       own_kickoff_recovery_player_id
    ## 205     own_kickoff_recovery_player_name
    ## 206                    blocked_player_id
    ## 207                  blocked_player_name
    ## 208          tackle_for_loss_1_player_id
    ## 209        tackle_for_loss_1_player_name
    ## 210          tackle_for_loss_2_player_id
    ## 211        tackle_for_loss_2_player_name
    ## 212                   qb_hit_1_player_id
    ## 213                 qb_hit_1_player_name
    ## 214                   qb_hit_2_player_id
    ## 215                 qb_hit_2_player_name
    ## 216          forced_fumble_player_1_team
    ## 217     forced_fumble_player_1_player_id
    ## 218   forced_fumble_player_1_player_name
    ## 219          forced_fumble_player_2_team
    ## 220     forced_fumble_player_2_player_id
    ## 221   forced_fumble_player_2_player_name
    ## 222                   solo_tackle_1_team
    ## 223                   solo_tackle_2_team
    ## 224              solo_tackle_1_player_id
    ## 225              solo_tackle_2_player_id
    ## 226            solo_tackle_1_player_name
    ## 227            solo_tackle_2_player_name
    ## 228            assist_tackle_1_player_id
    ## 229          assist_tackle_1_player_name
    ## 230                 assist_tackle_1_team
    ## 231            assist_tackle_2_player_id
    ## 232          assist_tackle_2_player_name
    ## 233                 assist_tackle_2_team
    ## 234            assist_tackle_3_player_id
    ## 235          assist_tackle_3_player_name
    ## 236                 assist_tackle_3_team
    ## 237            assist_tackle_4_player_id
    ## 238          assist_tackle_4_player_name
    ## 239                 assist_tackle_4_team
    ## 240                   tackle_with_assist
    ## 241       tackle_with_assist_1_player_id
    ## 242     tackle_with_assist_1_player_name
    ## 243            tackle_with_assist_1_team
    ## 244       tackle_with_assist_2_player_id
    ## 245     tackle_with_assist_2_player_name
    ## 246            tackle_with_assist_2_team
    ## 247             pass_defense_1_player_id
    ## 248           pass_defense_1_player_name
    ## 249             pass_defense_2_player_id
    ## 250           pass_defense_2_player_name
    ## 251                       fumbled_1_team
    ## 252                  fumbled_1_player_id
    ## 253                fumbled_1_player_name
    ## 254                  fumbled_2_player_id
    ## 255                fumbled_2_player_name
    ## 256                       fumbled_2_team
    ## 257               fumble_recovery_1_team
    ## 258              fumble_recovery_1_yards
    ## 259          fumble_recovery_1_player_id
    ## 260        fumble_recovery_1_player_name
    ## 261               fumble_recovery_2_team
    ## 262              fumble_recovery_2_yards
    ## 263          fumble_recovery_2_player_id
    ## 264        fumble_recovery_2_player_name
    ## 265                       sack_player_id
    ## 266                     sack_player_name
    ## 267                half_sack_1_player_id
    ## 268              half_sack_1_player_name
    ## 269                half_sack_2_player_id
    ## 270              half_sack_2_player_name
    ## 271                          return_team
    ## 272                         return_yards
    ## 273                         penalty_team
    ## 274                    penalty_player_id
    ## 275                  penalty_player_name
    ## 276                        penalty_yards
    ## 277                  replay_or_challenge
    ## 278           replay_or_challenge_result
    ## 279                         penalty_type
    ## 280          defensive_two_point_attempt
    ## 281             defensive_two_point_conv
    ## 282        defensive_extra_point_attempt
    ## 283           defensive_extra_point_conv
    ## 284                   safety_player_name
    ## 285                     safety_player_id
    ## 286                               season
    ## 287                                   cp
    ## 288                                 cpoe
    ## 289                               series
    ## 290                       series_success
    ## 291                        series_result
    ## 292                       order_sequence
    ## 293                           start_time
    ## 294                          time_of_day
    ## 295                              stadium
    ## 296                              weather
    ## 297                           nfl_api_id
    ## 298                           play_clock
    ## 299                         play_deleted
    ## 300                        play_type_nfl
    ## 301                   special_teams_play
    ## 302                         st_play_type
    ## 303                       end_clock_time
    ## 304                        end_yard_line
    ## 305                          fixed_drive
    ## 306                   fixed_drive_result
    ## 307                drive_real_start_time
    ## 308                     drive_play_count
    ## 309             drive_time_of_possession
    ## 310                    drive_first_downs
    ## 311                       drive_inside20
    ## 312               drive_ended_with_score
    ## 313                  drive_quarter_start
    ## 314                    drive_quarter_end
    ## 315                drive_yards_penalized
    ## 316               drive_start_transition
    ## 317                 drive_end_transition
    ## 318               drive_game_clock_start
    ## 319                 drive_game_clock_end
    ## 320                drive_start_yard_line
    ## 321                  drive_end_yard_line
    ## 322                drive_play_id_started
    ## 323                  drive_play_id_ended
    ## 324                           away_score
    ## 325                           home_score
    ## 326                             location
    ## 327                               result
    ## 328                                total
    ## 329                          spread_line
    ## 330                           total_line
    ## 331                             div_game
    ## 332                                 roof
    ## 333                              surface
    ## 334                                 temp
    ## 335                                 wind
    ## 336                           home_coach
    ## 337                           away_coach
    ## 338                           stadium_id
    ## 339                         game_stadium
    ## 340                              success
    ## 341                               passer
    ## 342                 passer_jersey_number
    ## 343                               rusher
    ## 344                 rusher_jersey_number
    ## 345                             receiver
    ## 346               receiver_jersey_number
    ## 347                                 pass
    ## 348                                 rush
    ## 349                           first_down
    ## 350                         aborted_play
    ## 351                              special
    ## 352                                 play
    ## 353                            passer_id
    ## 354                            rusher_id
    ## 355                          receiver_id
    ## 356                                 name
    ## 357                        jersey_number
    ## 358                                   id
    ## 359                  fantasy_player_name
    ## 360                    fantasy_player_id
    ## 361                              fantasy
    ## 362                           fantasy_id
    ## 363                        out_of_bounds
    ## 364                 home_opening_kickoff
    ## 365                               qb_epa
    ## 366                             xyac_epa
    ## 367                    xyac_mean_yardage
    ## 368                  xyac_median_yardage
    ## 369                         xyac_success
    ## 370                              xyac_fd
    ## 371                                xpass
    ## 372                              pass_oe
    ##                                                                                                                                                                                                                                                                                                                                               Description
    ## 1                                                                                                                                                                                                                                                 Numeric play id that when used with game_id and drive provides the unique identifier for a single play.
    ## 2                                                                                                                                                                                                                                                                                                                      Ten digit identifier for NFL game.
    ## 3                                                                                                                                                                                                                                                                                                                                     Legacy NFL game ID.
    ## 4                                                                                                                                                                                                                                                                                                                  String abbreviation for the home team.
    ## 5                                                                                                                                                                                                                                                                                                                  String abbreviation for the away team.
    ## 6                                                                                                                                                                                                                                                                               'REG' or 'POST' indicating if the game belongs to regular or post season.
    ## 7                                                                                                                                                                                                                                                                                                                                            Season week.
    ## 8                                                                                                                                                                                                                                                                                                       String abbreviation for the team with possession.
    ## 9                                                                                                                                                                                                                                                                                             String indicating whether the posteam team is home or away.
    ## 10                                                                                                                                                                                                                                                                                                           String abbreviation for the team on defense.
    ## 11                                                                                                                                                                                                                                                       String abbreviation for which team's side of the field the team with possession is currently on.
    ## 12                                                                                                                                                                                                                                                                   Numeric distance in the number of yards from the opponent's endzone for the posteam.
    ## 13                                                                                                                                                                                                                                                                                                                                      Date of the game.
    ## 14                                                                                                                                                                                                                                                                                                              Numeric seconds remaining in the quarter.
    ## 15                                                                                                                                                                                                                                                                                                                 Numeric seconds remaining in the half.
    ## 16                                                                                                                                                                                                                                                                                                                 Numeric seconds remaining in the game.
    ## 17                                                                                                                                                                                                                                                                         String indicating which half the play is in, either Half1, Half2, or Overtime.
    ## 18                                                                                                                                                                                                                                                               Binary indicator for whether or not the row of the data is marking the end of a quarter.
    ## 19                                                                                                                                                                                                                                                                                                                      Numeric drive number in the game.
    ## 20                                                                                                                                                                                                                                                                                      Binary indicator for whether or not a score occurred on the play.
    ## 21                                                                                                                                                                                                                                                                                                                   Quarter of the game (5 is overtime).
    ## 22                                                                                                                                                                                                                                                                                                                           The down for the given play.
    ## 23                                                                                                                                                                                                                                                                           Binary indicator for whether or not the posteam is in a goal down situation.
    ## 24                                                                                                                                                                                                                                                           Time at start of play provided in string format as minutes:seconds remaining in the quarter.
    ## 25                                                                                                                                                                                                                                                                                         String indicating the current field position for a given play.
    ## 26                                                                                                                                                                                                                                                    Numeric yards in distance from either the first down marker or the endzone in goal down situations.
    ## 27                                                                                                                                                                                                                                                                                               Numeric value for total yards gained on the given drive.
    ## 28                                                                                                                                                                                                                                                                                                        Detailed string description for the given play.
    ## 29                                                                                                                        String indicating the type of play: pass (includes sacks), run (includes scrambles), punt, field_goal, kickoff, extra_point, qb_kneel, qb_spike, no_play (timeouts and penalties), and missing for rows indicating end of play.
    ## 30                                                                                                                                                                                                                                      Numeric yards gained (or lost) by the possessing team, excluding yards gained via fumble recoveries and laterals.
    ## 31                                                                                                                                                                                                                                                                                 Binary indicator for whether or not the play was in shotgun formation.
    ## 32                                                                                                                                                                                                                                                                               Binary indicator for whether or not the play was in no_huddle formation.
    ## 33                                                                                                                                                                                                                                                Binary indicator for whether or not the QB dropped back on the play (pass attempt, sack, or scrambled).
    ## 34                                                                                                                                                                                                                                                                                                Binary indicator for whether or not the QB took a knee.
    ## 35                                                                                                                                                                                                                                                                                            Binary indicator for whether or not the QB spiked the ball.
    ## 36                                                                                                                                                                                                                                                                                                  Binary indicator for whether or not the QB scrambled.
    ## 37                                                                                                                                                                                                                                                                                                       String indicator for pass length: short or deep.
    ## 38                                                                                                                                                                                                                                                                                            String indicator for pass location: left, middle, or right.
    ## 39                                                                                                                                                                                                      Numeric value for distance in yards perpendicular to the line of scrimmage at where the targeted receiver either caught or didn't catch the ball.
    ## 40                                                                                                                                                                                                                      Numeric value for distance in yards perpendicular to the yard line where the receiver made the reception to where the play ended.
    ## 41                                                                                                                                                                                                                                                                                          String indicator for location of run: left, middle, or right.
    ## 42                                                                                                                                                                                                                                                                                            String indicator for line gap of run: end, guard, or tackle
    ## 43                                                                                                                                                                                                                                                                           String indicator for result of field goal attempt: made, missed, or blocked.
    ## 44                                                                                                                                                                                                                                                                                        Numeric distance in yards for kickoffs, field goals, and punts.
    ## 45                                                                                                                                                                                          String indicator for the result of the extra point attempt: good, failed, blocked, safety (touchback in defensive endzone is 1 point apparently), or aborted.
    ## 46                                                                                                                                                                                               String indicator for result of two point conversion attempt: success, failure, safety (touchback in defensive endzone is 1 point apparently), or return.
    ## 47                                                                                                                                                                                                                                                                                              Numeric timeouts remaining in the half for the home team.
    ## 48                                                                                                                                                                                                                                                                                              Numeric timeouts remaining in the half for the away team.
    ## 49                                                                                                                                                                                                                                                                               Binary indicator for whether or not a timeout was called by either team.
    ## 50                                                                                                                                                                                                                                                                                                 String abbreviation for which team called the timeout.
    ## 51                                                                                                                                                                                                                                                                                               String abbreviation for which team scored the touchdown.
    ## 52                                                                                                                                                                                                                                                                                                      String name of the player who scored a touchdown.
    ## 53                                                                                                                                                                                                                                                                                                Unique identifier of the player who scored a touchdown.
    ## 54                                                                                                                                                                                                                                                                                                  Number of timeouts remaining for the possession team.
    ## 55                                                                                                                                                                                                                                                                                                  Number of timeouts remaining for the team on defense.
    ## 56                                                                                                                                                                                                                                                                                                      Score for the home team at the start of the play.
    ## 57                                                                                                                                                                                                                                                                                                      Score for the away team at the start of the play.
    ## 58                                                                                                                                                                                                                                                                                                            Score the posteam at the start of the play.
    ## 59                                                                                                                                                                                                                                                                                                            Score the defteam at the start of the play.
    ## 60                                                                                                                                                                                                                                                                           Score differential between the posteam and defteam at the start of the play.
    ## 61                                                                                                                                                                                                                                                                                                          Score for the posteam at the end of the play.
    ## 62                                                                                                                                                                                                                                                                                                          Score for the defteam at the end of the play.
    ## 63                                                                                                                                                                                                                                                                             Score differential between the posteam and defteam at the end of the play.
    ## 64                                                                                                                                                                                                                                               Predicted probability of no score occurring for the rest of the half based on the expected points model.
    ## 65                                                                                                                                                                                                                                                                                                Predicted probability of the defteam scoring a FG next.
    ## 66                                                                                                                                                                                                                                                                                            Predicted probability of the defteam scoring a safety next.
    ## 67                                                                                                                                                                                                                                                                                                Predicted probability of the defteam scoring a TD next.
    ## 68                                                                                                                                                                                                                                                                                                Predicted probability of the posteam scoring a FG next.
    ## 69                                                                                                                                                                                                                                                                                            Predicted probability of the posteam scoring a safety next.
    ## 70                                                                                                                                                                                                                                                                                                Predicted probability of the posteam scoring a TD next.
    ## 71                                                                                                                                                                                                                                                                                           Predicted probability of the posteam scoring an extra point.
    ## 72                                                                                                                                                                                                                                                                                 Predicted probability of the posteam scoring the two point conversion.
    ## 73                                                                                                                                                                                                                           Using the scoring event probabilities, the estimated expected points with respect to the possession team for the given play.
    ## 74                                                                                                                                                                                                                                                                                         Expected points added (EPA) by the posteam for the given play.
    ## 75                                                                                                                                                                                                                                                                                             Cumulative total EPA for the home team in the game so far.
    ## 76                                                                                                                                                                                                                                                                                             Cumulative total EPA for the away team in the game so far.
    ## 77                                                                                                                                                                                                                                                                                     Cumulative total rushing EPA for the home team in the game so far.
    ## 78                                                                                                                                                                                                                                                                                     Cumulative total rushing EPA for the away team in the game so far.
    ## 79                                                                                                                                                                                                                                                                                     Cumulative total passing EPA for the home team in the game so far.
    ## 80                                                                                                                                                                                                                                                                                     Cumulative total passing EPA for the away team in the game so far.
    ## 81                                                                                                                  EPA from the air yards alone. For completions this represents the actual value provided through the air. For incompletions this represents the hypothetical value that could've been added through the air if the pass was completed.
    ## 82                                                                    EPA from the yards after catch alone. For completions this represents the actual value provided after the catch. For incompletions this represents the difference between the hypothetical air_epa and the play's raw observed EPA (how much the incomplete pass cost the posteam).
    ## 83                                                                                                                                                                                                                                                                                                     EPA from the air yards alone only for completions.
    ## 84                                                                                                                                                                                                                                                                                             EPA from the yards after catch alone only for completions.
    ## 85                                                                                                                                                                                                                                                                             Cumulative total completions air EPA for the home team in the game so far.
    ## 86                                                                                                                                                                                                                                                                             Cumulative total completions air EPA for the away team in the game so far.
    ## 87                                                                                                                                                                                                                                                                             Cumulative total completions yac EPA for the home team in the game so far.
    ## 88                                                                                                                                                                                                                                                                             Cumulative total completions yac EPA for the away team in the game so far.
    ## 89                                                                                                                                                                                                                                                                                     Cumulative total raw air EPA for the home team in the game so far.
    ## 90                                                                                                                                                                                                                                                                                     Cumulative total raw air EPA for the away team in the game so far.
    ## 91                                                                                                                                                                                                                                                                                     Cumulative total raw yac EPA for the home team in the game so far.
    ## 92                                                                                                                                                                                                                                                                                     Cumulative total raw yac EPA for the away team in the game so far.
    ## 93                                                                                                                                                                                                                                                   Estimated win probabiity for the posteam given the current situation at the start of the given play.
    ## 94                                                                                                                                                                                                                                                                                                             Estimated win probability for the defteam.
    ## 95                                                                                                                                                                                                                                                                                                           Estimated win probability for the home team.
    ## 96                                                                                                                                                                                                                                                                                                           Estimated win probability for the away team.
    ## 97                                                                                                                                                                                                                                                                                                           Win probability added (WPA) for the posteam.
    ## 98                                                                                                                                                                                                                                                                                    Win probability added (WPA) for the posteam: spread_adjusted model.
    ## 99                                                                                                                                                                                                                                                                                  Win probability added (WPA) for the home team: spread_adjusted model.
    ## 100                                                                                                                                                                                                                                                                                   Estimated win probability for the home team at the end of the play.
    ## 101                                                                                                                                                                                                                                                                                   Estimated win probability for the away team at the end of the play.
    ## 102                                                                                                                                                                                                               Estimated win probabiity for the posteam given the current situation at the start of the given play, incorporating pre-game Vegas line.
    ## 103                                                                                                                                                                                                                                                                        Estimated win probability for the home team incorporating pre-game Vegas line.
    ## 104                                                                                                                                                                                                                                                                                    Cumulative total rushing WPA for the home team in the game so far.
    ## 105                                                                                                                                                                                                                                                                                    Cumulative total rushing WPA for the away team in the game so far.
    ## 106                                                                                                                                                                                                                                                                                    Cumulative total passing WPA for the home team in the game so far.
    ## 107                                                                                                                                                                                                                                                                                    Cumulative total passing WPA for the away team in the game so far.
    ## 108                                                                                                                                                                                                                                                                                                          WPA through the air (same logic as air_epa).
    ## 109                                                                                                                                                                                                                                                                                               WPA from yards after the catch (same logic as yac_epa).
    ## 110                                                                                                                                                                                                                                                                                                                     The air_wpa for completions only.
    ## 111                                                                                                                                                                                                                                                                                                                     The yac_wpa for completions only.
    ## 112                                                                                                                                                                                                                                                                            Cumulative total completions air WPA for the home team in the game so far.
    ## 113                                                                                                                                                                                                                                                                            Cumulative total completions air WPA for the away team in the game so far.
    ## 114                                                                                                                                                                                                                                                                            Cumulative total completions yac WPA for the home team in the game so far.
    ## 115                                                                                                                                                                                                                                                                            Cumulative total completions yac WPA for the away team in the game so far.
    ## 116                                                                                                                                                                                                                                                                                    Cumulative total raw air WPA for the home team in the game so far.
    ## 117                                                                                                                                                                                                                                                                                    Cumulative total raw air WPA for the away team in the game so far.
    ## 118                                                                                                                                                                                                                                                                                    Cumulative total raw yac WPA for the home team in the game so far.
    ## 119                                                                                                                                                                                                                                                                                    Cumulative total raw yac WPA for the away team in the game so far.
    ## 120                                                                                                                                                                                                                                                                                                         Binary indicator for if the punt was blocked.
    ## 121                                                                                                                                                                                                                                                                                      Binary indicator for if a running play converted the first down.
    ## 122                                                                                                                                                                                                                                                                                      Binary indicator for if a passing play converted the first down.
    ## 123                                                                                                                                                                                                                                                                                           Binary indicator for if a penalty converted the first down.
    ## 124                                                                                                                                                                                                                                                                                   Binary indicator for if the first down was converted on third down.
    ## 125                                                                                                                                                                                                                                                                       Binary indicator for if the posteam failed to convert first down on third down.
    ## 126                                                                                                                                                                                                                                                                                  Binary indicator for if the first down was converted on fourth down.
    ## 127                                                                                                                                                                                                                                                                      Binary indicator for if the posteam failed to convert first down on fourth down.
    ## 128                                                                                                                                                                                                                                                                                                      Binary indicator for if the pass was incomplete.
    ## 129                                                                                                                                                                                                                                                                                             Binary indicator for if a touchback occurred on the play.
    ## 130                                                                                                                                                                                                                                                                                                     Binary indicator for if the pass was intercepted.
    ## 131                                                                                                                                                                                                                                                                                   Binary indicator for if the punt ended inside the twenty yard line.
    ## 132                                                                                                                                                                                                                                                                                                  Binary indicator for if the punt was in the endzone.
    ## 133                                                                                                                                                                                                                                                                                                  Binary indicator for if the punt went out of bounds.
    ## 134                                                                                                                                                                                                                                                                                                          Binary indicator for if the punt was downed.
    ## 135                                                                                                                                                                                                                                                                                        Binary indicator for if the punt was caught with a fair catch.
    ## 136                                                                                                                                                                                                                                                                                Binary indicator for if the kickoff ended inside the twenty yard line.
    ## 137                                                                                                                                                                                                                                                                                               Binary indicator for if the kickoff was in the endzone.
    ## 138                                                                                                                                                                                                                                                                                               Binary indicator for if the kickoff went out of bounds.
    ## 139                                                                                                                                                                                                                                                                                                       Binary indicator for if the kickoff was downed.
    ## 140                                                                                                                                                                                                                                                                                     Binary indicator for if the kickoff was caught with a fair catch.
    ## 141                                                                                                                                                                                                                                                                                                        Binary indicator for if the fumble was forced.
    ## 142                                                                                                                                                                                                                                                                                                    Binary indicator for if the fumble was not forced.
    ## 143                                                                                                                                                                                                                                                                                                Binary indicator for if the fumble went out of bounds.
    ## 144                                                                                                                                                                                                                                                                    Binary indicator if the play had a solo tackle (could be multiple due to fumbles).
    ## 145                                                                                                                                                                                                                                                                                                Binary indicator for whether or not a safety occurred.
    ## 146                                                                                                                                                                                                                                                                                               Binary indicator for whether or not a penalty occurred.
    ## 147                                                                                                                                                                                                                                                                         Binary indicator for whether or not a tackle for loss on a run play occurred.
    ## 148                                                                                                                                                                                                                                                                                                          Binary indicator for if the fumble was lost.
    ## 149                                                                                                                                                                                                                                                                                       Binary indicator for if the kicking team recovered the kickoff.
    ## 150                                                                                                                                                                                                                                                                       Binary indicator for if the kicking team recovered the kickoff and scored a TD.
    ## 151                                                                                                                                                                                                                                                                                                       Binary indicator if the QB was hit on the play.
    ## 152                                                                                                                                                                                                                                                                                                           Binary indicator for if the play was a run.
    ## 153                                                                                                                                                                                                                                                                                 Binary indicator for if the play was a pass attempt (includes sacks).
    ## 154                                                                                                                                                                                                                                                                                                     Binary indicator for if the play ended in a sack.
    ## 155                                                                                                                                                                                                                                                                                                    Binary indicator for if the play resulted in a TD.
    ## 156                                                                                                                                                                                                                                                                                            Binary indicator for if the play resulted in a passing TD.
    ## 157                                                                                                                                                                                                                                                                                            Binary indicator for if the play resulted in a rushing TD.
    ## 158                                                                                                                                                                                                         Binary indicator for if the play resulted in a return TD. Returns may occur on any of: interception, fumble, kickoff, punt, or blocked kicks.
    ## 159                                                                                                                                                                                                                                                                                                             Binary indicator for extra point attempt.
    ## 160                                                                                                                                                                                                                                                                                                    Binary indicator for two point conversion attempt.
    ## 161                                                                                                                                                                                                                                                                                                              Binary indicator for field goal attempt.
    ## 162                                                                                                                                                                                                                                                                                                                         Binary indicator for kickoff.
    ## 163                                                                                                                                                                                                                                                                                                                           Binary indicator for punts.
    ## 164                                                                                                                                                                                                                                                                                                            Binary indicator for if a fumble occurred.
    ## 165                                                                                                                                                                                                                                                                                                       Binary indicator for if the pass was completed.
    ## 166                                                                                                                                                                                                                                                                                                    Binary indicator for if an assist tackle occurred.
    ## 167                                                                                                                                                                                                                                                                                          Binary indicator for if a lateral occurred on the reception.
    ## 168                                                                                                                                                                                                                                                                                                  Binary indicator for if a lateral occurred on a run.
    ## 169                                                                                                                                                                                                           Binary indicator for if a lateral occurred on a return. Returns may occur on any of: interception, fumble, kickoff, punt, or blocked kicks.
    ## 170                                                                                                                                                                                                                                                                                      Binary indicator for if a lateral occurred on a fumble recovery.
    ## 171                                                                                                                                                                                                                                                                                             Unique identifier for the player that attempted the pass.
    ## 172                                                                                                                                                                                                                                                                                                   String name for the player that attempted the pass.
    ## 173                                                                                                                                                                                                           Numeric yards by the passer_player_name, including yards gained in pass plays with laterals. This should equal official passing statistics.
    ## 174                                                                                                                                                                                                                                                                                     Unique identifier for the receiver that was targeted on the pass.
    ## 175                                                                                                                                                                                                                                                                                                                String name for the targeted receiver.
    ## 176                                                         Numeric yards by the receiver_player_name, excluding yards gained in pass plays with laterals. This should equal official receiving statistics but could miss yards gained in pass plays with laterals. Please see the description of `lateral_receiver_player_name` for further information.
    ## 177                                                                                                                                                                                                                                                                                              Unique identifier for the player that attempted the run.
    ## 178                                                                                                                                                                                                                                                                                                    String name for the player that attempted the run.
    ## 179                                                               Numeric yards by the rusher_player_name, excluding yards gained in rush plays with laterals. This should equal official rushing statistics but could miss yards gained in rush plays with laterals. Please see the description of `lateral_rusher_player_name` for further information.
    ## 180                                                                                                                                                                                                                                                                    Unique identifier for the player that received the last(!) lateral on a pass play.
    ## 181 String name for the player that received the last(!) lateral on a pass play. If there were multiple laterals in the same play, this will only be the last player who received a lateral. Please see <https://github.com/mrcaseb/nfl-data/tree/master/data/lateral_yards> for a list of plays where multiple players recorded lateral receiving yards.
    ## 182                                                                                                                                                                                Numeric yards by the `lateral_receiver_player_name` in pass plays with laterals. Please see the description of `lateral_receiver_player_name` for further information.
    ## 183                                                                                                                                                                                                                                                                     Unique identifier for the player that received the last(!) lateral on a run play.
    ## 184    String name for the player that received the last(!) lateral on a run play. If there were multiple laterals in the same play, this will only be the last player who received a lateral. Please see <https://github.com/mrcaseb/nfl-data/tree/master/data/lateral_yards> for a list of plays where multiple players recorded lateral rushing yards.
    ## 185                                                                                                                                                                                     Numeric yards by the `lateral_rusher_player_name` in run plays with laterals. Please see the description of `lateral_rusher_player_name` for further information.
    ## 186                                                                                                                                                                                                                                                                                 Unique identifier for the player that received the lateral on a sack.
    ## 187                                                                                                                                                                                                                                                                                       String name for the player that received the lateral on a sack.
    ## 188                                                                                                                                                                                                                                                                                           Unique identifier for the player that intercepted the pass.
    ## 189                                                                                                                                                                                                                                                                                                 String name for the player that intercepted the pass.
    ## 190                                                                                                                                                                                                                                                                       Unique indentifier for the player that received the lateral on an interception.
    ## 191                                                                                                                                                                                                                                                                              String name for the player that received the lateral on an interception.
    ## 192                                                                                                                                                                                                                                                                                                              Unique identifier for the punt returner.
    ## 193                                                                                                                                                                                                                                                                                                                    String name for the punt returner.
    ## 194                                                                                                                                                                                                                                                                          Unique identifier for the player that received the lateral on a punt return.
    ## 195                                                                                                                                                                                                                                                                                String name for the player that received the lateral on a punt return.
    ## 196                                                                                                                                                                                                                                                                                                                 String name for the kickoff returner.
    ## 197                                                                                                                                                                                                                                                                                                           Unique identifier for the kickoff returner.
    ## 198                                                                                                                                                                                                                                                                       Unique identifier for the player that received the lateral on a kickoff return.
    ## 199                                                                                                                                                                                                                                                                             String name for the player that received the lateral on a kickoff return.
    ## 200                                                                                                                                                                                                                                                                                                                     Unique identifier for the punter.
    ## 201                                                                                                                                                                                                                                                                                                                           String name for the punter.
    ## 202                                                                                                                                                                                                                                                                                                          String name for the kicker on FG or kickoff.
    ## 203                                                                                                                                                                                                                                                                                                    Unique identifier for the kicker on FG or kickoff.
    ## 204                                                                                                                                                                                                                                                                                    Unique identifier for the player that recovered their own kickoff.
    ## 205                                                                                                                                                                                                                                                                                          String name for the player that recovered their own kickoff.
    ## 206                                                                                                                                                                                                                                                                                         Unique identifier for the player that blocked the punt or FG.
    ## 207                                                                                                                                                                                                                                                                                               String name for the player that blocked the punt or FG.
    ## 208                                                                                                                                                                                                                                                                          Unique identifier for one of the potential players with the tackle for loss.
    ## 209                                                                                                                                                                                                                                                                                String name for one of the potential players with the tackle for loss.
    ## 210                                                                                                                                                                                                                                                                          Unique identifier for one of the potential players with the tackle for loss.
    ## 211                                                                                                                                                                                                                                                                                String name for one of the potential players with the tackle for loss.
    ## 212                                                                                                                                                                           Unique identifier for one of the potential players that hit the QB. No sack as the QB was not the ball carrier. For sacks please see `sack_player` or `half_sack_*_player`.
    ## 213                                                                                                                                                                                 String name for one of the potential players that hit the QB. No sack as the QB was not the ball carrier. For sacks please see `sack_player` or `half_sack_*_player`.
    ## 214                                                                                                                                                                           Unique identifier for one of the potential players that hit the QB. No sack as the QB was not the ball carrier. For sacks please see `sack_player` or `half_sack_*_player`.
    ## 215                                                                                                                                                                                 String name for one of the potential players that hit the QB. No sack as the QB was not the ball carrier. For sacks please see `sack_player` or `half_sack_*_player`.
    ## 216                                                                                                                                                                                                                                                                                                      Team of one of the players with a forced fumble.
    ## 217                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a forced fumble.
    ## 218                                                                                                                                                                                                                                                                                               String name of one of the players with a forced fumble.
    ## 219                                                                                                                                                                                                                                                                                                      Team of one of the players with a forced fumble.
    ## 220                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a forced fumble.
    ## 221                                                                                                                                                                                                                                                                                               String name of one of the players with a forced fumble.
    ## 222                                                                                                                                                                                                                                                                                                        Team of one of the players with a solo tackle.
    ## 223                                                                                                                                                                                                                                                                                                        Team of one of the players with a solo tackle.
    ## 224                                                                                                                                                                                                                                                                                           Unique identifier of one of the players with a solo tackle.
    ## 225                                                                                                                                                                                                                                                                                           Unique identifier of one of the players with a solo tackle.
    ## 226                                                                                                                                                                                                                                                                                                 String name of one of the players with a solo tackle.
    ## 227                                                                                                                                                                                                                                                                                                 String name of one of the players with a solo tackle.
    ## 228                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a tackle assist.
    ## 229                                                                                                                                                                                                                                                                                               String name of one of the players with a tackle assist.
    ## 230                                                                                                                                                                                                                                                                                                      Team of one of the players with a tackle assist.
    ## 231                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a tackle assist.
    ## 232                                                                                                                                                                                                                                                                                               String name of one of the players with a tackle assist.
    ## 233                                                                                                                                                                                                                                                                                                      Team of one of the players with a tackle assist.
    ## 234                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a tackle assist.
    ## 235                                                                                                                                                                                                                                                                                               String name of one of the players with a tackle assist.
    ## 236                                                                                                                                                                                                                                                                                                      Team of one of the players with a tackle assist.
    ## 237                                                                                                                                                                                                                                                                                         Unique identifier of one of the players with a tackle assist.
    ## 238                                                                                                                                                                                                                                                                                               String name of one of the players with a tackle assist.
    ## 239                                                                                                                                                                                                                                                                                                      Team of one of the players with a tackle assist.
    ## 240                                                                                                                                                                                                                                                                                          Binary indicator for if there has been a tackle with assist.
    ## 241                                                                                                                                                                                                                                                                                    Unique identifier of one of the players with a tackle with assist.
    ## 242                                                                                                                                                                                                                                                                                          String name of one of the players with a tackle with assist.
    ## 243                                                                                                                                                                                                                                                                                                 Team of one of the players with a tackle with assist.
    ## 244                                                                                                                                                                                                                                                                                    Unique identifier of one of the players with a tackle with assist.
    ## 245                                                                                                                                                                                                                                                                                          String name of one of the players with a tackle with assist.
    ## 246                                                                                                                                                                                                                                                                                                 Team of one of the players with a tackle with assist.
    ## 247                                                                                                                                                                                                                                                                                          Unique identifier of one of the players with a pass defense.
    ## 248                                                                                                                                                                                                                                                                                                String name of one of the players with a pass defense.
    ## 249                                                                                                                                                                                                                                                                                          Unique identifier of one of the players with a pass defense.
    ## 250                                                                                                                                                                                                                                                                                                String name of one of the players with a pass defense.
    ## 251                                                                                                                                                                                                                                                                                                        Team of one of the first player with a fumble.
    ## 252                                                                                                                                                                                                                                                                                        Unique identifier of the first player who fumbled on the play.
    ## 253                                                                                                                                                                                                                                                                                       String name of one of the first player who fumbled on the play.
    ## 254                                                                                                                                                                                                                                                                                       Unique identifier of the second player who fumbled on the play.
    ## 255                                                                                                                                                                                                                                                                                      String name of one of the second player who fumbled on the play.
    ## 256                                                                                                                                                                                                                                                                                                       Team of one of the second player with a fumble.
    ## 257                                                                                                                                                                                                                                                                                                    Team of one of the players with a fumble recovery.
    ## 258                                                                                                                                                                                                                                                                                            Yards gained by one of the players with a fumble recovery.
    ## 259                                                                                                                                                                                                                                                                                       Unique identifier of one of the players with a fumble recovery.
    ## 260                                                                                                                                                                                                                                                                                             String name of one of the players with a fumble recovery.
    ## 261                                                                                                                                                                                                                                                                                                    Team of one of the players with a fumble recovery.
    ## 262                                                                                                                                                                                                                                                                                            Yards gained by one of the players with a fumble recovery.
    ## 263                                                                                                                                                                                                                                                                                       Unique identifier of one of the players with a fumble recovery.
    ## 264                                                                                                                                                                                                                                                                                             String name of one of the players with a fumble recovery.
    ## 265                                                                                                                                                                                                                                                                                             Unique identifier of the player who recorded a solo sack.
    ## 266                                                                                                                                                                                                                                                                                                   String name of the player who recorded a solo sack.
    ## 267                                                                                                                                                                                                                                                                                       Unique identifier of the first player who recorded half a sack.
    ## 268                                                                                                                                                                                                                                                                                             String name of the first player who recorded half a sack.
    ## 269                                                                                                                                                                                                                                                                                      Unique identifier of the second player who recorded half a sack.
    ## 270                                                                                                                                                                                                                                                                                            String name of the second player who recorded half a sack.
    ## 271                                                                                                                                                                                                                           String abbreviation of the return team. Returns may occur on any of: interception, fumble, kickoff, punt, or blocked kicks.
    ## 272                                                                                                                                                                                                                                  Yards gained by the return team. Returns may occur on any of: interception, fumble, kickoff, punt, or blocked kicks.
    ## 273                                                                                                                                                                                                                                                                                                     String abbreviation of the team with the penalty.
    ## 274                                                                                                                                                                                                                                                                                                    Unique identifier for the player with the penalty.
    ## 275                                                                                                                                                                                                                                                                                                          String name for the player with the penalty.
    ## 276                                                                                                                                                                                                                                                                                               Yards gained (or lost) by the posteam from the penalty.
    ## 277                                                                                                                                                                                                                                                                                            Binary indicator for whether or not a replay or challenge.
    ## 278                                                                                                                                                                                                                                                                                              String indicating the result of the replay or challenge.
    ## 279                                                                                                                                                                                                                                String indicating the penalty type of the first penalty in the given play. Will be `NA` if `desc` is missing the type.
    ## 280                                                                                                                                                                                                                 Binary indicator whether or not the defense was able to have an attempt on a two point conversion, this results following a turnover.
    ## 281                                                                                                                                                                                                                                                          Binary indicator whether or not the defense successfully scored on the two point conversion.
    ## 282                                                                                                                                                                       Binary indicator whether or not the defense was able to have an attempt on an extra point attempt, this results following a blocked attempt that the defense recovers the ball.
    ## 283                                                                                                                                                                                                                                                            Binary indicator whether or not the defense successfully scored on an extra point attempt.
    ## 284                                                                                                                                                                                                                                                                                                       String name for the player who scored a safety.
    ## 285                                                                                                                                                                                                                                                                                                 Unique identifier for the player who scored a safety.
    ## 286                                                                                                                                                                                                                                                                                        4 digit number indicating to which season the game belongs to.
    ## 287                                                                                                                                                                                                                                                     Numeric value indicating the probability for a complete pass based on comparable game situations.
    ## 288                                                                                                           For a single pass play this is 1 - cp when the pass was completed or 0 - cp when the pass was incomplete. Analyzed for a whole game or season an indicator for the passer how much over or under expectation his completion percentage was.
    ## 289                                                                                                                                                                                          Starts at 1, each new first down increments, numbers shared across both teams NA: kickoffs, extra point/two point conversion attempts, non-plays, no posteam
    ## 290                                                                                                                                                                                                                                                                                              1: scored touchdown, gained enough yards for first down.
    ## 291                                                                                                                                                                                                Possible values: First down, Touchdown, Opp touchdown, Field goal, Missed field goal, Safety, Turnover, Punt, Turnover on downs, QB kneel, End of half
    ## 292                                                                                                                                                                                                                                                        Column provided by NFL to fix out-of-order plays. Available 2011 and beyond with source "nfl".
    ## 293                                                                                                                                                                                                                                                                                                                    Kickoff time in eastern time zone.
    ## 294                                                                                                                                                                                                                                                            Time of day of play in UTC "HH:MM:SS" format. Available 2011 and beyond with source "nfl".
    ## 295                                                                                                                                                                                                                                                                                                                                       Game site name.
    ## 296                                                                                                                                                                                                                         String describing the weather including temperature, humidity and wind (direction and speed). Doesn't change during the game!
    ## 297                                                                                                                                                                                                                                                                                                                  UUID of the game in the new NFL API.
    ## 298                                                                                                                                                                                                                                                                                                      Time on the playclock when the ball was snapped.
    ## 299                                                                                                                                                                                                                                                                                                                   Binary indicator for deleted plays.
    ## 300                                                                                                                                                                                                                                                          Play type as listed in the NFL source. Slightly different to the regular play_type variable.
    ## 301                                                                                                                                                                                                                                 Binary indicator for whether play is special teams play from NFL source. Available 2011 and beyond with source "nfl".
    ## 302                                                                                                                                                                                                                                                              Type of special teams play from NFL source. Available 2011 and beyond with source "nfl".
    ## 303                                                                                                                                                                                                                                                                                                                 Game time at the end of a given play.
    ## 304                                                                                                                                                                                                                                             String indicating the yardline at the end of the given play consisting of team half and yard line number.
    ## 305                                                                                                                                                                                                                                                                                                              Manually created drive number in a game.
    ## 306                                                                                                                                                                                                                                                                                                                        Manually created drive result.
    ## 307                                                                                                                                                                                                                                                      Local day time when the drive started (currently not used by the NFL and therefore mostly 'NA').
    ## 308                                                                                                                                                                                                                                                                                    Numeric value of how many regular plays happened in a given drive.
    ## 309                                                                                                                                                                                                                                                                                                                  Time of possession in a given drive.
    ## 310                                                                                                                                                                                                                                                                                                               Number of forst downs in a given drive.
    ## 311                                                                                                                                                                                                                                                                    Binary indicator if the offense was able to get inside the opponents 20 yard line.
    ## 312                                                                                                                                                                                                                                                                                                        Binary indicator the drive ended with a score.
    ## 313                                                                                                                                                                                                                                                                                Numeric value indicating in which quarter the given drive has started.
    ## 314                                                                                                                                                                                                                                                                                  Numeric value indicating in which quarter the given drive has ended.
    ## 315                                                                                                                                                                                                                                                      Numeric value of how many yards the offense gained or lost through penalties in the given drive.
    ## 316                                                                                                                                                                                                                                                                                                       String indicating how the offense got the ball.
    ## 317                                                                                                                                                                                                                                                                                                      String indicating how the offense lost the ball.
    ## 318                                                                                                                                                                                                                                                                                                          Game time at the beginning of a given drive.
    ## 319                                                                                                                                                                                                                                                                                                                Game time at the end of a given drive.
    ## 320                                                                                                                                                                                                                                                           String indicating where a given drive started consisting of team half and yard line number.
    ## 321                                                                                                                                                                                                                                                             String indicating where a given drive ended consisting of team half and yard line number.
    ## 322                                                                                                                                                                                                                                                                                                         Play_id of the first play in the given drive.
    ## 323                                                                                                                                                                                                                                                                                                          Play_id of the last play in the given drive.
    ## 324                                                                                                                                                                                                                                                                                                                 Total points scored by the away team.
    ## 325                                                                                                                                                                                                                                                                                                                 Total points scored by the home team.
    ## 326                                                                                                                                                                                                                                                            Either 'Home' o 'Neutral' indicating if the home team played at home or at a neutral site.
    ## 327                                                                                                                                                                                                                                                      Equals home_score - away_score and means the game outcome from the perspective of the home team.
    ## 328                                                                                                                                                                                                                                                                   Equals home_score + away_score and means the total points scored in the given game.
    ## 329                                                                                                                                  The closing spread line for the game. A positive number means the home team was favored by that many points, a negative number means the away team was favored by that many points. (Source: Pro-Football-Reference)
    ## 330                                                                                                                                                                                                                                                                                 The closing total line for the game. (Source: Pro-Football-Reference)
    ## 331                                                                                                                                                                                                                                                                                           Binary indicator for if the given game was a division game.
    ## 332                                                                                                                                                                                             One of 'dome', 'outdoors', 'closed', 'open' indicating indicating the roof status of the stadium the game was played in. (Source: Pro-Football-Reference)
    ## 333                                                                                                                                                                                                                                                                          What type of ground the game was played on. (Source: Pro-Football-Reference)
    ## 334                                                                                                                                                                                                                                                The temperature at the stadium only for 'roof' = 'outdoors' or 'open'.(Source: Pro-Football-Reference)
    ## 335                                                                                                                                                                                                                                          The speed of the wind in miles/hour only for 'roof' = 'outdoors' or 'open'. (Source: Pro-Football-Reference)
    ## 336                                                                                                                                                                                                                                                                          First and last name of the home team coach. (Source: Pro-Football-Reference)
    ## 337                                                                                                                                                                                                                                                                          First and last name of the away team coach. (Source: Pro-Football-Reference)
    ## 338                                                                                                                                                                                                                                                                            ID of the stadium the game was played in. (Source: Pro-Football-Reference)
    ## 339                                                                                                                                                                                                                                                                          Name of the stadium the game was played in. (Source: Pro-Football-Reference)
    ## 340                                                                                                                                                                                                                                                                                                    Binary indicator wheter epa > 0 in the given play.
    ## 341                                                                                                                                                                                                                                                                      Name of the dropback player (scrambles included) including plays with penalties.
    ## 342                                                                                                                                                                                                                                                                                                                          Jersey number of the passer.
    ## 343                                                                                                                                                                                                                                                                                     Name of the rusher (no scrambles) including plays with penalties.
    ## 344                                                                                                                                                                                                                                                                                                                          Jersey number of the rusher.
    ## 345                                                                                                                                                                                                                                                                                                  Name of the receiver including plays with penalties.
    ## 346                                                                                                                                                                                                                                                                                                                        Jersey number of the receiver.
    ## 347                                                                                                                                                                                                                                                                          Binary indicator if the play was a pass play (sacks and scrambles included).
    ## 348                                                                                                                                                                                                                                                                                                      Binary indicator if the play was a rushing play.
    ## 349                                                                                                                                                                                                                                                                                                   Binary indicator if the play ended in a first down.
    ## 350                                                                                                                                                                                                                                                                                         Binary indicator if the play description indicates "Aborted".
    ## 351                                                                                                                                                                                                                                                          Binary indicator if "play_type" is one of "extra_point", "field_goal", "kickoff", or "punt".
    ## 352                                                                                                                                                                                                                                                               Binary indicator: 1 if the play was a 'normal' play (including penalties), 0 otherwise.
    ## 353                                                                                                                                                                                                                                                                                                              ID of the player in the 'passer' column.
    ## 354                                                                                                                                                                                                                                                                                                              ID of the player in the 'rusher' column.
    ## 355                                                                                                                                                                                                                                                                                                            ID of the player in the 'receiver' column.
    ## 356                                                                                                                                                                                                                                                                            Name of the 'passer' if it is not 'NA', or name of the 'rusher' otherwise.
    ## 357                                                                                                                                                                                                                                                                                              Jersey number of the player listed in the 'name' column.
    ## 358                                                                                                                                                                                                                                                                                                                ID of the player in the 'name' column.
    ## 359                                                                                                                                                                                                                                                                     Name of the rusher on rush plays or receiver on pass plays (from official stats).
    ## 360                                                                                                                                                                                                                                                                       ID of the rusher on rush plays or receiver on pass plays (from official stats).
    ## 361                                                                                                                                                                                                                                                                                           Name of the rusher on rush plays or receiver on pass plays.
    ## 362                                                                                                                                                                                                                                                                                             ID of the rusher on rush plays or receiver on pass plays.
    ## 363                                                                                                                                                                                                                                                                          1 if play description contains ran ob, pushed ob, or sacked ob; 0 otherwise.
    ## 364                                                                                                                                                                                                                                                                                         1 if the home team received the opening kickoff, 0 otherwise.
    ## 365                                                                                                                                                                                  Gives QB credit for EPA for up to the point where a receiver lost a fumble after a completed catch and makes EPA work more like passing yards on plays with fumbles.
    ## 366                                                                                                                                                                                                         Expected value of EPA gained after the catch, starting from where the catch was made. Zero yards after the catch would be listed as zero EPA.
    ## 367                                                                                                                                                                                                                                                                            Average expected yards after the catch based on where the ball was caught.
    ## 368                                                                                                                                                                                                                                                                             Median expected yards after the catch based on where the ball was caught.
    ## 369                                                                                                                                                                                                                                                  Probability play earns positive EPA (relative to where play started) based on where ball was caught.
    ## 370                                                                                                                                                                                                                                                                               Probability play earns a first down based on where the ball was caught.
    ## 371                                                                                                                                                                                                                                                                                                           Probability of dropback scaled from 0 to 1.
    ## 372                                                                                                                                                                                                                                                                                  Dropback percent over expected on a given play scaled from 0 to 100.
    ##          Type
    ## 1     numeric
    ## 2   character
    ## 3   character
    ## 4   character
    ## 5   character
    ## 6   character
    ## 7     numeric
    ## 8   character
    ## 9   character
    ## 10  character
    ## 11  character
    ## 12    numeric
    ## 13  character
    ## 14    numeric
    ## 15    numeric
    ## 16    numeric
    ## 17  character
    ## 18    numeric
    ## 19    numeric
    ## 20    numeric
    ## 21    numeric
    ## 22    numeric
    ## 23    numeric
    ## 24  character
    ## 25  character
    ## 26    numeric
    ## 27    numeric
    ## 28  character
    ## 29  character
    ## 30    numeric
    ## 31    numeric
    ## 32    numeric
    ## 33    numeric
    ## 34    numeric
    ## 35    numeric
    ## 36    numeric
    ## 37  character
    ## 38  character
    ## 39    numeric
    ## 40    numeric
    ## 41  character
    ## 42  character
    ## 43  character
    ## 44    numeric
    ## 45  character
    ## 46  character
    ## 47    numeric
    ## 48    numeric
    ## 49    numeric
    ## 50  character
    ## 51  character
    ## 52  character
    ## 53  character
    ## 54    numeric
    ## 55    numeric
    ## 56    numeric
    ## 57    numeric
    ## 58    numeric
    ## 59    numeric
    ## 60    numeric
    ## 61    numeric
    ## 62    numeric
    ## 63    numeric
    ## 64    numeric
    ## 65    numeric
    ## 66    numeric
    ## 67    numeric
    ## 68    numeric
    ## 69    numeric
    ## 70    numeric
    ## 71    numeric
    ## 72    numeric
    ## 73    numeric
    ## 74    numeric
    ## 75    numeric
    ## 76    numeric
    ## 77    numeric
    ## 78    numeric
    ## 79    numeric
    ## 80    numeric
    ## 81    numeric
    ## 82    numeric
    ## 83    numeric
    ## 84    numeric
    ## 85    numeric
    ## 86    numeric
    ## 87    numeric
    ## 88    numeric
    ## 89    numeric
    ## 90    numeric
    ## 91    numeric
    ## 92    numeric
    ## 93    numeric
    ## 94    numeric
    ## 95    numeric
    ## 96    numeric
    ## 97    numeric
    ## 98    numeric
    ## 99    numeric
    ## 100   numeric
    ## 101   numeric
    ## 102   numeric
    ## 103   numeric
    ## 104   numeric
    ## 105   numeric
    ## 106   numeric
    ## 107   numeric
    ## 108   numeric
    ## 109   numeric
    ## 110   numeric
    ## 111   numeric
    ## 112   numeric
    ## 113   numeric
    ## 114   numeric
    ## 115   numeric
    ## 116   numeric
    ## 117   numeric
    ## 118   numeric
    ## 119   numeric
    ## 120   numeric
    ## 121   numeric
    ## 122   numeric
    ## 123   numeric
    ## 124   numeric
    ## 125   numeric
    ## 126   numeric
    ## 127   numeric
    ## 128   numeric
    ## 129   numeric
    ## 130   numeric
    ## 131   numeric
    ## 132   numeric
    ## 133   numeric
    ## 134   numeric
    ## 135   numeric
    ## 136   numeric
    ## 137   numeric
    ## 138   numeric
    ## 139   numeric
    ## 140   numeric
    ## 141   numeric
    ## 142   numeric
    ## 143   numeric
    ## 144   numeric
    ## 145   numeric
    ## 146   numeric
    ## 147   numeric
    ## 148   numeric
    ## 149   numeric
    ## 150   numeric
    ## 151   numeric
    ## 152   numeric
    ## 153   numeric
    ## 154   numeric
    ## 155   numeric
    ## 156   numeric
    ## 157   numeric
    ## 158   numeric
    ## 159   numeric
    ## 160   numeric
    ## 161   numeric
    ## 162   numeric
    ## 163   numeric
    ## 164   numeric
    ## 165   numeric
    ## 166   numeric
    ## 167   numeric
    ## 168   numeric
    ## 169   numeric
    ## 170   numeric
    ## 171 character
    ## 172 character
    ## 173   numeric
    ## 174 character
    ## 175 character
    ## 176   numeric
    ## 177 character
    ## 178 character
    ## 179   numeric
    ## 180 character
    ## 181 character
    ## 182   numeric
    ## 183 character
    ## 184 character
    ## 185   numeric
    ## 186 character
    ## 187 character
    ## 188 character
    ## 189 character
    ## 190 character
    ## 191 character
    ## 192 character
    ## 193 character
    ## 194 character
    ## 195 character
    ## 196 character
    ## 197 character
    ## 198 character
    ## 199 character
    ## 200 character
    ## 201 character
    ## 202 character
    ## 203 character
    ## 204 character
    ## 205 character
    ## 206 character
    ## 207 character
    ## 208 character
    ## 209 character
    ## 210 character
    ## 211 character
    ## 212 character
    ## 213 character
    ## 214 character
    ## 215 character
    ## 216 character
    ## 217 character
    ## 218 character
    ## 219 character
    ## 220 character
    ## 221 character
    ## 222 character
    ## 223 character
    ## 224 character
    ## 225 character
    ## 226 character
    ## 227 character
    ## 228 character
    ## 229 character
    ## 230 character
    ## 231 character
    ## 232 character
    ## 233 character
    ## 234 character
    ## 235 character
    ## 236 character
    ## 237 character
    ## 238 character
    ## 239 character
    ## 240   numeric
    ## 241 character
    ## 242 character
    ## 243 character
    ## 244 character
    ## 245 character
    ## 246 character
    ## 247 character
    ## 248 character
    ## 249 character
    ## 250 character
    ## 251 character
    ## 252 character
    ## 253 character
    ## 254 character
    ## 255 character
    ## 256 character
    ## 257 character
    ## 258   numeric
    ## 259 character
    ## 260 character
    ## 261 character
    ## 262   numeric
    ## 263 character
    ## 264 character
    ## 265 character
    ## 266 character
    ## 267 character
    ## 268 character
    ## 269 character
    ## 270 character
    ## 271 character
    ## 272   numeric
    ## 273 character
    ## 274 character
    ## 275 character
    ## 276   numeric
    ## 277   numeric
    ## 278 character
    ## 279 character
    ## 280   numeric
    ## 281   numeric
    ## 282   numeric
    ## 283   numeric
    ## 284 character
    ## 285 character
    ## 286   numeric
    ## 287   numeric
    ## 288   numeric
    ## 289   numeric
    ## 290   numeric
    ## 291 character
    ## 292   numeric
    ## 293 character
    ## 294 character
    ## 295 character
    ## 296 character
    ## 297 character
    ## 298 character
    ## 299   numeric
    ## 300 character
    ## 301   numeric
    ## 302 character
    ## 303 character
    ## 304 character
    ## 305   numeric
    ## 306 character
    ## 307 character
    ## 308   numeric
    ## 309 character
    ## 310   numeric
    ## 311   numeric
    ## 312   numeric
    ## 313   numeric
    ## 314   numeric
    ## 315   numeric
    ## 316 character
    ## 317 character
    ## 318 character
    ## 319 character
    ## 320 character
    ## 321 character
    ## 322   numeric
    ## 323   numeric
    ## 324   numeric
    ## 325   numeric
    ## 326 character
    ## 327   numeric
    ## 328   numeric
    ## 329   numeric
    ## 330   numeric
    ## 331   numeric
    ## 332 character
    ## 333 character
    ## 334   numeric
    ## 335   numeric
    ## 336 character
    ## 337 character
    ## 338 character
    ## 339 character
    ## 340   numeric
    ## 341 character
    ## 342   numeric
    ## 343 character
    ## 344   numeric
    ## 345 character
    ## 346   numeric
    ## 347   numeric
    ## 348   numeric
    ## 349   numeric
    ## 350   numeric
    ## 351   numeric
    ## 352   numeric
    ## 353 character
    ## 354 character
    ## 355 character
    ## 356 character
    ## 357   numeric
    ## 358 character
    ## 359 character
    ## 360 character
    ## 361 character
    ## 362 character
    ## 363   numeric
    ## 364   numeric
    ## 365   numeric
    ## 366   numeric
    ## 367   numeric
    ## 368   numeric
    ## 369   numeric
    ## 370   numeric
    ## 371   numeric
    ## 372   numeric

``` r
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
```

    ## # A tibble: 538 × 4
    ##    play_id game_id         play_action      player_name 
    ##    <fct>   <chr>           <chr>            <chr>       
    ##  1 39      2023_19_PIT_BUF kickoff_returner J.Warren    
    ##  2 39      2023_19_PIT_BUF kicker           T.Bass      
    ##  3 39      2023_19_PIT_BUF solo_tackle      T.Matakevich
    ##  4 64      2023_19_PIT_BUF rusher           N.Harris    
    ##  5 64      2023_19_PIT_BUF solo_tackle      G.Rousseau  
    ##  6 64      2023_19_PIT_BUF fantasy          N.Harris    
    ##  7 86      2023_19_PIT_BUF passer           M.Rudolph   
    ##  8 86      2023_19_PIT_BUF receiver         J.Warren    
    ##  9 86      2023_19_PIT_BUF solo_tackle      J.Poyer     
    ## 10 86      2023_19_PIT_BUF fantasy          J.Warren    
    ## # ℹ 528 more rows

``` r
# nextgen_stats -----------------------------------------------------------------

nflreadr::dictionary_nextgen_stats
```

    ##                                      field data_type
    ## 1                              season_type character
    ## 2                      player_display_name character
    ## 3                          player_position character
    ## 4                                team_abbr character
    ## 5                           player_gsis_id character
    ## 6                        player_first_name character
    ## 7                         player_last_name character
    ## 8                        player_short_name character
    ## 9                                   season   numeric
    ## 10                                    week   numeric
    ## 11                       avg_time_to_throw   numeric
    ## 12                 avg_completed_air_yards   numeric
    ## 13                  avg_intended_air_yards   numeric
    ## 14              avg_air_yards_differential   numeric
    ## 15                          aggressiveness   numeric
    ## 16              max_completed_air_distance   numeric
    ## 17                 avg_air_yards_to_sticks   numeric
    ## 18                                attempts   numeric
    ## 19                              pass_yards   numeric
    ## 20                         pass_touchdowns   numeric
    ## 21                           interceptions   numeric
    ## 22                           passer_rating   numeric
    ## 23                             completions   numeric
    ## 24                   completion_percentage   numeric
    ## 25          expected_completion_percentage   numeric
    ## 26 completion_percentage_above_expectation   numeric
    ## 27                        avg_air_distance   numeric
    ## 28                        max_air_distance   numeric
    ## 29                    player_jersey_number   numeric
    ## 30                             avg_cushion   numeric
    ## 31                          avg_separation   numeric
    ## 32     percent_share_of_intended_air_yards   numeric
    ## 33                              receptions   numeric
    ## 34                                 targets   numeric
    ## 35                        catch_percentage   numeric
    ## 36                                   yards   numeric
    ## 37                          rec_touchdowns   numeric
    ## 38                                 avg_yac   numeric
    ## 39                        avg_expected_yac   numeric
    ## 40               avg_yac_above_expectation   numeric
    ## 41                              efficiency   numeric
    ## 42    percent_attempts_gte_eight_defenders   numeric
    ## 43                         avg_time_to_los   numeric
    ## 44                           rush_attempts   numeric
    ## 45                              rush_yards   numeric
    ## 46                     expected_rush_yards   numeric
    ## 47                rush_yards_over_expected   numeric
    ## 48                          avg_rush_yards   numeric
    ## 49        rush_yards_over_expected_per_att   numeric
    ## 50                  rush_pct_over_expected   numeric
    ## 51                         rush_touchdowns   numeric
    ##                                                                                                                                                                                                                                                                                        description
    ## 1                                                                                                                                                                                                                                                                               Either REG or POST
    ## 2                                                                                                                                                                                                                                                                          Full name of the player
    ## 3                                                                                                                                                                                                                                                         Position of the player accordinng to NGS
    ## 4                                                                                                                                                                                                                                                                       Official team abbreveation
    ## 5                                                                                                                                                                                                                                                                  Unique identifier of the player
    ## 6                                                                                                                                                                                                                                                                              Player's first name
    ## 7                                                                                                                                                                                                                                                                               Player's last name
    ## 8                                                                                                                                                                                                                                                                   Short version of player's name
    ## 9                                                                                                                  The year of the NFL season. This reperesents the whole season, so regular season games that happen in January as well as playoff games will occur in the year after this number
    ## 10                                                                           The week of the NFL season the game occurs in. Please note that the `game_type` will differ for weeks = 18 because of the season expansion in 2021. Please use `game_type` to filter for regular season or postseason
    ## 11                                                                                                                                                                                        Average time elapsed from the time of snap to throw on every pass attempt for a passer (sacks excluded).
    ## 12                                                                                                                                                                                                                                                           Average air yards on completed passes
    ## 13                                                                                                                                                                                                                                                       Average air yards on all attempted passes
    ## 14                                                                  Air Yards Differential is calculated by subtracting the passer's average Intended Air Yards from his average Completed Air Yards. This stat indicates if he is on average attempting deep passes than he on average completes.
    ## 15 Aggressiveness tracks the amount of passing attempts a quarterback makes that are into tight coverage, where there is a defender within 1 yard or less of the receiver at the time of completion or incompletion. AGG is shown as a % of attempts into tight windows over all passing attempts.
    ## 16                                                           Air Distance is the amount of yards the ball has traveled on a pass, from the point of release to the point of reception (as the crow flies). Unlike Air Yards, Air Distance measures the actual distance the passer throws the ball.
    ## 17    Air Yards to the Sticks shows the amount of Air Yards ahead or behind the first down marker on all attempts for a passer. The metric indicates if the passer is attempting his passes past the 1st down marker, or if he is relying on his skill position players to make yards after catch.
    ## 18                                                                                                                                                                                                                                                                     The number of pass attempts
    ## 19                                                                                                                                                                                                                                                            Number of yards gained on pass plays
    ## 20                                                                                                                                                                                                                                                       Number of touchdowns scored on pass plays
    ## 21                                                                                                                                                                                                                                                                  Number of interceptions thrown
    ## 22                                                                                                                                                                                                                                                                       Overall NFL passer rating
    ## 23                                                                                                                                                                                                                                                                      Number of completed passes
    ## 24                                                                                                                                                                                                                                                                  Percentage of completed passes
    ## 25                                                                                                                                                                       Using a passer's Completion Probability on every play, determine what a passer's completion percentage is expected to be.
    ## 26                                                                                                                                                                                                       A passer's actual completion percentage compared to their Expected Completion Percentage.
    ## 27                                                                                                                                                                                                                                                            A receiver's average depth of target
    ## 28                                                                                                                                                                                                                                                            A receiver's maximum depth of target
    ## 29                                                                                                                                                                                                                                                                          Player's jersey number
    ## 30                                                                                                                                                                  The distance (in yards) measured between a WR/TE and the defender they're lined up against at the time of snap on all targets.
    ## 31                                                                                                                                                                                 The distance (in yards) measured between a WR/TE and the nearest defender at the time of catch or incompletion.
    ## 32                                                       The sum of the receivers total intended air yards (all attempts) over the sum of his team's total intended air yards. Represented as a percentage, this statistic represents how much of a team's deep yards does the player account for.
    ## 33                                                                                                                                                                                                                                                       The number of receptions for the receiver
    ## 34                                                                                                                                                                                                                                                         The numnber of targets for the receiver
    ## 35                                                                                                                                                                                                                                                 Percentage of caught passes relative to targets
    ## 36                                                                                                                                                                                                                                                                   The number of receiving yards
    ## 37                                                                                                                                                                                                                                                              The number of touchdown receptions
    ## 38                                                                                                                                                                                                                                                 Average yards gained after catch by a receiver.
    ## 39                                                                                                   Average expected yards after catch, based on numerous factors using tracking data such as how open the receiver is, how fast they're traveling, how many defenders/blockers are in space, etc
    ## 40                                                                                                                                                                                                                                                A receiver's YAC compared to their Expected YAC.
    ## 41                                            Rushing efficiency is calculated by taking the total distance a player traveled on rushing plays as a ball carrier according to Next Gen Stats (measured in yards) per rushing yards gained. The lower the number, the more of a North/South runner.
    ## 42                                                                                          On every play, Next Gen Stats calculates how many defenders are stacked in the box at snap. Using that logic, DIB% calculates how often does a rusher see 8 or more defenders in the box against them.
    ## 43                                                         Next Gen Stats measures the amount of time a ball carrier spends (measured to the 10th of a second) before crossing the Line of Scrimmage. TLOS is the average time behind the LOS on all rushing plays where the player is the rusher.
    ## 44                                                                                                                                                                                                                                                                  The number of rushing attempts
    ## 45                                                                                                                                                                                                                                                              The number of rushing yards gained
    ## 46                                                                                                                                                                                                                               Expected rushing yards based on Nextgenstats' Big Data Bowl model
    ## 47                                                                                                                                                                                                                                A rusher's rush yards gained compared to the expected rush yards
    ## 48                                                                                                                                                                                                                                                                       AVerage rush yards gained
    ## 49                                                                                                                                                                                                                                                            Average rush yards above expectation
    ## 50                                                                                                                                                                                                                                                            Rushing percentage above expectation
    ## 51                                                                                                                                                                                                                                                         The number of scored rushing touchdowns

``` r
data_dir <- arrow::open_dataset("data/nextgen_stats/ngs_receiving.parquet")
data_dir |>
    filter(season==2023L & week==1) |>
    collect()
```

    ## # A tibble: 79 × 23
    ##    season season_type  week player_display_name player_position team_abbr
    ##  *  <int> <chr>       <int> <chr>               <chr>           <chr>    
    ##  1   2023 REG             1 Demario Douglas     WR              NE       
    ##  2   2023 REG             1 Jaxon Smith-Njigba  WR              SEA      
    ##  3   2023 REG             1 Calvin Austin       WR              PIT      
    ##  4   2023 REG             1 Chris Godwin        WR              TB       
    ##  5   2023 REG             1 Curtis Samuel       WR              WAS      
    ##  6   2023 REG             1 Rashid Shaheed      WR              NO       
    ##  7   2023 REG             1 Hayden Hurst        TE              CAR      
    ##  8   2023 REG             1 Zach Ertz           TE              ARI      
    ##  9   2023 REG             1 K.J. Osborn         WR              MIN      
    ## 10   2023 REG             1 Jahan Dotson        WR              WAS      
    ## # ℹ 69 more rows
    ## # ℹ 17 more variables: avg_cushion <dbl>, avg_separation <dbl>,
    ## #   avg_intended_air_yards <dbl>, percent_share_of_intended_air_yards <dbl>,
    ## #   receptions <int>, targets <int>, catch_percentage <dbl>, yards <int>,
    ## #   rec_touchdowns <int>, avg_yac <dbl>, avg_expected_yac <dbl>,
    ## #   avg_yac_above_expectation <dbl>, player_gsis_id <chr>,
    ## #   player_first_name <chr>, player_last_name <chr>, …

``` r
# snap_counts -----------------------------------------------------------------

nflreadr::dictionary_snap_counts
```

    ##            field data_type                          description
    ## 1        game_id character                     nflfastR game ID
    ## 2    pfr_game_id character                          PFR game ID
    ## 3         season   numeric                       Season of game
    ## 4      game_type character Type of game (regular or postseason)
    ## 5           week   numeric           Week of game in NFL season
    ## 6         player character                          Player name
    ## 7  pfr_player_id character                        Player PFR ID
    ## 8       position character                   Position of player
    ## 9           team character                       Team of player
    ## 10      opponent character              Opposing team of player
    ## 11 offense_snaps   numeric           Number of snaps on offense
    ## 12   offense_pct   numeric     Percent of offensive snaps taken
    ## 13 defense_snaps   numeric           Number of snaps on defense
    ## 14   defense_pct   numeric     Percent of defensive snaps taken
    ## 15      st_snaps   numeric     Number of snaps on special teams
    ## 16        st_pct   numeric Percent of special teams snaps taken

``` r
data_dir <- arrow::open_dataset("data/snap_counts")
data_dir |>
    filter(season==2023L & team=="BUF" & week==19) |>
    collect()
```

    ##             game_id  pfr_game_id season game_type  week            player
    ##              <char>       <char>  <int>    <char> <int>            <char>
    ##  1: 2023_19_PIT_BUF 202401150buf   2023        WC    19  O'Cyrus Torrence
    ##  2: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Spencer Brown
    ##  3: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Dion Dawkins
    ##  4: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Josh Allen
    ##  5: 2023_19_PIT_BUF 202401150buf   2023        WC    19       Mitch Morse
    ##  6: 2023_19_PIT_BUF 202401150buf   2023        WC    19   Connor McGovern
    ##  7: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Stefon Diggs
    ##  8: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Khalil Shakir
    ##  9: 2023_19_PIT_BUF 202401150buf   2023        WC    19   Trent Sherfield
    ## 10: 2023_19_PIT_BUF 202401150buf   2023        WC    19        James Cook
    ## 11: 2023_19_PIT_BUF 202401150buf   2023        WC    19    Dalton Kincaid
    ## 12: 2023_19_PIT_BUF 202401150buf   2023        WC    19       Dawson Knox
    ## 13: 2023_19_PIT_BUF 202401150buf   2023        WC    19     David Edwards
    ## 14: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Ty Johnson
    ## 15: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Deonte Harty
    ## 16: 2023_19_PIT_BUF 202401150buf   2023        WC    19    Quintin Morris
    ## 17: 2023_19_PIT_BUF 202401150buf   2023        WC    19   Latavius Murray
    ## 18: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Andy Isabella
    ## 19: 2023_19_PIT_BUF 202401150buf   2023        WC    19    Reggie Gilliam
    ## 20: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Micah Hyde
    ## 21: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Jordan Poyer
    ## 22: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Dane Jackson
    ## 23: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Kaiir Elam
    ## 24: 2023_19_PIT_BUF 202401150buf   2023        WC    19         Ed Oliver
    ## 25: 2023_19_PIT_BUF 202401150buf   2023        WC    19        A.J. Klein
    ## 26: 2023_19_PIT_BUF 202401150buf   2023        WC    19  Gregory Rousseau
    ## 27: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Taron Johnson
    ## 28: 2023_19_PIT_BUF 202401150buf   2023        WC    19      DaQuan Jones
    ## 29: 2023_19_PIT_BUF 202401150buf   2023        WC    19    Terrel Bernard
    ## 30: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Leonard Floyd
    ## 31: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Cameron Lewis
    ## 32: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Von Miller
    ## 33: 2023_19_PIT_BUF 202401150buf   2023        WC    19      A.J. Epenesa
    ## 34: 2023_19_PIT_BUF 202401150buf   2023        WC    19   Dorian Williams
    ## 35: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Tim Settle
    ## 36: 2023_19_PIT_BUF 202401150buf   2023        WC    19       Shaq Lawson
    ## 37: 2023_19_PIT_BUF 202401150buf   2023        WC    19    Baylon Spector
    ## 38: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Linval Joseph
    ## 39: 2023_19_PIT_BUF 202401150buf   2023        WC    19      Damar Hamlin
    ## 40: 2023_19_PIT_BUF 202401150buf   2023        WC    19 Christian Benford
    ## 41: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Siran Neal
    ## 42: 2023_19_PIT_BUF 202401150buf   2023        WC    19  Tyler Matakevich
    ## 43: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Tyler Bass
    ## 44: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Sam Martin
    ## 45: 2023_19_PIT_BUF 202401150buf   2023        WC    19     Reid Ferguson
    ## 46: 2023_19_PIT_BUF 202401150buf   2023        WC    19        Ryan Bates
    ## 47: 2023_19_PIT_BUF 202401150buf   2023        WC    19   Ryan Van Demark
    ##             game_id  pfr_game_id season game_type  week            player
    ##     pfr_player_id position   team opponent offense_snaps offense_pct
    ##            <char>   <char> <char>   <char>         <num>       <num>
    ##  1:      TorrOC00        G    BUF      PIT            67        1.00
    ##  2:      BrowSp00        T    BUF      PIT            67        1.00
    ##  3:      DawkDi00        T    BUF      PIT            67        1.00
    ##  4:      AlleJo02       QB    BUF      PIT            67        1.00
    ##  5:      MorsMi00        C    BUF      PIT            67        1.00
    ##  6:      McGoCo01        G    BUF      PIT            66        0.99
    ##  7:      DiggSt00       WR    BUF      PIT            56        0.84
    ##  8:      ShakKh00       WR    BUF      PIT            45        0.67
    ##  9:      SherTr00       WR    BUF      PIT            42        0.63
    ## 10:      CookJa01       RB    BUF      PIT            41        0.61
    ## 11:      KincDa00       TE    BUF      PIT            37        0.55
    ## 12:      KnoxDa00       TE    BUF      PIT            28        0.42
    ## 13:      EdwaDa01        G    BUF      PIT            25        0.37
    ## 14:      JohnTy02       RB    BUF      PIT            15        0.22
    ## 15:      HarrDe07       WR    BUF      PIT            14        0.21
    ## 16:      MorrQu00       TE    BUF      PIT            13        0.19
    ## 17:      MurrLa00       RB    BUF      PIT            10        0.15
    ## 18:      IsabAn00       WR    BUF      PIT             7        0.10
    ## 19:      GillRe00       FB    BUF      PIT             3        0.04
    ## 20:      HydeMi00       FS    BUF      PIT             0        0.00
    ## 21:      PoyeJo00       SS    BUF      PIT             0        0.00
    ## 22:      JackDa02       CB    BUF      PIT             0        0.00
    ## 23:      ElamKa00       CB    BUF      PIT             0        0.00
    ## 24:      OlivEd00       DT    BUF      PIT             0        0.00
    ## 25:      KleiAJ00       LB    BUF      PIT             0        0.00
    ## 26:      RousGr00       DE    BUF      PIT             0        0.00
    ## 27:      JohnTa01       CB    BUF      PIT             0        0.00
    ## 28:      JoneDa04       DT    BUF      PIT             0        0.00
    ## 29:      BernTe00       LB    BUF      PIT             0        0.00
    ## 30:      FloyLe00       DE    BUF      PIT             0        0.00
    ## 31:      LewiCa00       CB    BUF      PIT             0        0.00
    ## 32:      MillVo00       LB    BUF      PIT             0        0.00
    ## 33:      EpenAJ00       DE    BUF      PIT             0        0.00
    ## 34:      WillDo04       LB    BUF      PIT             0        0.00
    ## 35:      SettTi00       DT    BUF      PIT             0        0.00
    ## 36:      LawsSh00       DE    BUF      PIT             0        0.00
    ## 37:      SpecBa00       LB    BUF      PIT             0        0.00
    ## 38:      JoseLi99       NT    BUF      PIT             0        0.00
    ## 39:      HamlDa00       SS    BUF      PIT             0        0.00
    ## 40:      BenfCh00       CB    BUF      PIT             0        0.00
    ## 41:      NealSi00       CB    BUF      PIT             0        0.00
    ## 42:      MataTy00       LB    BUF      PIT             0        0.00
    ## 43:      BassTy00        K    BUF      PIT             0        0.00
    ## 44:      MartSa01        P    BUF      PIT             0        0.00
    ## 45:      FergRe00       LS    BUF      PIT             0        0.00
    ## 46:      BateRy02        C    BUF      PIT             0        0.00
    ## 47:      VanDRy00        T    BUF      PIT             0        0.00
    ##     pfr_player_id position   team opponent offense_snaps offense_pct
    ##     defense_snaps defense_pct st_snaps st_pct
    ##             <num>       <num>    <num>  <num>
    ##  1:             0        0.00        7   0.26
    ##  2:             0        0.00        7   0.26
    ##  3:             0        0.00        7   0.26
    ##  4:             0        0.00        0   0.00
    ##  5:             0        0.00        0   0.00
    ##  6:             0        0.00        5   0.19
    ##  7:             0        0.00        0   0.00
    ##  8:             0        0.00        4   0.15
    ##  9:             0        0.00        0   0.00
    ## 10:             0        0.00        0   0.00
    ## 11:             0        0.00        0   0.00
    ## 12:             0        0.00        0   0.00
    ## 13:             0        0.00        7   0.26
    ## 14:             0        0.00       14   0.52
    ## 15:             0        0.00        8   0.30
    ## 16:             0        0.00       24   0.89
    ## 17:             0        0.00        0   0.00
    ## 18:             0        0.00       14   0.52
    ## 19:             0        0.00       24   0.89
    ## 20:            65        1.00        3   0.11
    ## 21:            65        1.00        3   0.11
    ## 22:            65        1.00        0   0.00
    ## 23:            52        0.80        6   0.22
    ## 24:            46        0.71        0   0.00
    ## 25:            43        0.66       10   0.37
    ## 26:            42        0.65        3   0.11
    ## 27:            40        0.62        0   0.00
    ## 28:            36        0.55        3   0.11
    ## 29:            32        0.49        1   0.04
    ## 30:            32        0.49        0   0.00
    ## 31:            28        0.43       20   0.74
    ## 32:            25        0.38        0   0.00
    ## 33:            24        0.37        1   0.04
    ## 34:            21        0.32       19   0.70
    ## 35:            20        0.31        3   0.11
    ## 36:            19        0.29        3   0.11
    ## 37:            17        0.26        2   0.07
    ## 38:            17        0.26        0   0.00
    ## 39:            13        0.20       17   0.63
    ## 40:            13        0.20        0   0.00
    ## 41:             0        0.00       20   0.74
    ## 42:             0        0.00       20   0.74
    ## 43:             0        0.00       13   0.48
    ## 44:             0        0.00       10   0.37
    ## 45:             0        0.00       10   0.37
    ## 46:             0        0.00        7   0.26
    ## 47:             0        0.00        2   0.07
    ##     defense_snaps defense_pct st_snaps st_pct

``` r
# pbp_participation -----------------------------------------------------------------

nflreadr::dictionary_participation
```

    ##                     Field      Type
    ## 1        nflverse_game_id character
    ## 2             old_game_id character
    ## 3                 play_id   integer
    ## 4         possession_team character
    ## 5       offense_formation character
    ## 6       offense_personnel character
    ## 7        defenders_in_box   integer
    ## 8       defense_personnel character
    ## 9  number_of_pass_rushers   integer
    ## 10        players_on_play character
    ## 11        offense_players character
    ## 12        defense_players character
    ## 13              n_offense   integer
    ## 14              n_defense   integer
    ##                                                                                                                                                                                        Description
    ## 1                                                                                                                      nflverse identifier for games. Format is season, week, away_team, home_team
    ## 2                                                                                                                                                                              Legacy NFL game ID.
    ## 3                                                                                          Numeric play id that when used with game_id and drive provides the unique identifier for a single play.
    ## 4                                                                                                                                                String abbreviation for the team with possession.
    ## 5                                                                                                                                              Formation the offense lines up in to snap the ball.
    ## 6  Number of running backs, tight ends, and wide receivers on the field for the play. If there are more than the standard 5 offensive linemen and 1 quarterback, they will be listed here as well.
    ## 7                                                                                                                                     Number of defensive players lined up in the box at the snap.
    ## 8                                                                                                         Number of defensive linemen, linebackers, and defensive backs on the field for the play.
    ## 9                                                                                                                                                Number of defensive player who rushed the passer.
    ## 10                                                                                                                                 A list of every player on the field for the play, by gsis_it_id
    ## 11                                                                                                                          A list of every offensive player on the field for the play, by gsis_id
    ## 12                                                                                                                          A list of every defensive player on the field for the play, by gsis_id
    ## 13                                                                                                                                           Number of offensive players on the field for the play
    ## 14                                                                                                                                           Number of defensive players on the field for the play

``` r
data_dir <- arrow::open_dataset("data/pbp_participation")
data_dir |>
    filter(season==2023L,possession_team=="BUF") |>
    collect()
```

    ## # A tibble: 1,417 × 21
    ##    nflverse_game_id old_game_id play_id possession_team offense_formation
    ##  * <chr>            <chr>         <int> <chr>           <chr>            
    ##  1 2023_01_BUF_NYJ  2023091100       58 BUF             SHOTGUN          
    ##  2 2023_01_BUF_NYJ  2023091100       83 BUF             SHOTGUN          
    ##  3 2023_01_BUF_NYJ  2023091100      108 BUF             SINGLEBACK       
    ##  4 2023_01_BUF_NYJ  2023091100      130 BUF             SHOTGUN          
    ##  5 2023_01_BUF_NYJ  2023091100      152 BUF             SHOTGUN          
    ##  6 2023_01_BUF_NYJ  2023091100      175 BUF             <NA>             
    ##  7 2023_01_BUF_NYJ  2023091100      382 BUF             <NA>             
    ##  8 2023_01_BUF_NYJ  2023091100      413 BUF             SHOTGUN          
    ##  9 2023_01_BUF_NYJ  2023091100      435 BUF             PISTOL           
    ## 10 2023_01_BUF_NYJ  2023091100      460 BUF             SHOTGUN          
    ## # ℹ 1,407 more rows
    ## # ℹ 16 more variables: offense_personnel <chr>, defenders_in_box <int>,
    ## #   defense_personnel <chr>, number_of_pass_rushers <int>,
    ## #   players_on_play <chr>, offense_players <chr>, defense_players <chr>,
    ## #   n_offense <int>, n_defense <int>, ngs_air_yards <dbl>, time_to_throw <dbl>,
    ## #   was_pressure <lgl>, route <chr>, defense_man_zone_type <chr>,
    ## #   defense_coverage_type <chr>, season <int>

``` r
generate_dictionary <- function(dat){
    dat |>
        mutate(rowid=1:n()) |>
        pivot_longer(
            cols = -rowid
        )
}
```
