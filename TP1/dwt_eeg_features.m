% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function [delta_power, theta_power, alpha_power, beta_power, gamma_power] = dwt_eeg_features(EEG_in, waveletType)
    num_trials = length(EEG_in);
    num_channels = size(EEG_in{1}, 1);
    
    % Determina o número de níveis dinamicamente
    signal_length = size(EEG_in{1}, 2);
    numLevels = floor(log2(signal_length)); % Garantir níveis suficientes
    numLevels = min(numLevels, 5); % Limitar a no máximo 5

    % Inicializa as matrizes de potência
    delta_power = zeros(num_trials, num_channels);
    theta_power = zeros(num_trials, num_channels);
    alpha_power = zeros(num_trials, num_channels);
    beta_power  = zeros(num_trials, num_channels);
    gamma_power = zeros(num_trials, num_channels);

    for trial_idx = 1:num_trials
        trial_data = EEG_in{trial_idx};

        for ch = 1:num_channels
            % Decomposição DWT
            [C, L] = wavedec(trial_data(ch, :), numLevels, waveletType);
            maxLevels = length(L) - 2; % Níveis máximos reais

            % Extrai coeficientes se o nível existir
            D1 = detcoef(C, L, 1);  
            D2 = detcoef(C, L, min(2, maxLevels));  
            D3 = detcoef(C, L, min(3, maxLevels));  
            D4 = detcoef(C, L, min(4, maxLevels));  
            D5 = detcoef(C, L, min(5, maxLevels));  
            A5 = appcoef(C, L, waveletType, min(5, maxLevels));  

            % Calcula a potência (se o nível existir)
            gamma_power(trial_idx, ch) = mean(D1.^2) + mean(D2.^2);
            beta_power(trial_idx, ch)  = mean(D3.^2);
            alpha_power(trial_idx, ch) = mean(D4.^2);
            theta_power(trial_idx, ch) = mean(D5.^2);
            delta_power(trial_idx, ch) = mean(A5.^2);
        end
    end
end
