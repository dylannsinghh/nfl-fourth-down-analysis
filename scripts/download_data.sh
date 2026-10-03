#!/bin/bash
# Downloads NFL play-by-play data (2018-2026) from nflverse into data/raw/
mkdir -p data/raw
for year in {2018..2026}; do
        curl -fL -o "data/raw/play_by_play_${year}.parquet" \
    "https://github.com/nflverse/nflverse-data/releases/download/pbp/play_by_play_${year}.parquet"
done
