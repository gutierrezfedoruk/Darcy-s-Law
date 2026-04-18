%% =========================================================================
%  PRODUCTIVITY INDEX - SENSITIVITY ANALYSIS
%  Generates IPR curves and sensitivity plots for key parameters
%
%  Author: Enrique Philippe Gutiérrez Fedoruk
%  LinkedIn: https://www.linkedin.com/in/enrique-philippe-guti%C3%A9rrez-fedoruk-493060123/
%  Date: 2026
%  License: MIT License
% =========================================================================

function sensitivity_analysis()
    %% Base case parameters
    base.h    = 50;       % ft
    base.k    = 100;      % mD
    base.B    = 1.2;      % rb/stb
    base.mu   = 0.8;      % cp
    base.R    = 1000;     % ft
    base.rw   = 0.328;    % ft (7-7/8" hole)
    base.S    = 0;        % dimensionless
    base.P_R  = 4000;     % psi
    base.P_BH = 2000;     % psi

    %% 1. IPR Curve (Inflow Performance Relationship)
    figure('Name', 'IPR Curve', 'Position', [100 100 800 600]);
    
    P_BH_range = linspace(0, base.P_R, 100);
    params = base;
    Q_values = zeros(size(P_BH_range));
    
    for i = 1:length(P_BH_range)
        params.P_BH = P_BH_range(i);
        res = productivity_index_calc(params);
        Q_values(i) = res.Q;
    end
    
    plot(Q_values, P_BH_range, 'b-', 'LineWidth', 2);
    xlabel('Flow Rate, Q (stb/day)', 'FontSize', 12);
    ylabel('Bottom Hole Pressure, P_{BH} (psi)', 'FontSize', 12);
    title('Inflow Performance Relationship (IPR)', 'FontSize', 14);
    grid on;
    hold on;
    
    % Mark operating point
    res_base = productivity_index_calc(base);
    plot(res_base.Q, base.P_BH, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    % AOF (Absolute Open Flow)
    params.P_BH = 0;
    res_aof = productivity_index_calc(params);
    plot(res_aof.Q, 0, 'gs', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    
    legend('IPR Curve', sprintf('Operating Point (Q=%.0f)', res_base.Q), ...
           sprintf('AOF = %.0f stb/day', res_aof.Q), 'Location', 'northeast');
    
    annotation('textbox', [0.15, 0.15, 0.3, 0.1], ...
        'String', sprintf('PI = %.4f stb/day/psi', res_base.PI), ...
        'FontSize', 11, 'BackgroundColor', 'yellow', 'EdgeColor', 'black');
    
    saveas(gcf, 'ipr_curve.png');
    fprintf('Saved: ipr_curve.png\n');

    %% 2. Skin Factor Sensitivity
    figure('Name', 'Skin Sensitivity', 'Position', [100 100 800 600]);
    
    skin_values = [-3, -1, 0, 2, 5, 10, 20];
    colors = jet(length(skin_values));
    
    for j = 1:length(skin_values)
        params = base;
        params.S = skin_values(j);
        Q_skin = zeros(size(P_BH_range));
        
        for i = 1:length(P_BH_range)
            params.P_BH = P_BH_range(i);
            res = productivity_index_calc(params);
            Q_skin(i) = res.Q;
        end
        
        plot(Q_skin, P_BH_range, '-', 'LineWidth', 2, 'Color', colors(j,:));
        hold on;
    end
    
    xlabel('Flow Rate, Q (stb/day)', 'FontSize', 12);
    ylabel('P_{BH} (psi)', 'FontSize', 12);
    title('IPR Sensitivity to Skin Factor', 'FontSize', 14);
    legend(arrayfun(@(s) sprintf('S = %g', s), skin_values, 'UniformOutput', false), ...
           'Location', 'northeast');
    grid on;
    saveas(gcf, 'skin_sensitivity.png');
    fprintf('Saved: skin_sensitivity.png\n');

    %% 3. Permeability Sensitivity
    figure('Name', 'Permeability Sensitivity', 'Position', [100 100 800 600]);
    
    k_values = [10, 25, 50, 100, 250, 500];
    colors = copper(length(k_values));
    
    for j = 1:length(k_values)
        params = base;
        params.k = k_values(j);
        Q_k = zeros(size(P_BH_range));
        
        for i = 1:length(P_BH_range)
            params.P_BH = P_BH_range(i);
            res = productivity_index_calc(params);
            Q_k(i) = res.Q;
        end
        
        plot(Q_k, P_BH_range, '-', 'LineWidth', 2, 'Color', colors(j,:));
        hold on;
    end
    
    xlabel('Flow Rate, Q (stb/day)', 'FontSize', 12);
    ylabel('P_{BH} (psi)', 'FontSize', 12);
    title('IPR Sensitivity to Permeability', 'FontSize', 14);
    legend(arrayfun(@(k) sprintf('k = %g mD', k), k_values, 'UniformOutput', false), ...
           'Location', 'northeast');
    grid on;
    saveas(gcf, 'permeability_sensitivity.png');
    fprintf('Saved: permeability_sensitivity.png\n');

    %% 4. PI vs Skin Factor Bar Chart
    figure('Name', 'PI vs Skin', 'Position', [100 100 800 600]);
    
    skin_range = -5:1:20;
    PI_vals = zeros(size(skin_range));
    
    for i = 1:length(skin_range)
        params = base;
        params.S = skin_range(i);
        res = productivity_index_calc(params);
        PI_vals(i) = res.PI;
    end
    
    bar(skin_range, PI_vals, 'FaceColor', [0.2 0.6 0.8]);
    xlabel('Skin Factor, S', 'FontSize', 12);
    ylabel('PI (stb/day/psi)', 'FontSize', 12);
    title('Productivity Index vs Skin Factor', 'FontSize', 14);
    grid on;
    saveas(gcf, 'pi_vs_skin.png');
    fprintf('Saved: pi_vs_skin.png\n');

    fprintf('\nAll sensitivity plots generated successfully.\n');
end

%% Helper function (standalone calculation without display)
function results = productivity_index_calc(params)
    h  = params.h;
    k  = params.k;
    B  = params.B;
    mu = params.mu;
    R  = params.R;
    rw = params.rw;
    S  = params.S;
    P_R  = params.P_R;
    P_BH = params.P_BH;

    numerator   = 0.00708 * h * k;
    denominator = B * mu * (log(R / rw) + S);
    
    PI = numerator / denominator;
    drawdown = P_R - P_BH;
    Q = PI * drawdown;
    Q_BH = Q * B;

    results.PI       = PI;
    results.Q        = Q;
    results.Q_BH     = Q_BH;
    results.drawdown = drawdown;
end
