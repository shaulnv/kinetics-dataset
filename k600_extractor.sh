#!/bin/bash

# Download directories vars
root_dl="k600"
root_dl_targz="k600_targz"

# Make root directories
[ ! -d $root_dl_targz ] && echo -e "\nRun k600_downloaders.sh"
[ ! -d $root_dl ] && mkdir $root_dl

function extract_tar_gz() {
	local folder_name=$1
	local curr_dl="${root_dl_targz}/${folder_name}"
	local curr_extract="${root_dl}/${folder_name}"

	[ ! -d "$curr_extract" ] && mkdir -p "$curr_extract"

	find "$curr_dl" -type f -name '*.tar.gz' | while read file; do
		local new_file=$(echo "$file" | tr ' ' '_')
		if [[ "$file" != "$new_file" ]]; then
			mv "$file" "$new_file"
		fi
	done

	find "$curr_dl" -type f -name '*.tar.gz' | parallel \
		'echo Extracting {} to '"$curr_extract"' && tar zxf {} -C '"$curr_extract"''
}

# Run function for each directory in the background
extract_tar_gz "test" &
extract_tar_gz "val" &
extract_tar_gz "train" &

# Wait for all background jobs to complete
wait

# Extraction complete
echo -e "\nExtractions complete!"
