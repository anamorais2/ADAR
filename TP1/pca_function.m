% Ana Carolina Morais Nº2021222056 
% Eduardo Ferreira Nº2021218018 
% Participante Nº2

function [all_pca_2, all_pca_3] = pca_function(X, method)
    X = normalize(X, method);

    % Foram experimentados os diversos tipos de 'Algorithm' - "svd", "eig",
    % "als" e o resultado obtido foi sempre igual 
    [~, score_2, latent_2, ~, explained_2] = pca(X,"Algorithm","svd",'NumComponents', 2);

    [~, score_3, ~, ~, ~] = pca(X,"Algorithm","svd",'NumComponents', 3);
    
    % Calcular os valores próprios
    eigenvalues = latent_2;
    
    % Calcular a variância preservada cumulativa
    preserved_variance = cumsum(explained_2);
    
    plots_pca(preserved_variance, explained_2, eigenvalues);

    all_pca_2 = score_2(:, 1:2);
    plot_pca_2d(all_pca_2);

    all_pca_3 = score_3(:, 1:3);
    plot_pca_3d(all_pca_3);


end

function plots_pca(preserved_variance, explained, eigenvalues)
    figure;
    
    subplot(1,3,1);
    plot(1:length(preserved_variance), preserved_variance, '-o');
    hold on;
    yline(95, 'r--');
    title('PCA Explained Variance');
    xlabel('Number of Principal Components');
    ylabel('Cumulative Explained Variance (%)');
    grid on;
    
    subplot(1,3,2);
    plot(1:length(eigenvalues), eigenvalues, '-o');
    hold on;
    yline(0.35, 'r--');
    title('PCA Eigenvalues');
    xlabel('Number of Principal Components');
    ylabel('Eigenvalue');
    grid on;
    
    subplot(1,3,3);
    bar(explained);
    title('Explained Variance per Component');
    xlabel('Number of Principal Components');
    ylabel('Explained Variance (%)');
    grid on;
end

function plot_pca_2d(x_pca)
    figure;
    scatter(x_pca(:,1), x_pca(:,2), 'filled');
    xlabel('PC1');
    ylabel('PC2');
    title('2D PCA Projection');
    grid on;
end

function plot_pca_3d(x_pca)
    figure;
    scatter3(x_pca(:,1), x_pca(:,2), x_pca(:,3), 'filled');
    xlabel('PC1');
    ylabel('PC2');
    zlabel('PC3');
    title('3D PCA Projection');
    grid on;
end
