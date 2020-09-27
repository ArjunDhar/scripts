#!/bin/bash

source=/catalog/original

# Resize - Convert the largest images into smaller images of various sizes.
# Note: Please ensure the main site catalog folder is synched with the contnt folder.

#This Method is ONLY used when we want to Resize only NEW/UPDATED fles and not all files all over again
resize_delta()
{
	echo "DELTA MODE - Only Resizing new Files"

	dest=$1
	width=$2
	height=$3
	filter=$4

	# Clean out files from DEST folder that are no longer in Source
	echo "Cleaning redundant files ...."
	for f in $(find $dest/*)
	do
		fname=$(basename $f)
		if [ ! -f $source/$fname ]; #File in DEST that no longer exists in SOURCE
		then
			rm $f
		fi
	done

	echo "Resize files that are more recent in source folder OR files that dont exist in the destination ...."
	start=$(date +"%s")
	for f in $(find $source/* -name *$filter.png -or -name *$filter.jpg -or -name *$filter.jpeg)
	#Note: For some reason $f isnt getting the proper absolute path for the file
	do
		echo processing $f
		fname=$(basename $f)
		extension=$(echo ${fname}|awk -F\. '{print $2}')
		if [ -f $dest/$fname ]; #Destination File Exists and source is a genuine file
		then
			if test $dest/$fname -nt $f #Resized File that exists is RECENT than Source hence its up to date For this it is important to ensure while cp -p option is enabled so date time is not modified
			then
				echo "$dest/$fname exists so skipping it"	
			else	
				#echo convert and overwrite $f to $dest/$fname
				convert $f -resize $widthx$height $dest/$fname
			fi
		else
			#echo convert $f to $dest/$fname
			convert $f -resize $widthx$height $dest/$fname
		fi
	done
	end=$(date +"%s")
	diff=$(($end-$start))
	echo "Resize from $source to $dest; took $(($diff / 60)) minutes and $(($diff % 60)) seconds"
}

resize()
{
	dest=$1
	width=$2
	height=$3
	filter=$4

	rm $dest/* -rf
	echo Cleard $dest folder
	start=$(date +"%s")
	for f in $(find $source/* -name *$filter.png -or -name *$filter.jpg -or -name *$filter.jpeg)
	do
		# echo processing $f
		fname=$(basename $f)
		convert $f -resize $widthx$height $dest/$fname
	done
	end=$(date +"%s")
	diff=$(($end-$start))
	echo "Resize from $source to $dest; took $(($diff / 60)) minutes and $(($diff % 60)) seconds"
}

# Catalog
dest=/catalog/catalog
width=170
height=170
resize_delta $dest $width $height ''

# Main
dest=/catalog/main
width=645
height=645
resize_delta $dest $width $height ''
