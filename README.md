# NDT_self-generated-data
Contains self-generated raster data converted to binned data.

# Random_raster_data
The Random_raster_data__Create_by_Maria.m code creates a simulation of the original raster data. 
The Random_raster_data__Create_by_Mariia.m file generates data, using a matrix of ones and zeros (the ratio of zeros to ones is approximately 1:1). 
By multiplying the matrix by another matrix of zeros and ones, the number of ones in the required matrix is reduced, i.e. the number of units is dissolved.

Output: 
mat-files: each mat-file contains information about each neuron (the number of channels and neurons are equal). 
Neurons are subdivided into stimulus-responsive and stimulus-unresponsive neurons. 
