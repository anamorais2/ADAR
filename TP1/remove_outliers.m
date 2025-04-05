% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function X_clean = remove_outliers(X)
    
    X_clean = X;
    
    num_columns = size(X, 2);

    for col = 1:num_columns
        % Calcular a média e o desvio padrão da coluna
        col_mean = mean(X_clean(:, col));
        col_std = std(X_clean(:, col));
        
        % Definir os limites superior e inferior para outliers
        lower_bound = col_mean - 3 * col_std;
        upper_bound = col_mean + 3 * col_std;
        
        % Encontrar os índices dos outliers
        outlier_indices = find(X_clean(:, col) < lower_bound | X_clean(:, col) > upper_bound);
        
        % Se houver outliers, calcular a nova média excluindo esses pontos
        if ~isempty(outlier_indices)
            for i = 1:length(outlier_indices)
                temp_data = X_clean(:, col);
                temp_data(outlier_indices(i)) = [];  % Remover o outlier para calcular a média
                new_mean = mean(temp_data);  % Média sem o outlier
                
                % Substituir o outlier pelo novo valor médio
                X_clean(outlier_indices(i), col) = new_mean;
            end
        end
    end
end
