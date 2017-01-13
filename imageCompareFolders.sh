#!/bin/bash
export srcFolder=$1
export tgtFolder=$2
export size=$3
export suffix=$4
export resolution=$5

if [ -z $srcFolder ]; then
   read -p "Enter Source Folder : " srcFolder
fi
if [ -z $tgtFolder ]; then
   read -p "Enter Target Folder : " tgtFolder
fi
if [ -z $size ]; then
   read -p "Enter size (in AxB format) : " size
fi
if [ -z $suffix ]; then
   read -p "Enter image suffix (jpeg or png) : " suffix
fi
if [ -z $resolution ]; then
   export resolution=72
fi

echo "comparing images from Folder $srcFolder to Folder $tgtFolder"
echo "started at $(date)"

for file in $srcFolder/*.$suffix 
do
	convert -flatten -strip -units PixelsPerInch -density $resolution -resize $size $file ./src.$suffix
	filename=$(basename $file)
	convert -flatten -strip -units PixelsPerInch -density $resolution -resize $size $tgtFolder/$filename ./tgt.$suffix
	compare -metric RMSE ./src.$suffix ./tgt.$suffix ./difference.$suffix &>compare.out
	echo "$(cat compare.out) : comparison result = $filename"
	rm compare.out
done

rm ./src.$suffix
rm ./tgt.$suffix
rm ./difference.$suffix

echo "finished at $(date)"