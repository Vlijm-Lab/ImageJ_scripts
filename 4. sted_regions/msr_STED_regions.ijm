// input / output directories
dir = "E:\\ImageJ_Macros\\4. sted_regions\\"
input  = dir + "data\\";
output = dir + "output\\";


// sted image series number
sted_image_series = 12;
conf_image_series = 2;

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
	// obtain file name and path
	file = list[i];
	path = input + file; 
	name = substring(file, 0, indexOf(file, ".msr"));

    //run the bio-format macro
    run("Bio-Formats Macro Extensions");
    Ext.setId(path); 
	Ext.getCurrentFile(file); 
	Ext.getSeriesCount(seriesCount); // this gets the number of fields 
	print("file:" + name + ", total series: " + seriesCount); 

	// Open STED image
	run("Bio-Formats Importer", "open=&path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + sted_image_series);    
	
	// Obtain STED FOV, in micrometers
	info = getInfo();
	i0 = indexOf(info, "Lengths = [");
	i1 = indexOf(info, ",", i0);
	i2 = indexOf(info, ",", i1+1);
	w = 1E6 * substring(info, i0+11, i1); 
	h = 1E6 * substring(info, i1+2, i2); 
	
	// Obtain offsets
	i0 = indexOf(info, "Offsets = [");
	i1 = indexOf(info, ",", i0);
	i2 = indexOf(info, ",", i1+1);
	x = 1E6 * substring(info, i0+11, i1);
	y = 1E6 * substring(info, i1+2, i2);

	close();


	// Open confocal image
	run("Bio-Formats Importer", "open=&path autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + conf_image_series);    
	info = getInfo();
	i0 = indexOf(info, "Resolution: ");
	i1 = indexOf(info, "pixels", i0);
	pxs = 1 / substring(info, i0+12, i1);
	
	i0 = indexOf(info, "Lengths = [");
	i1 = indexOf(info, ",", i0);
	i2 = indexOf(info, ",", i1+1);
	cw = 1E6 * substring(info, i0+11, i1); 
	ch = 1E6 * substring(info, i1+2, i2); 
	
	i_off0 = indexOf(info, "Offsets = [");
	i_off1 = indexOf(info, ",", i_off0);
	i_off2 = indexOf(info, ",", i_off1+1);
	xs = 1E6 * substring(info, i_off0+11, i_off1);
	ys = 1E6 * substring(info, i_off1+2, i_off2);

	// colormap and brightness/contrast
    run("Green");
    run("Enhance Contrast", "saturated=0.35");
    
	// Rectangle info
	xr = (x - xs)/pxs;
	yr = (y - ys)/pxs;
	
	wr = w/pxs;
	hr = h/pxs;
	
    // draw STED FOV    	
    makeRectangle(xr, yr, wr, hr);
    run("Properties... ", "  stroke=White");
    run("Add Selection...");
	run("Flatten");

	// save image
	saveAs("PNG", output + name + ".png");
	close("*");
}
