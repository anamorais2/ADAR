% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

%% Task 1 
base_path = "SEED\SEED_EEG\SEED_RAW_EEG\";

[trials_data_2_1, EEG_downsampled_2_1, num_channels_2_1] = preprocess_EEG("2_1.cnt",base_path,4);
%[trials_data_2_2, EEG_downsampled_2_2, num_channels_2_2] = preprocess_EEG("2_2.cnt",base_path,10);
%[trials_data_2_3, EEG_downsampled_2_3, num_channels_2_3] = preprocess_EEG("2_3.cnt",base_path,13);

%plot_EEG(trials_data_2_1,EEG_downsampled_2_1,4,5); 

%% ICA

[Zica_2_1, W_2_1, T_2_1, mu_2_1] = apply_ICA(trials_data_2_1, num_channels_2_1);

Zica_2_1 = plot_ICA(Zica_2_1);

reconstructed_EEG_2_1 = {};  

for i = 1:length(T_2_1)  % Loop para cada trial
    reconstructed_EEG_2_1{i} = T_2_1{i} * Zica_2_1{i} + mu_2_1{i};
end

plot_EEG_all(reconstructed_EEG_2_1, 'Sinais EEG Reconstruídos - Trial');

[Zica_2_1_2, W_2_1_2, T_2_1_2, mu_2_1_2] = apply_ICA(reconstructed_EEG_2_1,num_channels_2_1);

Zica_2_1_2 = plot_ICA(Zica_2_1_2);

reconstructed_EEG_2_1_2 = {};  

for i = 1:length(T_2_1_2) 
    reconstructed_EEG_2_1_2{i} = T_2_1_2{i} * Zica_2_1_2{i} + mu_2_1_2{i};
end
plot_EEG_all(reconstructed_EEG_2_1_2, 'Sinais EEG Reconstruídos - Trial');

%[Zica_2_2, W_2_2, T_2_2, mu_2_2] = apply_ICA(trials_data_2_2, num_channels_2_2);
%Zica_2_2 = plot_ICA(Zica_2_2)
%[Zica_2_3, W_2_3, T_2_3, mu_2_3] = apply_ICA(trials_data_2_3, num_channels_2_3);
%Zica_2_3 = plot_ICA(Zica_2_3)
%% Carregar variáveis para não ter selecionar no ICA

reconstructed_EEG_2_1 = load("Variaveis\reconstructed_EEG_2_1_2.mat");
reconstructed_EEG_2_1 = reconstructed_EEG_2_1.reconstructed_EEG_2_1_2;
reconstructed_EEG_2_2 = load("Variaveis\reconstructed_2_2.mat");
reconstructed_EEG_2_2 = reconstructed_EEG_2_2.reconstructed_EEG_2_2_2;
reconstructed_EEG_2_3 = load("Variaveis\reconstructed_2_3.mat");
reconstructed_EEG_2_3 = reconstructed_EEG_2_3.reconstructed_EEG_2_3_2;

sampling_rate = 250;

%% Task 2 and 3 | Windowing | Spectrum


EEG_windowed_h_2_1 = windowing(reconstructed_EEG_2_1,"hamming");
EEG_windowed_b_2_1 = windowing(reconstructed_EEG_2_1,"blackman");
EEG_windowed_han_2_1 = windowing(reconstructed_EEG_2_1, "hann");
EEG_windowed_t_2_1 = windowing(reconstructed_EEG_2_1, "triangular");

% Desenhar todos os spectrum em simultâneo 
EEG_windows = {EEG_windowed_t_2_1,EEG_windowed_han_2_1,EEG_windowed_h_2_1, EEG_windowed_b_2_1}; 
labels = {'Triangular', 'Hann','Hamming', 'Blackman'};
colors = {'r', 'g', 'b','c'}; 

num_methods = length(EEG_windows);
spectra = cell(1, num_methods);
max_length = 0;

for i = 1:num_methods
    [spectra{i}, freq_vector_i] = spectrum(EEG_windows{i}, sampling_rate);
    max_length = max(max_length, length(freq_vector_i)); % Encontrar o maior comprimento
end

figure; hold on;
for i = 1:num_methods
    num_trials = length(spectra{i});
    spectra_matrix = nan(num_trials, max_length); % Pré-alocar com NaN

    for j = 1:num_trials
        spectrum_j = spectra{i}{j}(1, :); % Canal 1
        len = length(spectrum_j);
        spectra_matrix(j, 1:len) = spectrum_j; % Preenchimento com os valores existentes
    end

    % Calcular a média ignorando NaNs
    mean_spectrum = mean(spectra_matrix, 'omitnan');

    % Ajustar freq_vector ao tamanho de mean_spectrum antes do plot
    plot(linspace(0, sampling_rate/2, length(mean_spectrum)), mean_spectrum, colors{i}, 'LineWidth', 1.5);
end

title('Comparação dos Espectros para Diferentes Janelas');
xlabel('Frequência (Hz)');
ylabel('Amplitude');
legend(labels);
grid on;
xlim([0 sampling_rate/2]); % Teorema de Nyquist
hold off;

%% %% Task 2 and 3 | Windowing | Spectrum - Hann Window

EEG_windowed_han_2_1 = windowing(reconstructed_EEG_2_1, "hann");
EEG_windowed_han_2_2 = windowing(reconstructed_EEG_2_2, "hann");
EEG_windowed_han_2_3 = windowing(reconstructed_EEG_2_3, "hann");

%% Task 4 - FIR - Filtering with Bandpass Filter
Num = load("Variaveis\Num_Bandpass.mat");
Num = Num.Num;

figure;
freqz(Num, 1, 1024, sampling_rate);
title('Resposta em Frequência do Filtro FIR');

[EEG_filtered] =filt(EEG_windowed_han_2_1, Num,1, sampling_rate, 'Espectro Antes e Depois da FIR (BandPass) - Trial '); % Denominador = 1, pois em filtros FIR não há denominador
%% Task 4 - FIR - Filtering with Low and High Filters

Num_High = load("Variaveis\Num_HighPass.mat");
Num_High = Num_High.Num;
Num_Low = load("Variaveis\Num_LowPass.mat");
Num_Low = Num_Low.Num;

%%

[EEG_filtered_Low] =filt(EEG_windowed_han_2_1, Num_Low,1, sampling_rate,  'Espectro Antes e Depois da FIR (LowPass) - Trial ');

[EEG_filtered_2] =filt(EEG_filtered_Low, Num_High, 1, sampling_rate, 'Espectro Antes e Depois da FIR (HighPass) - Trial ');

%% Task 4 - IIR

[Num_IIR_Low, Den_IIR_Low] = sos2tf(SOS,G);

[Num_IIR_High, Den_IIR_High] = sos2tf(SOS_High,G_High);

%% Carregar Variáveis caso seja necessário

Num_IIR_Low = load("Variaveis\Num_IIR_Low.mat");
Num_IIR_Low = Num_IIR_Low.Num_IIR_Low;

Den_IIR_Low = load("Variaveis\Den_IIR_Low.mat");
Den_IIR_Low = Den_IIR_Low.Den_IIR_Low;

Num_IIR_High = load("Variaveis\Num_IIR_High.mat");
Num_IIR_High = Num_IIR_High.Num_IIR_High;

Den_IIR_High = load("Variaveis\Den_IIR_High.mat");
Den_IIR_High = Den_IIR_High.Den_IIR_High;

%%
[EEG_filtered_IIR_Low] = filt(EEG_windowed_han_2_1, Num_IIR_Low, Den_IIR_Low, sampling_rate, 'Espectro Antes e Depois da IIR (LowPass) - Trial ');
[EEG_filtered_IIR_2] =filt(EEG_filtered_IIR_Low, Num_IIR_High,Den_IIR_High, sampling_rate,  'Espectro Antes e Depois da IIR (HighPass) - Trial ');

%% Escolher um filtro para todos as experiências - Foi escolhido o FIR - Low and High Pass

[EEG_filtered_Low_2_1] =filt(EEG_windowed_han_2_1, Num_Low,1, sampling_rate,  'Espectro Antes e Depois da FIR (LowPass) - Trial ');
[EEG_filtered_2_1] =filt(EEG_filtered_Low_2_1, Num_High, 1, sampling_rate, 'Espectro Antes e Depois da FIR (HighPass) - Trial ');

[EEG_filtered_Low_2_2] =filt(EEG_windowed_han_2_2, Num_Low,1, sampling_rate,  'Espectro Antes e Depois da FIR (LowPass) - Trial ');
[EEG_filtered_2_2] =filt(EEG_filtered_Low_2_2, Num_High, 1, sampling_rate, 'Espectro Antes e Depois da FIR (HighPass) - Trial ');

[EEG_filtered_Low_2_3] =filt(EEG_windowed_han_2_3, Num_Low,1, sampling_rate,  'Espectro Antes e Depois da FIR (LowPass) - Trial ');
[EEG_filtered_2_3] =filt(EEG_filtered_Low_2_3, Num_High, 1, sampling_rate, 'Espectro Antes e Depois da FIR (HighPass) - Trial ');

%% Task 6.1 - Wavelet 

% OS canais que achamos relevantes foram o T7,T8,P7,P8 - Que correspondem
% aos índices [24,32,42,50]

cnt = loadcnt("SEED\SEED_EEG\SEED_RAW_EEG\" + "2_3.cnt");

channels = {cnt.electloc.lab};

non_channel_names = {'VEO', 'HEO', 'M1', 'M2'};

EEG_indices = ~ismember(channels, non_channel_names); %A função ismember é usada para verificar se o nome do canal está na lista de canais não EEG. A inversão ~ retorna os índices dos canais que não estão na lista de exclusão (ou seja, são EEG).
    
% Obter apenas os nomes dos canais EEG 
EEG_channel_names = channels(EEG_indices);

% Criar um mapa de nome do canal -> índice
channel_map = containers.Map(EEG_channel_names, 1:length(EEG_channel_names));

% Exemplo: verificar o índice do canal "T7" dentro dos canais EEG
    if isKey(channel_map, 'T8')
        T7_index = channel_map('T8');
        fprintf('O canal T8 está no índice: %d (dentro dos canais EEG)\n', T7_index);
    else
        fprintf('O canal T8 não foi encontrado nos canais EEG!\n');
    end
%% Task 6.1 - Wavelet Continua
cont_wavelet(EEG_filtered_2,sampling_rate);

%% Task 6.2 - Wavelet Discreta

wavelet = 'db4'; % Escolher uma wavelet adequada
levels = 5; % Número de níveis de decomposição


%visualize_dwt_filters(sampling_rate, wavelet, levels);


%% Extração de features

eeg_data = {EEG_filtered_2_1, EEG_filtered_2_2, EEG_filtered_2_3};
all_power = [];
for i = 1:3
     [delta_power, theta_power, alpha_power, beta_power, gamma_power] = dwt_eeg_features(eeg_data{i}, wavelet);
     all_power = [all_power; delta_power, theta_power, alpha_power, beta_power, gamma_power];
end

%% Carregar a variável all_power contendo as features de todos os canais e trials

all_power = load("Variaveis\all_power.mat").all_power;

%% Aplicar o PCA à matriz all_power que corresponde as features para os 62 canais para os 3 trails - 42 linhas 


[all_pca_2, all_pca_3] = pca_function(all_power, "medianiqr");
%% Remove outliers

all_pca_2 = remove_outliers(all_pca_2);
all_pca_3 = remove_outliers(all_pca_3);

%% Aplicar o MDS

methods = {'zscore', 'norm', 'center', 'range'}; 


distance_metrics = {'euclidean', 'cityblock'}; % Diferentes métricas de distância
mds_methods = {'stress', 'metricstress'}; 
% stress -  não metrico 
% 'metricstress' = metrico

for i = 1:length(methods)
    fprintf('Testing normalization method: %s\n', methods{i});
    [mds_2d, mds_3d, stress_values] = mds_function(all_power, methods{i}, distance_metrics, mds_methods);
end

%% Após analisar todas as formas de normalização escolhemos - norm com
%cytbolck com a métrica stress. 

mds_methods = {'stress'};
distance_metrics = {'cityblock'};
method ="norm";
[mds_2d, mds_3d, ] = mds_function(all_power,method, distance_metrics, mds_methods);

%% Remove Outliers 
mds_2d = remove_outliers(mds_2d.cityblock_stress);
mds_3d = remove_outliers(mds_3d.cityblock_stress);

%% Task 8 - PCA + Clustering 
%  2, 0, 1 for positive, negative, and neutral emotions

label = load("Variaveis\label.mat").label; % Agora valores vão de 1 a 3 - por causa de as funções do clustering devolvem labels acima de 1, mmas o plot da matriz de confusão está correto. 
clustering_results = clustering_function(all_pca_3, label','PCA');

%% Task 8 - MDS + Clustering 

clustering_results = clustering_function(mds_3d, label','MDS');