% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function [Zica, W, T, mu] = apply_ICA(trials_data, r)
    Zica = {};  
    W = {};   
    T = {};   
    mu = {};    
    
    for i = 1:length(trials_data)
        Z = trials_data{i};  

        % Aplicar ICA usando os dois métodos: negentropy e kurtosis
        [Zica_kurtosis, W_kurtosis, T_kurtosis, mu_kurtosis] = fastICA(Z, r, 'kurtosis', 1);
        [Zica_negentropy, W_negentropy, T_negentropy, mu_negentropy] = fastICA(Z, r, 'negentropy', 1);

     
        % Vamos escolher a componente com maior valor de variância - A variância ajuda a medir o quão "dispersas" ou "separadas" as componentes são em relação ao zero (média)

        var_kurtosis = var(Zica_kurtosis, 0, 2); 
        var_negentropy = var(Zica_negentropy, 0, 2); 
        
        if mean(var_kurtosis) > mean(var_negentropy)
            Zica{i} = Zica_kurtosis; 
            W{i} = W_kurtosis;
            T{i} = T_kurtosis;
            mu{i} = mu_kurtosis;
        else
            Zica{i} = Zica_negentropy;
            W{i} = W_negentropy;
            T{i} = T_negentropy;
            mu{i} = mu_negentropy;
        end
   end
end

function Zica = plot_ICA(Zica)
    num_columns = 8;
    num_rows = 8;
    
    for i = 1:length(Zica)
        trial_Zica = Zica{i};  
        num_components = size(trial_Zica, 1);
        figure;
       
        for j = 1:num_components
            subplot(num_rows, num_columns, j);  
            plot(trial_Zica(j, :));
            title(['Componente ' num2str(j)]);
        end
        
        sgtitle(['Componente Independente - Trial ' num2str(i)]);

        pause; % Aguarda Enter
        
        answer_components = inputdlg('Digite os componentes a eliminar (ex: 1,3,5) ou 0 para manter todos:', ...
                                     'Eliminar Componentes', 1);
        if ~isempty(answer_components)
            components_to_remove = str2num(answer_components{1}); 
            if ~isempty(components_to_remove) && any(components_to_remove > 0)
                trial_Zica(components_to_remove, :) = 0; % Definir os componentes como zero
                
                Zica{i} = trial_Zica;
            end
        end
    end
end
