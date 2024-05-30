#!/bin/bash

# Download directories vars
root_dl="k600"
root_dl_targz="k600_targz"

# Make root directories
[ ! -d $root_dl ] && mkdir $root_dl
[ ! -d $root_dl_targz ] && mkdir $root_dl_targz

# Define the download directory based on a root directory
curr_dl="${root_dl_targz}/test"

# URL where the list of files to be downloaded is located
url="https://s3.amazonaws.com/kinetics/600/test/k600_test_path.txt"

# Create the directory if it doesn't exist
[ ! -d "$curr_dl" ] && mkdir -p "$curr_dl"

# Download the list of files
wget -O $curr_dl/file_list.txt "$url"

# Reverse the list
tac $curr_dl/file_list.txt >$curr_dl/reversed_file_list.txt

# Download files in reverse order
wget -c -i $curr_dl/reversed_file_list.txt -P $curr_dl

# Download annotations csv files
curr_dl=${root_dl}/annotations
url_tr=https://s3.amazonaws.com/kinetics/600/annotations/train.txt
url_v=https://s3.amazonaws.com/kinetics/600/annotations/val.txt
url_t=https://s3.amazonaws.com/kinetics/600/annotations/test.csv
url_ht=https://s3.amazonaws.com/kinetics/600/annotations/kinetics600_holdout_test.csv
[ ! -d $curr_dl ] && mkdir -p $curr_dl
wget -c $url_tr -P $curr_dl
wget -c $url_v -P $curr_dl
wget -c $url_t -P $curr_dl
wget -c $url_ht -P $curr_dl

# Download readme
url=http://s3.amazonaws.com/kinetics/600/readme.md
wget -c $url -P $root_dl

# Downloads complete
echo -e "\nDownloads complete! Now run extractor, k600_extractor.sh"
