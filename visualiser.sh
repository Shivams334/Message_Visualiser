#!/bin/bash


#USAGE:
#	chmod +x visualiser.sh
#	./visualiser.sh audio.ogg image.png gif.gif username



STRING="Visualiser add awesomeness to your own voice"
echo $STRING

arg=$1
arg=$2
arg=$3
arg=$4

filename=(${arg//./ })

echo $filename

#convert image to the default facebook profile size i.e. 180x180px
convert $2 -resize 180x180\!  outputimage.png

#if you want a circle image
#convert output.png \( -size 400x400 xc:none -fill white -draw "circle 95,95 95,0" \) -compose copy_opacity -composite output-circle.png

#gif to video1
ffmpeg -f gif -i $3 output.mp4

#video1 looped
ffmpeg -f concat -i gif-list.txt -c copy output1.mp4

#audio.ogg waveform
ffmpeg -i $1 -filter_complex "[0:a]showwaves=s=1280x720,format=yuv420p[vid]" -map "[vid]" -map 0:a -codec:v libx264 -crf 18 -preset fast -codec:a aac -strict -2 -b:a 192k output2.mp4

#overlaying waveform with video1 looped
ffmpeg -i output2.mp4 -vf "movie=output1.mp4[inner];[in][inner] overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2 [out]" output3.mp4

#putting the image at the centre of the video
ffmpeg -i output3.mp4 -i outputimage.png -filter_complex "[0:v][1:v] overlay=(W-w)/2:(H-h)/2:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy output/$4.mp4

#cropping the final output for template
#ffmpeg -i outputfinal.mp4 -filter:v "crop=300:300:485:210" -c:a copy template01.mp4
