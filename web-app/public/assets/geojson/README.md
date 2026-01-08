# Sri Lanka Districts GeoJSON

## Getting Accurate GeoJSON Data

For an accurate Sri Lanka map with proper district boundaries, you can download GeoJSON data from:

1. **GitHub Repository (Recommended):**
   - URL: https://github.com/nuuuwan/gis_srilanka
   - Download: `data/districts.geojson`
   - This is the most accurate source for Sri Lanka district boundaries

2. **GADM (Global Administrative Areas):**
   - URL: https://gadm.org/download_country_v3.html
   - Select Sri Lanka and download the administrative level 2 (districts) GeoJSON

3. **Natural Earth:**
   - URL: https://www.naturalearthdata.com/

## Installation

1. Download the accurate GeoJSON file
2. Replace `sri-lanka-districts.geojson` in this directory
3. Ensure the district names in the GeoJSON `properties` match your database district names

## District Name Mapping

The code automatically handles common variations:
- `district`, `NAME_2`, `name`, `District` property names
- Case variations (Colombo, COLOMBO)
- Name variations (Digamadulla/Ampara, Vanni/Mannar)

## Current File

The current `sri-lanka-districts.geojson` file contains simplified rectangular shapes for all 22 districts. Replace it with accurate GeoJSON data for a proper map visualization.




