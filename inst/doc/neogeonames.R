## -----------------------------------------------------------------------------
library(neogeonames)
df <- read.delim(system.file("extdata", "feature.tsv", package = "neogeonames"))
country <- unique(df$country)
geo <- lapply(country, adminify_delim, delim = "[:,]")
df.ac <- data.frame(id = 1:length(geo), country = country, do.call(rbind, lapply(geo, `[[`, "ac")))
df.id <- data.frame(id = 1:length(geo), country = country, do.call(rbind, lapply(geo, `[[`, "id")))

## -----------------------------------------------------------------------------
knitr::kable(head(df.ac, n = 20))

## -----------------------------------------------------------------------------
knitr::kable(head(df.id, n = 20))

## -----------------------------------------------------------------------------
# remove rows with missing country_code
df.coor <- df.id[!is.na(df.id$ac0), ]
# set admin codes with no parent code to NA, since they lack support
df.coor <- apply(cbind(df.coor, NA), 1, function(row) {
  if (!is.na(j <- which(is.na(row))[1])) row[j - 1]
})

# merge coordinate data
df.coor <- merge(
  data.frame(id = names(df.coor), geonameid = as.integer(df.coor)),
  neogeonames::geoname[c("geonameid", "latitude", "longitude")],
  by = "geonameid",
  all.x = T
)

# merge with admin codes and original data
df.coor <- merge(df.ac, df.coor, by = "id", all.x = T)
df.geo <- merge(df, df.coor[2:ncol(df.coor)], by = "country", all.x = T)
keys <- c("country", "ac0", "ac1", "ac2", "ac3", "ac4", "latitude", "longitude")
knitr::kable(head(unique(df.geo[keys])))

## ---- fig.align="center", warning=F-------------------------------------------
library(ggplot2)
ggplot() + 
  geom_polygon(
    data = shape, color = "black", fill = "white",
    aes(long, lat, group = group)
  ) +
  geom_point(
    data = df.geo, fill = "blue", pch = 21,
    aes(longitude, latitude)
  ) +
  theme_minimal()

## -----------------------------------------------------------------------------
regexes <- list(
  list(pattern = "(.+)", names = c("ac0")),
  list(pattern = "(.+):\\s*(.+)", names = c("ac0", "ac1")),
  list(pattern = "(.+):\\s*.+,\\s*(.+)", names = c("ac0", "ac1")),
  list(pattern = "(.+):\\s*(.+)\\s*,\\s*(.+)", names = c("ac0", "ac1", "ac2")),
  list(pattern = "(.+):\\s*(.+)\\s*,\\s*(.+)", names = c("ac0", "ac2", "ac1"))
)
geo <- lapply(country, adminify_regexes, regexes = regexes)
df.ac <- data.frame(id = 1:length(geo), country = country, do.call(rbind, lapply(geo, `[[`, "ac")))

## -----------------------------------------------------------------------------
knitr::kable(head(df.ac, n = 20))

