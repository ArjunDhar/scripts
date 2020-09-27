#!/bin/bash

# Resize - Convert the largest images into smaller images of various sizes.
# Note: Please ensure the main site catalog folder is synched with the contnt folder.

# resize.sh Flattens the folder from Source to Destination
# It also checks if the file in the desitnation is more recent than source. If so then only will RESIZE it
#
# This version Does a sync between the source and dest to ensure folder hierarchy is maintained. Then will do a resize of every file in the destination
# 
# TODO: ensure resize.sh with DELAT mode but also respects hierarchy mode where it does not have to flatten the hierarchy
# This version is a work around however is much slower since all files are synched and resized. It acts on the DESTINATION folder alone.
# NOT PRACTICAL FOR LARGE IMAGE REPOS

source=/catalog/original

resize()
{
	dest=$1
	width=$2
	height=$3
	filter=$4

        # Ensure any new files are copies in the mirror hierarchy in the dest location
        # rsync -avmP --prune-empty-dirs --include '*/' --exclude '*.jpg' $source/ $dest/
        rsync -avmP --ignore-existing --include '*/' $source/ $dest/

	echo "Resize all files in $dest to $width x $height"
	start=$(date +"%s")
	find $dest/* -iname *$filter.png -exec mogrify -verbose -resize $widthx$height {} \;
	find $dest/* -iname *$filter.jpg -exec mogrify -verbose -resize $widthx$height {} \;
	find $dest/* -iname *$filter.jpeg -exec mogrify -verbose -resize $widthx$height {} \;

	#for f in $(find $dest/* -iname *$filter.png -or -iname *$filter.jpg -or -iname *$filter.jpeg)
	#do
	#	dir="$(dirname $f)"
	#	fname="$(basename $f)"
	#	extension="$(echo ${fname}|awk -F\. '{print $2}')"
	#	oufile="${f##}"
	#	echo "$outfile"
	#	if [ -e "$dir/$fname" ];
	#	then
	#		echo "processing $dir/$fname"
	#		#convert $f -resize $widthx$height $dest/$f
	#	fi
	#done
	end=$(date +"%s")
	diff=$(($end-$start))
	echo "Resize of all files in $dest; took $(($diff / 60)) minutes and $(($diff % 60)) seconds"
}

# Catalog
dest=/catalog/catalog
width=170
height=170
resize $dest $width $height ''

# Main
dest=/catalog/main
width=645
height=645
resize $dest $width $height ''
