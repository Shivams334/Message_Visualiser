#converting the image to 180x180 size
convert any-fileformat.jpg -resize 180x180\!  output.png

#change the shape to circle
convert output.png \( -size 400x400 xc:none -fill white -draw "circle 89.5,89.5 89.5,0" \) -compose copy_opacity -composite output-circle.png

#add the circle shaped image at the centre of the video
ffmpeg -i video.mp4 -i output-circle.png -filter_complex "[0:v][1:v] overlay=(W-w)/2:(H-h)/2:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy output.mp4

