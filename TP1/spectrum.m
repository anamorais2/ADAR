% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function [EEG_spectrum, freq_vector] = spectrum(EEG_windowed, sampling_rate)

    EEG_spectrum = cell(size(EEG_windowed)); 
    num_trials = length(EEG_windowed); 

    %num_columns = 8;  
    %num_rows = 8; 
    
    for trial_idx = 1:num_trials
        trial_data = EEG_windowed{trial_idx};  
        [num_channels, num_samples] = size(trial_data);

        % Calcula o vetor de frequências até à frequência de Nyquist
        freq_vector = (0:floor(num_samples/2)) * (sampling_rate / num_samples);
        trial_spectrum = zeros(num_channels, length(freq_vector)); 
        
        %figure;
        for channel = 1:num_channels
            fft_result = fft(trial_data(channel, :)); 
            amplitude_spectrum = abs(fft_result) / num_samples;  
            amplitude_spectrum = amplitude_spectrum(1:floor(num_samples/2) + 1);

            % Isto mantém a energia total correta, pois apenas os valores internos precisam ser dobrados.
            amplitude_spectrum(2:end-1) = 2 * amplitude_spectrum(2:end-1);

            trial_spectrum(channel, :) = amplitude_spectrum;

            %{
            subplot(num_rows, num_columns, channel);
            plot(freq_vector, amplitude_spectrum, 'b');
            title(['Canal ' num2str(channel)]);
            xlabel('Frequência (Hz)');
            ylabel('Amplitude');
            grid on;
            xlim([0, sampling_rate/2]); % Teorema de Nyquist
            %}
        end
        %sgtitle(["Spectrum Trial" num2str(trial_idx)]);
        EEG_spectrum{trial_idx} = trial_spectrum;  
    end
end
