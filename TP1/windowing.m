% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function [EEG_windowed] = windowing(recons_EEG, flag)
   
    EEG_windowed = recons_EEG; 

    for trial_idx = 1:length(recons_EEG)
        trial_data = recons_EEG{trial_idx};  
        [num_channels, num_samples] = size(trial_data);

        % Seleciona a função de janela com base no argumento 'flag'
        switch lower(flag)
            case 'hamming'
                window_function = hamming(num_samples)';
            case 'blackman'
                window_function = blackman(num_samples)';
            case 'hann'
                window_function = hann(num_samples)';
            case 'triangular'
                window_function = triang(num_samples)';
            otherwise
                error('Tipo de janela não reconhecido. Escolha: hamming, blackman, hann, triangular.');
        end

        % Aplica a janela ao longo do tempo em cada canal
        for channel = 1:num_channels
            trial_data(channel, :) = trial_data(channel, :) .* window_function;
        end

        EEG_windowed{trial_idx} = trial_data; 
    end
end
