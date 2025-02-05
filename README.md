
This repository contains the code to programmatically download US macro data from the FRED database (see https://fred.stlouisfed.org/). For that, you need to get you API key, which you can get quickly for free (https://fred.stlouisfed.org/docs/api/api_key.html).

In the example I provide, the code "get data FRED.R" downloads 4 time series, i.e. industrial production and measures of employment, sales and household income. You can download the series you want by adjusting the FRED code for each series, and the start and end dates as you wish.

After some plotting and data processing, this R code produces an Excel file with the data ("us_data.xlsx").
