% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function visualize_dwt_filters(sampling_rate, waveletType, numLevels)
    % Gera o banco de filtros usando a wavelet e o número de níveis especificados
    fb = dwtfilterbank('Wavelet', waveletType, 'Level', numLevels, 'SamplingFrequency', sampling_rate);

    % Exibe as frequências da banda de passagem para cada nível de decomposição
    figure;
    dwtpassbands(fb);
    title('DWT Passband Frequencies');

    % Mostra a função da wavelet
    figure;
    [psi, xval] = wavelets(fb); % Extrai a função da wavelet
    plot(xval, abs(psi));
    title(['Wavelet Shape: ', waveletType]);
    xlabel('Time');
    ylabel('Amplitude');
    grid on;

    % Mostra a resposta em frequência do banco de filtros
    figure;
    freqz(fb);
    title('DWT Filter Frequency Response');
end
