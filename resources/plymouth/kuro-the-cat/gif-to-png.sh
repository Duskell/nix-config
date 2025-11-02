# it's not pronounced JIF!!!!
# Also I haven't tested this so it might not work. 

rm -r ./output/progress_*.png
convert ./input/boot.gif ./output/progress_%03d.png
