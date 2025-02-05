
##############################################################################
# 01 # Getting FRED data                                                     #
##############################################################################


# * 1) Load libraries ---- 

library(fredr)      # https://cran.r-project.org/web/packages/fredr/vignettes/fredr.html
library(dplyr)
library(tidyr)
library(ggplot2)
library(writexl)


# * 2) FRED API key ---- 

fredr_set_key( "YOUR FRED API KEY" )


# * 3) Download FRED data ---- 

# INDPRO   # Industrial Production Index

IP <- fredr( series_id = "INDPRO",
             observation_start = as.Date("1983-01-01"),
             observation_end   = as.Date("2024-01-01") )

# PAYEMS   # Employees: Total Nonfarm Payrolls

EM <- fredr( series_id = "PAYEMS",
             observation_start = as.Date("1983-01-01"),
             observation_end   = as.Date("2024-01-01") )

# CMRMTSPL # Real Manufacturing and Trade Industries Sales

SA <- fredr( series_id = "CMRMTSPL",
             observation_start = as.Date("1983-01-01"),
             observation_end   = as.Date("2024-01-01") )

# W875RX1  # Real Personal Income ex current transfer receipts

IN <- fredr( series_id = "W875RX1",
             observation_start = as.Date("1983-01-01"),
             observation_end   = as.Date("2024-01-01") )


# * 4) Bind together in one table ---- 

df_long <- bind_rows(IP, EM, SA, IN)

df_wide <- df_long %>% pivot_wider( id_cols = date,
                                    names_from = series_id,
                                    values_from = value      )


# * 5) Data transformations ---- 

# Yearly growth rates

df_growth_long_Y <- df_long %>% arrange(series_id, date) %>%
                                group_by(series_id) %>%
                                mutate(growth_yoy = (value / lag(value, 12) - 1) * 100) %>%
                                ungroup()

df_growth_wide_Y <- df_growth_long_Y %>% select(date, series_id, growth_yoy) %>%
                                         pivot_wider(names_from = series_id, values_from = growth_yoy)

# Monthly growth rates

df_growth_long_M <- df_long %>% arrange(series_id, date) %>%
                                group_by(series_id) %>%
                                mutate(growth_mom = (value / lag(value, 1) - 1) * 100) %>%
                                ungroup()

df_growth_wide_M <- df_growth_long_M %>% select(date, series_id, growth_mom) %>%
                                         pivot_wider(names_from = series_id, values_from = growth_mom)


# * 6) Plots ---- 

# Yearly growth rates

ggplot(df_growth_long_Y, aes(x = date, y = growth_yoy, color = series_id)) +
                         geom_line() +
                         labs( x = "Date",
                               y = "Year-over-Year Growth (%)",
                               title = "Year-over-Year Growth of the 4 Series" ) +
                         theme_minimal()

# Monthly growth rates

ggplot(df_growth_long_M, aes(x = date, y = growth_mom, color = series_id)) +
                         geom_line() +
                         labs( x = "Date",
                               y = "Month-over-Month Growth (%)",
                               title = "Month-over-Month Growth of the 4 Series" ) +
                         theme_minimal()


# * 7) Write data on Excel file ---- 

path_results    <- "YOUR RESULTS FOLDER PATH"

write_xlsx( x    = list( "raw"     = df_wide,
                         "yearly"  = df_growth_wide_Y,
                         "monthly" = df_growth_wide_M ), 
            path = file.path(path_results, "us_data.xlsx") )


###############################################################################
#               THIS IS THE END MY ONLY FRIEND, THE END...                    #
###############################################################################
