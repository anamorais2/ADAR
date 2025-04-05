% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function [trials, EEG_downsampled, num_channels] = preprocess_EEG(cnt_file, base_path, remove_trials)

    % open the .cnt files usinf loadcnt function
    cnt = loadcnt(base_path + cnt_file);

    channels = {cnt.electloc.lab};
    
    non_channel_names = {'VEO', 'HEO', 'M1', 'M2'};

    % Encontrar índices dos canais que são EEG
    EEG_indices = ~ismember(channels, non_channel_names); %A função ismember é usada para verificar se o nome do canal está na lista de canais não EEG. A inversão ~ retorna os índices dos canais que não estão na lista de exclusão (ou seja, são EEG).
    
    % Filtrar dados correspondentes apenas a EEG
    EEG_data = cnt.data(EEG_indices, :);

    downsample_factor = 4;
    % Definir os pontos de início e fim das tentativas (em amostras) antes do downsampling
    start_point_list = [27000,290000,551000,784000,1050000,1262000,1484000,1748000,1993000,2287000,2551000,2812000,3072000,3335000,3599000];
    end_point_list = [262000,523000,757000,1022000,1235000,1457000,1721000,1964000,2258000,2524000,2786000,3045000,3307000,3573000,3805000];
    
    start_points_downsampled = ceil(start_point_list / downsample_factor);
    end_points_downsampled = ceil(end_point_list / downsample_factor);
    
    %downsampling
    EEG_downsampled = downsample(EEG_data', downsample_factor)';
    
    trials = cell(1, length(start_points_downsampled));
    for i = 1:length(start_points_downsampled)
        trials{i} = EEG_downsampled(:, start_points_downsampled(i):end_points_downsampled(i));
    end

    num_channels = size(EEG_downsampled, 1);
    
    %{
    % Plot EEG trials
    original_sampling_rate = 1000;
    reduced_sampling_rate = original_sampling_rate / downsample_factor;
    num_columns = 8;
    num_rows = 8;
    
    for trial_idx = 1:length(trials)
        trial_data = trials{trial_idx};
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
        sgtitle(['Registos de EEG - Tentativa ' num2str(trial_idx)]);


    end
    %}
    
    trials(:, remove_trials) = [];
    
end

