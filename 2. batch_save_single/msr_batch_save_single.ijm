// input / output directories
dir = "E:\\ImageJ_Macros\\2. batch_save_single\\"
input  = dir + "data\\";
output = dir + "output\\";

// series to combine
image_series1 = 3;

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

	// save as tif
	saveAs("Tiff",  output + name + ".tif");
	
	// Colormap
	run("Red hot");

	// Save as png
	saveAs("PNG",  output + "cmap_" +  name + ".png");

	close("*");


}

