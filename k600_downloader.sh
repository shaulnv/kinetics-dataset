#!/bin/bash

function download_data {
    local data_type="$1"
    local root_dl_targz="$2"
    local curr_dl="${root_dl_targz}/${data_type}"
    local url="https://s3.amazonaws.com/kinetics/600/${data_type}/k600_${data_type}_path.txt"

    # Create the directory if it does not exist
    [ ! -d "$curr_dl" ] && mkdir -p "$curr_dl"

    # Download the data using wget with parallel execution
    wget -qO- "$url" | xargs -n 1 -P 8 wget -c -P "$curr_dl"
}

# Download directories vars
root_dl="k600"
root_dl_targz="k600_targz"

# Make root directories
[ ! -d $root_dl ] && mkdir $root_dl
[ ! -d $root_dl_targz ] && mkdir $root_dl_targz

# Run download_data in background for "train", "val", and "test"
download_data train "$root_dl_targz" &
download_data val "$root_dl_targz" &
download_data test "$root_dl_targz" &

# Wait for all background jobs to complete
wait

echo "train, val & test downloads completed."

# Download annotations csv files
curr_dl=${root_dl}/annotations
url_tr=https://s3.amazonaws.com/kinetics/600/annotations/train.txt
url_v=https://s3.amazonaws.com/kinetics/600/annotations/val.txt
url_t=https://s3.amazonaws.com/kinetics/600/annotations/test.csv
url_ht=https://s3.amazonaws.com/kinetics/600/annotations/kinetics600_holdout_test.csv
[ ! -d $curr_dl ] && mkdir -p $curr_dl
wget -c $url_tr -P $ &
wget -c $url_v -P $curr_dl &
wget -c $url_t -P $curr_dl &
wget -c $url_ht -P $curr_dl &

# Wait for all background jobs to complete
wait

# Download readme
url=http://s3.amazonaws.com/kinetics/600/readme.md
wget -c $url -P $root_dl

# Downloads complete
echo -e "\nDownloads complete! Now run extractor, k600_extractor.sh"
