// Colormap
run("Green");

// Auto Brightness/Contrast, adjust saturated if needed
run("Enhance Contrast", "saturated=0.35"); 

// Set pixel-size, and create scale bar
//run("Set Scale...", "distance=25 known=1 unit=um");
run("Scale Bar...", "width=5 height=77 thickness=6 font=16 color=White background=None location=[Lower Right] horizontal bold overlay");

// Label images through stack, timing for timelapse (15m intervals)
run("Label...", "format=00:00 starting=0 interval=15 x=5 y=20 font=20 text=[] range=1-100 use");