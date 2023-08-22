# NDT_self-generated-data
This project deals with self-generated raster data converted to binned data, which are then decoded using NDT.

The code requires NDT.


# Random_raster_data
The Mariia__Random_raster_data.m code creates a simulation of the raster data (0 and 1 at 1 ms resolution).


Algorithm: Mariia__Random_raster_data.m file generates data, using a matrix of ones and zeros (the ratio of zeros to ones is approximately 1:1). 
By multiplying the matrix by another matrix of zeros and ones, the number of ones in the required matrix is reduced.

Input: not required                                                                                              

Output:                                                                                                                       
mat-files: files such as random_raster_data_neuron_2_with_response.mat, where each mat-file contains information about one neuron. 
Neurons are subdivided into stimulus-responsive ("with response") and stimulus-unresponsive ("without response") neurons. 

plots: such as random_raster_data_neuron_1_without_response.png


# Raster_to_Binned_data
The Mariia__Raster_to_Binned_data.m code converts raster data to binned data.

Input:                                                                                                                   
mat-files: from folder ...\Raster data                                                                           

Output:                                                                        
mat-file: Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat 


# Neural_Decording_Toolbox
The Mariia__Neural_Decording_Toolbox.m code makes binned data from raster data and then performs decoding. 

Input:                                                                                                                              
mat-files:                                                                                                                            
1. from folder ...\Raster data                                                                                                                  
or                                                                                                                                                                                                                         
2. from folder ...\Binned_data\from_own_code                                                                                                                                                                                  

Output:                                                                        
mat-files: 
Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat (contains binned data),
binned_data_DS.mat (contains Datasource information), 
Binned_random_data_2_objects_DECODING_RESULTS.mat (contains the result of decoding)

plots: 
decoding_accuracy_as_a_function_of_time.png (graph of decoding accuracy as a function of time) 
