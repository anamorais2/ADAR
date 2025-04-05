% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function [EEG_filtered] = filt(EEG_signals, Num, Den, sampling_rate, tittle)
    
    EEG_filtered = cell(size(EEG_signals));
    
    for i = 1:length(EEG_signals)
        num_channels = size(EEG_signals{i}, 1);
        num_samples = size(EEG_signals{i}, 2); 
        EEG_filtered{i} = zeros(num_channels, num_samples);
        
        for ch = 1:num_channels
            EEG_filtered{i}(ch, :) = filter(Num, Den, EEG_signals{i}(ch, :));
        end
    end

    % Calcula o espectro antes e depois da filtragem para comparação
    [EEG_spectrum_before, freq_vector_before] = spectrum(EEG_signals,sampling_rate);
    [EEG_spectrum_after, freq_vector_after] = spectrum(EEG_filtered ,sampling_rate);

    trial_idx = 1; 
    channel_idx = 1; 
    
    spectrum_before = EEG_spectrum_before{trial_idx}(channel_idx, :);
    spectrum_after = EEG_spectrum_after{trial_idx}(channel_idx, :);
    
    % Garante que os vetores de frequência e espectro tenham o mesmo comprimento
    max_length = max(length(freq_vector_before), length(spectrum_before));
    freq_vector_before(end+1:max_length) = 0;
    spectrum_before(end+1:max_length) = 0;
    
    max_length = max(length(freq_vector_after), length(spectrum_after));
    freq_vector_after(end+1:max_length) = 0;
    spectrum_after(end+1:max_length) = 0;

        figure;
    plot(freq_vector_before, spectrum_before, 'r', 'LineWidth', 1.2); hold on;
    plot(freq_vector_after, spectrum_after, 'b', 'LineWidth', 1.2);
    
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title([tittle num2str(trial_idx) ' Canal ' num2str(channel_idx)]);
    legend('Antes do Filtro', 'Depois do Filtro');
    xlim([0 sampling_rate/2]); % Mostrar até Nyquist
    grid on;



end
