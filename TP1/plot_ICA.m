% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

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
