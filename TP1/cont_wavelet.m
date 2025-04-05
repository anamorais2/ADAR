% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function cont_wavelet(EEG_in,sampling_rate)
    EEG_wavelet = cell(size(EEG_in)); 
    num_trials = length(EEG_in); 

    num_columns = 2;  
    num_rows = 2; 

    values = [1];
    
    for trial_idx = 1:3
        trial_data = EEG_in{trial_idx};  
        [num_channels, num_samples] = size(trial_data);
        freq_vector = (0:floor(num_samples/2)) * (sampling_rate / num_samples);
        trial_wavelet = zeros(num_channels, length(freq_vector)); 
        
        figure;
        for  i = 1:length(values)

            channel = values(i);
            subplot(num_rows, num_columns, i);
            % Realiza a Transformada Wavelet Contínua (CWT) no canal selecionado
            cwt(trial_data(channel, :));
            title(['Trial ' num2str(trial_idx) ' Channel ' num2str(channel)]); 
            grid on;     

        end
        drawnow;
    end

end