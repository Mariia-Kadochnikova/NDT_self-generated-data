% create raster-format data

clc
clear

% raster_data_dir = 'Y:\Personal\Masha\NDT_self-generated-data\Create_from_Raster';
raster_data_dir = 'Y:\Personal\Igor\NDT_self-generated-data\Create_from_Raster';


mkdir(raster_data_dir);



% create raster_data

n_time=1000;
n_trials=400;


raster_site_info.session_ID = 0;
create_stimul = zeros(n_trials,n_time/2)+ randi([0 1],n_trials,n_time/2);

% create raster_labes
    label_in_order = 1+[zeros(1,n_trials/2) 1.*ones(1,n_trials/2)]; % create a matrix with a order of stimuli
    raster_labels.stimulus_ID = label_in_order ;
    %raster_labels.stimulus_ID = reshape(label_in_order(randperm(numel(label_in_order))), size(label_in_order)); % create a matrix with a random order of stimuli 
    name_of_conditionals = ["First_condition", "Second_condition"];
    all_numbers_of_raster_labels = unique(raster_labels.stimulus_ID(:)); % returns the same data as in raster_labels.stimulus_ID, but with no repetitions
    raster_labels.stimulus_ID = string(categorical(raster_labels.stimulus_ID,all_numbers_of_raster_labels,name_of_conditionals)); % replace numbers with text
    raster_labels.stimulus_ID = cellstr (raster_labels.stimulus_ID); % convert string to cell
    
    
    
    
% neuroms with the answer 
num_of_neurons_with_answer = 10;
for n = 1:num_of_neurons_with_answer;
    
    %rng(1)
    before_stimul = create_stimul.*randi([0 1],n_trials,n_time/2); % trials x time/2 (before stimul)
    %make the number of zeros higher and the number of ones lower
    %to make the matrix more similar to the original data
    %to multiply the "before_stimul" by the matrix of zeros and ones as many times as specified in the variable "repetition_rate__before_stimul"
    repetition_rate__before_stimul=6;
    while repetition_rate__before_stimul>0 
        
        before_stimul_2 = before_stimul.*randi([0 1],n_trials,n_time/2);
        before_stimul = before_stimul_2; 
        repetition_rate__before_stimul=repetition_rate__before_stimul - 1;
    end
    
   
  
    % to make the neuron's response most intense from 100 ms to 300 ms after the stimulus
    
    after_stimul_1 (:, 1:n_time/10) = create_stimul(:, 1:n_time/10).*randi([0 1],n_trials,n_time/10); % trials x time/2 (after stimul)
    after_stimul_2 (:, 1:n_time/5) = create_stimul(:, 1:n_time/5).*randi([0 1],n_trials,n_time/5);
    after_stimul_3 (:, 1:n_time/5) = create_stimul(:, 1:n_time/5).*randi([0 1],n_trials,n_time/5);

    % first 100 ms after stimulus
    repetition_rate__after_stimul=4; 
    while repetition_rate__after_stimul>0
        
        after_stimul_1_next = after_stimul_1.*randi([0 1],n_trials,n_time/10);
        after_stimul_1 = after_stimul_1_next; 
        repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end
    
    % second 200 ms after stimulus
    repetition_rate__after_stimul=2; 
    while repetition_rate__after_stimul>0
        
        after_stimul_2_next = after_stimul_2.*randi([0 1],n_trials,n_time/5);
        after_stimul_2 = after_stimul_2_next; 
        repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end
    
    % third 200 ms after stimulus
    repetition_rate__after_stimul=3; 
    while repetition_rate__after_stimul>0
        
        after_stimul_3_next = after_stimul_3.*randi([0 1],n_trials,n_time/5);
        after_stimul_3 = after_stimul_3_next; 
        repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end
    after_stimul = [after_stimul_1 after_stimul_2 after_stimul_3];
    
    
    % answers on the FIRST and SECOND stimul 
    after_stimul_FIRST = after_stimul(1:200, :);
    after_stimul_SECOND = after_stimul(201:400, :);
    
    % FIRST stimul 
    y =  randi([0 1],1,1);
    repetition_rate__after_stimul=y; 
    while repetition_rate__after_stimul>0
        
        after_stimul_FIRST_next = after_stimul_FIRST.*randi([0 1],n_trials/2,n_time/2);
        after_stimul_FIRST = after_stimul_FIRST_next; 
        repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end
    
    % SECOND stimul
    z =  randi([0 1],1,1);
    repetition_rate__after_stimul=z; 
    while repetition_rate__after_stimul>0
        
        after_stimul_SECOND_next = after_stimul_SECOND.*randi([0 1],n_trials/2,n_time/2);
        after_stimul_SECOND = after_stimul_SECOND_next; 
        repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end
    
    
    after_stimul = [after_stimul_FIRST; after_stimul_SECOND];
    raster_data=([before_stimul after_stimul]); % trials x time

    % view the rasters from one neuron
    figure(n);
    subplot(2, 2, 1)
    imagesc(~raster_data); colormap gray
    line([500 500], get(gca, 'YLim'), 'color', [1 0 0]);
    ylabel('Trials')
    xlabel('Time (ms)')
    title('rasters')

    % view the PSTH for one neuron
    subplot(2, 2, 2)
    bar(sum(raster_data));
    line([500 500], [0 30], 'color', [1 0 0]);
    ylim([0 30]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('PSTH')
    
    % view the C1 for one neuron
    frequency_raster_data = sum(raster_data); % frequency = spikes/sec (Hz)
    subplot(2, 2, 3)
    bar(sum(raster_data(1:200, :))); 
    line([500 500], [0 30], 'color', [1 0 0]);
%     hold on; 
%     plot(sum(raster_data),'Color',[0,1,0]);
    ylim([0 30]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('C1')
    
     % view the C2 for one neuron
    subplot(2, 2, 4)
    bar(sum(raster_data(201:400, :)));
    line([500 500], [0 30], 'color', [1 0 0]);
    ylim([0 30]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('C2')

    
    folder_of_file{1} = [raster_data_dir filesep];
    %date_time_now = datestr(now,'dd-mm-yy_HH-MM-FFF'); %info about real time (text representing dates and times)
    num_of_repetitions = [1:1:n];
    fig_name = [folder_of_file{1}, 'random_raster_data_neuron_S_', num2str(raster_site_info.session_ID), '_Ch_', num2str(num_of_repetitions(:, n)), '_with_answer.png']; %create path and fig name
    saveas(gcf, fig_name); % save the figure 

         
    % create raster_site_info 
    raster_site_info.recording_channel = n;
    raster_site_info.unit = 'with_answer';
    raster_site_info.alignment_event_time = 501; 
    
    % save file
    name = ['random_raster_data_neuron_S_' num2str(raster_site_info.session_ID) '_Ch_' num2str(num_of_repetitions(:, n)) '_with_answer.mat'];
    
    file_name = [folder_of_file{1} name]; %create file name;
    save(file_name,'raster_data', 'raster_labels', 'raster_site_info');
    
end




% neuroms without the answer
num_of_neurons_without_answer = 8;
for n = 1:num_of_neurons_without_answer
    
    %rng(1)
    before_stimul = create_stimul.*randi([0 1],n_trials,n_time/2); % trials x time/2 (before stimul)
    %make the number of zeros higher and the number of ones lower
    %to make the matrix more similar to the original data
    %to multiply the "before_stimul" by the matrix of zeros and ones as many times as specified in the variable "repetition_rate__before_stimul"
    repetition_rate__before_stimul=6;
    while repetition_rate__before_stimul>0 
        before_stimul_2 = before_stimul.*randi([0 1],n_trials,n_time/2);
        before_stimul = before_stimul_2; 
        repetition_rate__before_stimul=repetition_rate__before_stimul - 1;
    end


    after_stimul = create_stimul.*randi([0 1],n_trials,n_time/2); % trials x time/2 (after stimul)

    repetition_rate__after_stimul=6;
    while repetition_rate__after_stimul>0 
       after_stimul_2 = after_stimul.*randi([0 1],n_trials,n_time/2);
       after_stimul = after_stimul_2; 
       repetition_rate__after_stimul=repetition_rate__after_stimul - 1;
    end


    raster_data=([before_stimul after_stimul]); % trials x time

    % view the rasters from one neuron
    figure(n);
    subplot(2, 2, 1)
    imagesc(~raster_data); colormap gray
    line([500 500], get(gca, 'YLim'), 'color', [1 0 0]);
    ylabel('Trials')
    xlabel('Time (ms)')
    title('rasters')

    % view the PSTH for one neuron
    subplot(2, 2, 2)
    bar(sum(raster_data));
    line([500 500], [0 25], 'color', [1 0 0]);
    ylim([0 25]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('PSTH')

    % view the C1 for one neuron
    frequency_raster_data = sum(raster_data); % frequency = spikes/sec (Hz)
    subplot(2, 2, 3)
    bar(sum(raster_data(1:200, :))); 
    line([500 500], [0 25], 'color', [1 0 0]);
%   hold on; 
%   plot(mean(sum(raster_data)),'Color',[0,1,0]);
%   hold on
%   plot(1:length(frequency_raster_data),frequency_raster_data,'r')
    ylim([0 25]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('C1')
    
    % view the C2 for one neuron
    subplot(2, 2, 4)
    bar(sum(raster_data(201:400, :)));
    line([500 500], [0 25], 'color', [1 0 0]);
    ylim([0 25]);
    ylabel('Number of spikes')
    xlabel('Time (ms)')
    title('C2')
    
    %date_time_now = datestr(now,'dd-mm-yy_HH-MM-FFF'); %info about real time (text representing dates and times)
    fig_name = [folder_of_file{1}, 'random_raster_data_neuron_S_', num2str(raster_site_info.session_ID), '_Ch_', num2str(num_of_repetitions(:, n)), '_without_answer.png']; %create path and fig name
    saveas(gcf, fig_name); % save the figure 


    % create raster_site_info 
    raster_site_info.recording_channel = n;
    raster_site_info.unit = 'without_answer';
    raster_site_info.alignment_event_time = 501; 
    
    % save file
    name = ['random_raster_data_neuron_S_' num2str(raster_site_info.session_ID) '_Ch_' num2str(num_of_repetitions(:, n)) '_without_answer.mat'];
    
    file_name = [folder_of_file{1} name]; %create file name;
    save(file_name,'raster_data', 'raster_labels', 'raster_site_info');
    
end

