// input / output directories
dir = "E:\\ImageJ_Macros\\3. batch_save_dual_color\\"
input  = dir + "data\\";
output = dir + "output\\";

// series to combine
image_series1 = 4;
image_series2 = 5;

// make output directory
if (File.exists(output) != true)
	File.makeDirectory(output);

// set to true to enable without displaying
setBatchMode(false); 

// obtain list of files from input directory
list = getFileList(input);

// loop through images
for (i = 0; i != list.length; i++)
{
	// define file, path and filename without extension
    file = list[i];
	path = input + file; 
	name = substring(file, 0, indexOf(file, ".msr"));
	
	// opens image at series number of the msr file
	run("Bio-Formats Importer", "open=&path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + image_series1);
	name_channel1 = output + name + "_ch1.tif";
	saveAs("Tiff",  name_channel1);

	
	// opens image at series number of the msr file
	run("Bio-Formats Importer", "open=&path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + image_series2);
	name_channel2 = output + name + "_ch2.tif";
	saveAs("Tiff",  name_channel2);
	
	// Merge channels (c1 - red, c2 - green, c3 - blue, c4 - gray, c5 - cyan, c6 - magenta, c7 - yellow)
	run("Merge Channels...", "c6=" + name + "_ch1.tif" + " c2=" + name + "_ch2.tif" + " keep");
	saveAs("PNG",  output + name + "_merged.png");

	close("*");


}

