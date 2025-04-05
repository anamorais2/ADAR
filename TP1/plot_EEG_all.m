% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function plot_EEG_all(EEG,tittle)

    original_sampling_rate = 1000;  
    downsample_factor = 4;
    reduced_sampling_rate = original_sampling_rate / downsample_factor;  
    num_columns = 8;  
    num_rows = 8;  

    for trial_idx = 1:length(EEG)
        trial_data = EEG{trial_idx};  
        [num_channels, num_samples] = size(trial_data);
        time_vector = (0:num_samples-1) / reduced_sampling_rate;

        figure;
        for channel = 1:num_channels
            subplot(num_rows, num_columns, channel);
            plot(time_vector, trial_data(channel, :));
            title(['Canal ' num2str(channel)]);
            xlabel('Tempo (s)');
            ylabel('Amplitude (\muV)');
            grid on;
        end
        sgtitle([tittle num2str(trial_idx)]);
    end
end
