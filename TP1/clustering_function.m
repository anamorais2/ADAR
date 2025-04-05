% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2


function clustering_results = clustering_function(X_reduced, y_true, method_name)
    num_clusters = 3;
    clustering_results = struct();
    colors = lines(num_clusters);
    
    % K-Means
    labels_kmeans = kmeans(X_reduced, num_clusters, 'Replicates', 10); % Repete 10 vezes o algoritmo, inicializando sempre um novo conjunto de centroides
    clustering_results.kmeans = evaluate_clustering(labels_kmeans, y_true, 'K-Means', X_reduced, colors, method_name, false);
    
    % K-Medoids
    labels_kmedoids = kmedoids(X_reduced, num_clusters, 'Distance', 'euclidean');
    clustering_results.kmedoids = evaluate_clustering(labels_kmedoids, y_true, 'K-Medoids', X_reduced, colors, method_name, false);
    
    % Hierarchical Clustering
    Z = linkage(pdist(X_reduced, 'euclidean'), 'ward');
    labels_hierarchical = cluster(Z, 'maxclust', num_clusters);
    clustering_results.hierarchical = evaluate_clustering(labels_hierarchical, y_true, 'Hierarchical', X_reduced, colors, method_name, true, Z);
    
    % Fuzzy C-Means
    [~, U] = fcm(X_reduced, num_clusters); % Aplica Fuzzy C-Means e retorna a matriz de pertinência U
    [~, labels_fcm] = max(U, [], 1); % Obtém o índice do cluster com maior grau de pertencimento para cada ponto
    clustering_results.fcm = evaluate_clustering(labels_fcm', y_true, 'Fuzzy C-Means', X_reduced, colors, method_name, false);

    % Relativamente aos prints que aparecem sobre a função fcm, significa
    % que o valor da função objetivo diminui a cada iteração, o que
    % significa que o algoritmo está a ajustar os clusters para encontrar a
    % melhor partição dos dados. Se a diferença for muito pequena entre uma
    % iteração e outra, significa que o algoritmo convergiu e encontrou uma
    % solução 
    
    plot_metrics(clustering_results);
end

function results = evaluate_clustering(labels_pred, labels_true, method_name, X_reduced, colors, reduction_name, is_hierarchical, Z)
    num_classes = numel(unique(labels_true));

    % Aplicar o realinhamento de clusters
    relabeled_pred = simple_cluster_relabeling(labels_pred, labels_true);
    
    %{
        Para cada classe consideramos: 
        Positivos Verdadeiros (TP): elementos na diagonal
        Falsos Positivos (FP): soma da coluna - diagonal
        Falsos Negativos (FN): soma da linha - diagonal
        Negativos Verdadeiros (TN): total - (TP + FP + FN)

    %}
 

    cm = confusionmat(labels_true, relabeled_pred);
    results.confusion_matrix = cm;
    results.accuracy = sum(diag(cm)) / sum(cm(:));
    results.sensitivity = mean(diag(cm) ./ sum(cm, 2));
    results.specificity = mean((sum(cm(:)) - sum(cm, 2) - sum(cm, 1)' + diag(cm)) ./ (sum(cm(:)) - sum(cm, 2)));
    
    fprintf('Método: %s\n', method_name);

    fprintf('\nMatriz de Confusão após realinhamento:\n');
    fprintf('True  → Pred ');
    for j = 1:num_classes
        fprintf('%4d ', j-1);
    end
    fprintf('\n');
    for i = 1:num_classes
        fprintf('%4d |', i-1);
        for j = 1:num_classes
            fprintf('%4d ', cm(i, j));
        end
        fprintf('\n');
    end

    fprintf('Accuracy: %.2f | Sensitivity: %.2f | Specificity: %.2f\n', results.accuracy, results.sensitivity, results.specificity);

   
    figure;
    imagesc(cm);
    colormap(cool);  
    colorbar;
    title(['Confusion Matrix - ', method_name]);
    xlabel('Predicted');
    ylabel('True');

    % Ajustar os rótulos corretamente (0,1,2)
    num_classes = size(cm, 1);
    tick_labels = 0:num_classes-1;
    
    xticks(1:num_classes); 
    yticks(1:num_classes);
    xticklabels(string(tick_labels)); 
    yticklabels(string(tick_labels));

    % Adicionar os valores da matriz dentro das células
    [rows, cols] = size(cm);
    for i = 1:rows
        for j = 1:cols
            text(j, i, num2str(cm(i, j)), 'HorizontalAlignment', 'center', 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
        end
    end

    
    if is_hierarchical
        figure;
        dendrogram(Z);
        title(['Dendrogram - ', method_name]);
        xlabel('Data Points');
        ylabel('Distance');
    else
        figure;
        hold on;
        if size(X_reduced, 2) == 3
            scatter3(X_reduced(:,1), X_reduced(:,2), X_reduced(:,3), 50, colors(labels_pred,:), 'filled');
            xlabel([reduction_name, ' Dimension 1']);
            ylabel([reduction_name, ' Dimension 2']);
            zlabel([reduction_name, ' Dimension 3']);
            view(3);
        else
            scatter(X_reduced(:,1), X_reduced(:,2), 50, colors(labels_pred,:), 'filled');
            xlabel([reduction_name, ' Dimension 1']);
            ylabel([reduction_name, ' Dimension 2']);
        end
        title(['Clusters - ', method_name, ' - ', reduction_name]);
        grid on;
        hold off;
    end
end



function plot_metrics(clustering_results)
    methods = fieldnames(clustering_results);
    accuracies = []; sensitivities = []; specificities = [];
    
    for i = 1:numel(methods)
        accuracies(i) = clustering_results.(methods{i}).accuracy;
        sensitivities(i) = clustering_results.(methods{i}).sensitivity;
        specificities(i) = clustering_results.(methods{i}).specificity;
    end
    
    figure;
    bar(categorical(methods), [accuracies; sensitivities; specificities]');
    legend({'Accuracy', 'Sensitivity', 'Specificity'});
    title('Comparação de métricas entre métodos de clustering');
    ylabel('Valor');
end


function relabeled_pred = simple_cluster_relabeling(labels_pred, labels_true)

    % Esta função realinha os clusters previstos com as classes verdadeiras
    % baseando-se na maior sobreposição entre cada cluster e classe
    
    conf_matrix = confusionmat(labels_true, labels_pred);

    num_classes = numel(unique(labels_true));
    disp("Matriz inicial")
    fprintf('True  → Pred ');
    for j = 1:num_classes
        fprintf('%4d ', j-1);
    end
    fprintf('\n');
    for i = 1:num_classes
        fprintf('%4d |', i-1);
        for j = 1:num_classes
            fprintf('%4d ', conf_matrix(i, j));
        end
        fprintf('\n');
    end

    
    num_classes = size(conf_matrix, 1);
    
    new_label_map = zeros(num_classes, 1);
    assigned_true_labels = false(num_classes, 1);
    
    % Criar uma lista com contagens de instâncias para priorizar clusters maiores
    cluster_counts = sum(conf_matrix, 1)';  % Soma das colunas (total por cluster)
    [~, sort_idx] = sort(cluster_counts, 'descend');  % Ordenar por tamanho
    
    % Iterar sobre os clusters, começando pelos maiores
    for i = 1:num_classes
        curr_cluster = sort_idx(i);
        
        % Encontrar a classe verdadeira ainda não atribuída com maior sobreposição
        available_classes = find(~assigned_true_labels);
        [~, max_idx] = max(conf_matrix(available_classes, curr_cluster));
        best_true_label = available_classes(max_idx);
        
        % Atribuir este cluster à melhor classe verdadeira
        new_label_map(curr_cluster) = best_true_label;
        assigned_true_labels(best_true_label) = true;
    end
    
    relabeled_pred = zeros(size(labels_pred));
    unique_pred_labels = unique(labels_pred);
    
    for i = 1:length(unique_pred_labels)
        old_label = unique_pred_labels(i);
        new_label = new_label_map(i);
        relabeled_pred(labels_pred == old_label) = new_label;
    end

    
end



%{

True  → Pred |    0    1    2 
   0 |   1    3   10 
   1 |   1    3   10 
   2 |   2    7    5

Vamos aplicar o algoritmo de realinhamento:

Tamanho dos clusters:

Cluster 0: 1 + 1 + 2 = 4 instâncias
Cluster 1: 3 + 3 + 7 = 13 instâncias
Cluster 2: 10 + 10 + 5 = 25 instâncias


Começando pelo maior (Cluster 2), determinamos o novo mapeamento:

Cluster 2 → Classe 0 (porque tem 10 instâncias da classe 0, empatado com classe 1, escolhemos a primeira)
Cluster 1 → Classe 2 (porque tem 7 instâncias da classe 2, a melhor entre as restantes)
Cluster 0 → Classe 1 (a única classe restante)


Portanto, nosso mapeamento é:

2 → 0
1 → 2
0 → 1


Agora reordenamos as colunas da matriz conforme este mapeamento:
         Novas labels dos clusters
True  → Pred |   0    1    2
           0 |  10    1    3
           1 |  10    1    3
           2 |   5    2    7
%}