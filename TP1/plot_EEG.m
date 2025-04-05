% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function plot_EEG(trials_data, EEG_downsampled, trial_number, channel_number)
 
    % Verificar se o trial_number e channel_number são válidos
    num_trials = length(trials_data);
    num_channels = size(EEG_downsampled, 1);

    if trial_number < 1 || trial_number > num_trials
        error('Número de trial inválido! Escolha um entre 1 e %d.', num_trials);
    end
    if channel_number < 1 || channel_number > num_channels
        error('Número de canal inválido! Escolha um entre 1 e %d.', num_channels);
    end

    % Definir a frequência de amostragem original e reduzida
    original_sampling_rate = 1000; % Hz
    downsample_factor = 4; % Exemplo de fator de downsampling
    reduced_sampling_rate = original_sampling_rate / downsample_factor;

  
    figure;

    trial_data = trials_data{trial_number};
    [~, num_samples_trial] = size(trial_data);
    time_vector_trial = (0:num_samples_trial-1) / reduced_sampling_rate;

    subplot(1,1,1);
    plot(time_vector_trial, trial_data(channel_number, :), 'b'); 
    title(['Trial ', num2str(trial_number), ' - Canal ', num2str(channel_number)]);
    xlabel('Tempo (s)');
    ylabel('Amplitude (μV)');
    grid on;

    sgtitle(['Visualização do EEG - Canal ', num2str(channel_number), ', Trial ', num2str(trial_number)]);
end
