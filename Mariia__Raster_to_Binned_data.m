%  Mariia__Raster_to_Binned_data

clc
clear 

run('Mariia__NDT_settings');

input_files_folder = [BASE_PATH 'NDT_self-generated-data\Create_from_Raster\']; % Specify the folder where the files live.
binned_data_dir = [BASE_PATH 'NDT_self-generated-data\Binned_data\from_own_code\'];

mkdir(binned_data_dir);
output_path = cd(binned_data_dir);



%% Check to make sure that folder actually exists.  Warn user if it doesn't.

if ~isfolder(input_files_folder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', input_files_folder);
    uiwait(warndlg(errorMessage));
    return;
end

%% Loading raster files
% Get a list of all files in the folder with the desired file name pattern.

filePattern = fullfile(input_files_folder, 'random_raster_data_neuron_S_0_Ch_*.mat'); % Change to whatever pattern you need.
matFiles = dir(filePattern);
for k = 1:length(matFiles)
    baseFileName = matFiles(k).name;
    fullFileName = fullfile(input_files_folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    matData(k) = load(fullFileName); % matData contain all information from raster data files
end

%% create variable called the_labels
Size_matData = size (matData);
for q = 1:Size_matData (1, 2)
    stimulus_ID{1, q} = matData(q).raster_labels.stimulus_ID ;
end 
   binned_labels.stimulus_ID = stimulus_ID;
%% number of cross-validation
ds.num_cv_splits  = 20 ; % 20 cross-validation runs


%% Create binned_site_info
for w = 1:Size_matData (1, 2)
    binned_site_info.session_ID (w, 1) = matData(w).raster_site_info.session_ID ;
    binned_site_info.recording_channel (w, 1) = matData(w).raster_site_info.recording_channel ;
    binned_site_info.unit {1, w} = matData(w).raster_site_info.unit ;
    binned_site_info.alignment_event_time(w, 1) = matData(w).raster_site_info.alignment_event_time ;
    
end 
 
%% Create binned_site_info.binning_parameters  
binned_site_info.binning_parameters.raster_file_directory_name = input_files_folder ;
binned_site_info.binning_parameters.bin_width = 100;  % a bin size that specifies how much time the firing rates should be calculated over,
binned_site_info.binning_parameters.sampling_interval = 50; 
binned_site_info.binning_parameters.start_time  = 1;
binned_site_info.binning_parameters.end_time = length(matData(1).raster_data); % Length on example of just one file, as the length of all time pieces for all files must be equal. 

if (length(binned_site_info.binning_parameters.bin_width) == 1) && (length(binned_site_info.binning_parameters.sampling_interval) == 1); % if a single bin width and step size have been specified, then create binned data that averaged data over bin_width sized bins, sampled at sampling_interval intervals
    bin_start_time = binned_site_info.binning_parameters.start_time : binned_site_info.binning_parameters.sampling_interval : (binned_site_info.binning_parameters.end_time - binned_site_info.binning_parameters.bin_width  + 1);
    bin_widths = binned_site_info.binning_parameters.bin_width .* ones(size(bin_start_time)); 
end 
binned_site_info.binning_parameters.the_bin_start_times = bin_start_time;
binned_site_info.binning_parameters.the_bin_widths = bin_widths;

for t = 1:Size_matData (1, 2) 
    binned_site_info.binning_parameters.alignment_event_time = matData(t).raster_site_info.alignment_event_time ;
end 

%% Create binned data
  for r = 1:Size_matData (1, 2)
  
        binned_data{:, r} = bin_one_site (matData(r).raster_data, binned_site_info.binning_parameters.the_bin_start_times, binned_site_info.binning_parameters.the_bin_widths);
  end

  
%% save
 file_name = [output_path '\Binned_random_data_2_objects_' num2str(binned_site_info.binning_parameters.bin_width) 'ms_bins_' num2str(binned_site_info.binning_parameters.sampling_interval) 'ms_sampled.mat'];
 save (file_name, 'binned_data', 'binned_labels', 'binned_site_info');
 fprintf(1, 'Now saving %s\n', file_name);
 
 
 %% create basic_DS format of "ds" variable 
 ds = basic_DS(binned_data, binned_labels , ds.num_cv_splits);
 
 %% save
%  file_name = [output_path '\Raster_to_binned_data_DS.mat'];
%  save (file_name, 'ds');
 
 
 
 %% Create binned data
 function  binned_data = bin_one_site(raster_data, the_bin_start_times, the_bin_widths)  
% a helper function that bins the data for one site
  for c = 1:length(the_bin_start_times)      
      binned_data(:, c) = mean(raster_data(:, the_bin_start_times(c):(the_bin_start_times(c) + the_bin_widths(c) -1)), 2);            
  end
 end 
