# Terrorism Endangers Ape Conservation

Apes are among the most endangered mammals on earth, but terrorism -- an overlooked stressor -- amplifies every known threat to their survival. GTD attack records for sub-Saharan Africa were spatially joined to primate habitat shapefiles in QGIS, isolating 2,626 attacks that occurred directly within ape habitat ranges. Of these, 1,330 resulted in fatalities totaling over 11,000 individuals killed. Attacks concentrate in three hotspot regions -- the DRC-Uganda-Burundi corridor, the Nigeria-Cameroon border, and Sierra Leone -- all of which score in the lower range of the V-Dem egalitarian democracy index, reflecting the poverty and inequality conditions that drive terrorism and undermine conservation. The primary threat mechanism is not infrastructure destruction (most attacks cause minor or no recorded property damage) but human displacement: people driven from their homes by violence seek food from bushmeat and shelter from forest clearing, the same pathways that directly threaten ape populations.

## Portfolio Page

The [portfolio page](https://kchoover14.github.io/mapping-terrorism-ape-conservation/) includes a full project narrative, key findings, and figures.

## Tools & Technologies

**Languages & Tools:** R, QGIS, Web Mercator projection, ESRI World Imagery basemap
**R Packages:** ggplot2, dplyr, janitor, ggpubr, vdemdata, countrycode

**Note on basemap:** The ESRI World Imagery basemap is an XYZ tile service and does not package into the geopackage. To reproduce the map with the original basemap, add a new XYZ tile connection in QGIS:
- Name: ESRI World Imagery
- URL: `https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}`
- CRS: EPSG:3857
- Min zoom: 0 / Max zoom: 17

## Expertise

Integration of geospatial analysis, open-source conflict databases, and political indicators to surface the structural conditions driving a conservation crisis -- applicable to any domain where environmental outcomes are shaped by political and security context.
