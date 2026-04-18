%% =========================================================================
%  PRODUCTIVITY INDEX (PI) CALCULATOR
%  Based on Darcy's radial flow equation for steady-state conditions
%  
%  Q = PI * (P_R - P_BH)
%  PI = (2 * pi * h * k) / (B * mu * (ln(R/rw) + S))
%
%  Author: Enrique Philippe Gutiérrez Fedoruk
%  LinkedIn: https://www.linkedin.com/in/enrique-philippe-guti%C3%A9rrez-fedoruk-493060123/
%  Date: 2026
%  License: MIT License
% =========================================================================

function results = productivity_index(params)
    % PRODUCTIVITY_INDEX Calculate well productivity index and flow rate
    %
    % Input: params (struct) with fields:
    %   h    - Reservoir thickness [ft]
    %   k    - Effective permeability [mD]
    %   B    - Formation volume factor [rb/stb]
    %   mu   - Viscosity [cp]
    %   R    - Well drainage radius [ft]
    %   rw   - Wellbore radius [ft]
    %   S    - Skin factor [dimensionless]
    %   P_R  - Reservoir pressure [psi]
    %   P_BH - Bottom hole flowing pressure [psi]
    %
    % Output: results (struct) with fields:
    %   PI      - Productivity Index [stb/day/psi]
    %   Q       - Stock tank flow rate [stb/day]
    %   Q_BH    - Bottom hole flow rate [rb/day]
    %   drawdown - Pressure drawdown [psi]

    %% Validate inputs
    validate_inputs(params);

    %% Extract parameters
    h    = params.h;
    k    = params.k;
    B    = params.B;
    mu   = params.mu;
    R    = params.R;
    rw   = params.rw;
    S    = params.S;
    P_R  = params.P_R;
    P_BH = params.P_BH;

    %% Calculate Productivity Index
    % PI = (2 * pi * h * k) / (B * mu * (ln(R/rw) + S))
    % Note: k in mD needs conversion factor 0.00708 for field units
    numerator   = 0.00708 * h * k;  % 2*pi/ln(10) * conversion ~ 0.00708
    denominator = B * mu * (log(R / rw) + S);
    
    PI = numerator / denominator;

    %% Calculate flow rate
    drawdown = P_R - P_BH;
    Q = PI * drawdown;          % Stock tank flow rate [stb/day]
    Q_BH = Q * B;               % Bottom hole flow rate [rb/day]

    %% Store results
    results.PI       = PI;
    results.Q        = Q;
    results.Q_BH     = Q_BH;
    results.drawdown = drawdown;

    %% Display results
    fprintf('\n============================================\n');
    fprintf('   PRODUCTIVITY INDEX RESULTS\n');
    fprintf('============================================\n');
    fprintf('  PI       = %.4f stb/day/psi\n', PI);
    fprintf('  Drawdown = %.2f psi\n', drawdown);
    fprintf('  Q        = %.2f stb/day\n', Q);
    fprintf('  Q_BH     = %.2f rb/day\n', Q_BH);
    fprintf('============================================\n\n');
end

function validate_inputs(p)
    % Validate all input parameters
    required = {'h', 'k', 'B', 'mu', 'R', 'rw', 'S', 'P_R', 'P_BH'};
    for i = 1:length(required)
        if ~isfield(p, required{i})
            error('Missing parameter: %s', required{i});
        end
    end
    
    if p.R <= p.rw
        error('Drainage radius (R) must be greater than wellbore radius (rw)');
    end
    if p.h <= 0 || p.k <= 0 || p.B <= 0 || p.mu <= 0 || p.rw <= 0 || p.R <= 0
        error('h, k, B, mu, R, rw must be positive values');
    end
    if p.P_BH > p.P_R
        warning('P_BH > P_R: flow will be into the reservoir (injection)');
    end
end
