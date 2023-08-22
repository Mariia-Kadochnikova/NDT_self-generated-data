# NDT_self-generated-data
This project deals with self-generated raster data converted to binned data, which are then decoded using NDT.

The code requires NDT.


# Random_raster_data
The Random_raster_data__Create_by_Mariia.m code creates a simulation of the raster data (0 and 1 at 1 ms resolution).


Algorithm: Random_raster_data__Create_by_Mariia.m file generates data, using a matrix of ones and zeros (the ratio of zeros to ones is approximately 1:1). 
By multiplying the matrix by another matrix of zeros and ones, the number of ones in the required matrix is reduced.

Output:
                                                                           
mat-files: files such as random_raster_data_neuron_S_0_Ch_2_with_answer.mat, where each mat-file contains information about one neuron. 
Neurons are subdivided into stimulus-responsive ("with answer") and stimulus-unresponsive ("without answer") neurons. 

plots:                                                                                       
such as random_raster_data_neuron_S_0_Ch_1_without_answer.png


# Raster_to_Binned_data
The Mariia__Raster_to_Binned_data.m code converts raster data to binned data.

Output:                                                                        
mat-file: Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat 


# Neural_Decording_Toolbox
The Mariia__Neural_Decording_Toolbox.m code makes binned data from raster data and then performs decoding. 

Output:                                                                        
mat-files: 
Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat (contains binned data),
binned_data_DS.mat (contains Datasource information), 
Binned_random_data_2_objects_DECODING_RESULTS.mat (contains the result of decoding)

plots: 
decoding_accuracy_as_a_function_of_time.png (graph of decoding accuracy as a function of time) 
