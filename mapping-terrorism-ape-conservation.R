library(dplyr)       # data manipulation
library(ggplot2)     # data visualization
library(janitor)     # clean column names
library(ggpubr)      # publication-ready ggplot themes
library(vdemdata)    # V-Dem democracy dataset
library(countrycode) # convert country codes across systems

######################## LOAD AND CLEAN INTERSECTION DATA

# Point-in-polygon export from QGIS: GTD attacks within primate habitat range
attacks = read.csv("exportPointIntersectionTable.csv")
attacks = clean_names(attacks)

# Convert categorical variables to factors
# Note: clean_names() strips trailing underscores -- weaptype1_ becomes weaptype1, targtype1_ becomes targtype1
attacks$weaptype1  = as.factor(attacks$weaptype1)
attacks$targtype1  = as.factor(attacks$targtype1)
attacks$attackty_1 = as.factor(attacks$attackty_1)

# Recode empty property damage extent as "Not recorded"
attacks$propexte_1 = ifelse(attacks$propexte_1 == "" | is.na(attacks$propexte_1),
                             "Not recorded", attacks$propexte_1)
attacks$propexte_1 = as.factor(attacks$propexte_1)

######################## PERPETRATOR GROUP FREQUENCY TABLE

# Frequency of attacks by perpetrator group
t1 = table(attacks$gname)
t1 = as.data.frame(t1)
names(t1) = c("group", "frequency")
t1 = t1[order(-t1$frequency), ]

# Save perpetrator frequency table
write.csv(t1, "perpetrator-frequency.csv", quote = FALSE, row.names = FALSE)

######################## PROPERTY DAMAGE EXTENT FIGURE

# Frequency of attacks by property damage extent
t2 = attacks |>
  group_by(propexte_1) |>
  summarise(counts = n())

# Order levels for display
t2$propexte_1 = factor(t2$propexte_1,
  levels = c("Not recorded", "Minor (likely < $1 million)",
             "Unknown", "Major (likely >= $1 million but < $1 billion)"))

ggplot(t2, aes(x = propexte_1, y = counts)) +
  geom_bar(fill = "#0073C2FF", stat = "identity") +
  geom_text(aes(label = counts), vjust = -0.3) +
  labs(
    x = "Property Damage Extent",
    y = "Number of Attacks",
    title = "Property Damage from Terrorist Attacks in Primate Habitats"
  ) +
  theme_pubclean() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
ggsave("property-damage-extent.png",
       plot = last_plot(), width = 7, height = 5, dpi = 150)

######################## LOAD AND PREPARE VDEM DATA

vdem_data = vdem |>
  select(
    vdem_ctry_id = country_id,
    country      = country_name,
    region       = e_regionpol_6C,
    year,
    egal_dem     = v2x_egaldem
  ) |>
  mutate(region = case_match(region,
    1 ~ "Eastern Europe",
    2 ~ "Latin America",
    3 ~ "Middle East",
    4 ~ "Africa",
    5 ~ "The West",
    6 ~ "Asia")
  )

# Add ISO3 country codes for potential merging
vdem_data = vdem_data |>
  mutate(iso3c = countrycode(
    sourcevar   = vdem_ctry_id,
    origin      = "vdem",
    destination = "iso3c"))

# Filter to Africa, 2022
dem_af_2022 = vdem_data |>
  filter(region == "Africa", year == 2022)

# Save
write.csv(dem_af_2022, "demAf2022.csv", quote = FALSE, row.names = FALSE)

######################## VDEM FIGURE -- HOTSPOT COUNTRIES

# Highlight the three terrorism hotspot regions identified in the map
hotspots = c("Democratic Republic of the Congo", "Uganda", "Burundi",
             "Nigeria", "Cameroon", "Sierra Leone")

dem_hotspots = dem_af_2022 |>
  filter(country %in% hotspots) |>
  mutate(country = factor(country, levels = country[order(egal_dem)]))

ggplot(dem_hotspots, aes(x = country, y = egal_dem)) +
  geom_bar(fill = "#7B3F00", stat = "identity") +
  geom_text(aes(label = round(egal_dem, 2)), vjust = -0.3, size = 3.5) +
  labs(
    x = NULL,
    y = "Egalitarian Democracy Index (0-1)",
    title = "Egalitarian Democracy Scores -- Terrorism Hotspot Countries",
    subtitle = "V-Dem 2022 | Higher scores indicate stronger egalitarian democracy"
  ) +
  ylim(0, 0.75) +
  theme_pubclean() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))
ggsave("vdem-hotspot-democracy.png", width = 7, height = 5, dpi = 150)
