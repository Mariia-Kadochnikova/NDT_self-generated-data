clc
clear 

%to measure the performance of my code
%tic 
tStart = cputime;

% add the path to the NDT so add_ndt_paths_and_init_rand_generator can be called
toolbox_basedir_name = 'ndt.1.0.4/'
addpath(toolbox_basedir_name);
 
% add the NDT paths using add_ndt_paths_and_init_rand_generator
add_ndt_paths_and_init_rand_generator

%the name of the directory where the raster-format data is stored
raster_file_directory_name = 'Y:\Personal\Masha\NDT_self-generated-data\Create_from_Raster\'
%raster_file_directory_name = 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Create_from_Raster\'


%the name (potentially including a directory) that the binned data should be saved as,
save_prefix_name = 'Binned_random_data_2_objects';
bin_width = 100; %a bin size that specifies how much time the firing rates should be calculated over,
step_size = 50; 

%The output of this function will be a file:
%mkdir Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Internet
%cd Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Internet
cd Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Masha
%cd C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster
create_binned_data_from_raster_data(raster_file_directory_name, save_prefix_name, bin_width, step_size);  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Determining how many times each condition was repeated
%load the binned data
load Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat
for k = 1:205
    inds_of_sites_with_at_least_k_repeats = find_sites_with_k_label_repetitions(binned_labels.stimulus_ID, k);
    num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
% to make sure that the random numbers are set the same each time
%rng(1) % to get the same curves on the graph as the output


%Creating a Datasource (DS) object
% the name of the file that has the data in binned-format
binned_format_file_name = 'Binned_random_data_2_objects_100ms_bins_50ms_sampled.mat'
%binned_format_file_name = 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\Raster_to_binned_with_my_function\Raster_to_binned_data.mat'
% will decode the identity of which object was shown (regardless of its position)
specific_label_name_to_use = 'stimulus_ID';
%  20 cross-validation runs
num_cv_splits = 20;
% Create a datasource that takes our binned data, and specifies that we want to decode
ds = basic_DS(binned_format_file_name, specific_label_name_to_use, num_cv_splits)
     %file_name = ['Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Internet\binned_data_DS'];
  file_name = ['Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Masha\binned_data_DS'];
    %file_name = ['C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\binned_data_DS'];
    save (file_name, 'ds');
    

%Creating a feature-preprocessor (FP) object
% create a feature preprocessor that z-score normalizes each neuron
% note that the FP objects are stored in a cell array, which allows multiple FP objects to be used in one analysis
the_feature_preprocessors{1} = zscore_normalize_FP;


%Creating a classifier (CL) object
% create the CL object
the_classifier = max_correlation_coefficient_CL;


%Creating a cross-validator (CV) object
% create the CV object
the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
% set how many times the outer 'resample' loop is run
% generally we use more than 2 resample runs which will give more accurate results, but to save time in this tutorial we are using a small number.
the_cross_validator.num_resample_runs = 10;


%Running the decoding analysis and saving the results
% run the decoding analysis
DECODING_RESULTS = the_cross_validator.run_cv_decoding;
%save_file_name = 'Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Internet\Binned_random_data_2_objects_DECODING_RESULTS'
save_file_name = 'Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Masha\Binned_random_data_2_objects_DECODING_RESULTS'
%save_file_name = 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\Binned_random_data_2_objects_DECODING_RESULTS'
%save_file_name = 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\Raster_to_binned_with_my_function\Binned_random_data_2_objects_DECODING_RESULTS'
save(save_file_name, 'DECODING_RESULTS');


%Plotting the results

result_names{1} = save_file_name;  
% create the plot results object
plot_obj = plot_standard_results_object(result_names);
% display the results
plot_obj.plot_results;
%saveas(gcf, 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\decoding_accuracy_as_a_function_of_time_1.png'); % save the results

%Plot the decoding accuracy as a function of time
% Specify the name of the file that we want to plot
result_names{1} = save_file_name;  
% create the plot results object
plot_obj = plot_standard_results_object(result_names);
% put a line at the time when the stimulus was shown
plot_obj.significant_event_times = 0;
% display the results
plot_obj.plot_results;
ylim([0 100]);
line([0 0], [0 100], 'color', [0.6 0.6 0.6]);
%saveas(gcf, 'Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Internet\decoding_accuracy_as_a_function_of_time.png');
saveas(gcf, 'Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\by_code_from_Masha\decoding_accuracy_as_a_function_of_time.png');
%saveas(gcf, 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\Raster_to_binned_with_my_function\decoding_accuracy_as_a_function_of_time_WITH_rng_2.png');
%saveas(gcf, 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\decoding_accuracy_as_a_function_of_time_WITH_rng_2.png.png'); 


% Plot temporal cross training decoding accuracies
% create the plot results object
% note that this object takes a string in its constructor not a cell array
plot_obj_matrix = plot_standard_results_TCT_object(save_file_name);
% put a line at the time when the stimulus was shown
plot_obj_matrix.significant_event_times = 0;
% display the results
plot_obj_matrix.plot_results;
ylim([0 100]);
line([0 0], [0 100], 'color', [0.6 0.6 0.6]);
%saveas(gcf, 'Y:\Personal\Masha\NDT_self-generated-data\Binned_data_after_Raster\temporal_cross_training_decoding_accuracies.png');
%saveas(gcf, 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\Raster_to_binned_with_my_function\temporal_cross_training_decoding_accuracies_WITH_rng_2.png'); % save the results
%saveas(gcf, 'C:\Data\Mariia\testNDT\Created_data_by_Mariia\Binned_data_after_Raster\temporal_cross_training_decoding_accuracies_WITH_rng_2.png');


%tEnd = cputime - tStart
%toc
beep