library(googleVis)
library(rmarkdown)

knit("sales_eda.Rmd")

df <- sales %>% 
      group_by(region) %>%
      mutate(Count = sum(Count))  %>%
      select(region, Count)


GeoStates <- gvisGeoChart(df, "region", "Count",
                          options=list(region="US", 
                                       displayMode="regions", 
                                       resolution="provinces",
                                       width=600, height=400))

plot(GeoStates)
