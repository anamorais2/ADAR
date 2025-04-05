% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function [mds_2d, mds_3d, stress_values] = mds_function(X, method, distance_metrics, mds_methods)

    X = normalize(X, method);
    
    % Aplicar MDS para 2D e 3D com diferentes métodos
    mds_2d = struct();
    mds_3d = struct();
    stress_values = struct();
    
    for i = 1:length(distance_metrics)
        D = pdist(X, distance_metrics{i}); % Calcular a matriz de distâncias
        for j = 1:length(mds_methods)
            [Y2, stress2] = mdscale(D, 2, 'Criterion', mds_methods{j});
            [Y3, stress3] = mdscale(D, 3, 'Criterion', mds_methods{j});
            
            key = sprintf('%s_%s', distance_metrics{i}, mds_methods{j});
            mds_2d.(key) = Y2;
            mds_3d.(key) = Y3;
            stress_values.(key) = [stress2, stress3];
        end
    end
    
    plot_mds_2d(mds_2d, method);
    plot_mds_3d(mds_3d, method);
    plot_stress_values(stress_values, method);
end

function plot_mds_2d(mds_2d, method)
    figure;
    fields = fieldnames(mds_2d);
    for i = 1:length(fields)
        subplot(ceil(length(fields)/2), 2, i);
        scatter(mds_2d.(fields{i})(:,1), mds_2d.(fields{i})(:,2), 'filled');
        xlabel('Dimension 1');
        ylabel('Dimension 2');
        title(['MDS 2D - ' strrep(fields{i}, '_', ' ') ' using ' method ]);
        grid on;
    end
    sgtitle('MDS 2D Projections');
end

function plot_mds_3d(mds_3d, method)
    figure;
    fields = fieldnames(mds_3d);
    for i = 1:length(fields)
        subplot(ceil(length(fields)/2), 2, i);
        scatter3(mds_3d.(fields{i})(:,1), mds_3d.(fields{i})(:,2), mds_3d.(fields{i})(:,3), 'filled');
        xlabel('Dimension 1');
        ylabel('Dimension 2');
        zlabel('Dimension 3');
        title(['MDS 3D - ' strrep(fields{i}, '_', ' ') ' using ' method]);
        grid on;
    end
    sgtitle('MDS 3D Projections');
end

function plot_stress_values(stress_values, method)
    % Função para plotar os valores de stress comparando métricas de distância
    figure;
    fields = fieldnames(stress_values);
    stress_matrix = zeros(length(fields), 2); 
    
    for i = 1:length(fields)
        stress_matrix(i, :) = stress_values.(fields{i});
    end
    
    bar(stress_matrix);
    set(gca, 'XTickLabel', strrep(fields, '_', ' '), 'XTickLabelRotation', 45);
    xlabel('MDS Method and Distance Metric');
    ylabel('Stress Value');
    legend({'2D', '3D'});
    title(['Comparison of MDS Stress Values Using ' method]);
    grid on;
end