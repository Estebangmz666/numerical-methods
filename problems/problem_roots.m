function result = problem_roots()
    f = @(x) 0.002 .* x.^3 - 0.15 .* x.^2 + 5 .* x - 200;
    df = @(x) 0.006 .* x.^2 - 0.3 .* x + 5;

    tolerance = 1e-6;
    maxIterations = 100;

    [bisectionRoot, bisectionIterations, bisectionMetadata] = ...
        bisection_method(f, 20, 80, tolerance, maxIterations);

    [newtonRoot, newtonIterations, newtonMetadata] = ...
        newton_raphson_method(f, df, 50, tolerance, maxIterations);

    xValues = linspace(20, 80, 400);

    problemFigure = figure('Name', 'Root Finding Methods', 'NumberTitle', 'off');
    plot(xValues, f(xValues), 'k', 'LineWidth', 2, 'DisplayName', 'f(x)');
    hold on;
    yline(0, ':', 'LineWidth', 1.2, 'DisplayName', 'y = 0');
    plot(bisectionRoot, f(bisectionRoot), 'or', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'r', 'DisplayName', 'Bisection root');
    plot(newtonRoot, f(newtonRoot), 'sb', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'b', 'DisplayName', 'Newton root');
    grid on;
    xlabel('x');
    ylabel('f(x)');
    title('Bisection vs Newton-Raphson');
    legend('Location', 'best');
    hold off;

    resultTable = table( ...
        ["Bisection"; "Newton-Raphson"], ...
        [bisectionRoot; newtonRoot], ...
        [bisectionIterations; newtonIterations], ...
        [bisectionMetadata.finalResidual; newtonMetadata.finalResidual], ...
        'VariableNames', {'Method', 'Root', 'Iterations', 'FinalResidual'});

    disp('=== PROBLEM 2: ROOT FINDING ===');
    disp(resultTable);

    save_figure_file(problemFigure, 'problem_2_root_finding');
    save_table_file(resultTable, 'problem_2_root_metrics');

    result = struct( ...
        'problemNumber', 2, ...
        'title', 'Root Finding', ...
        'summary', sprintf(['Both methods converge to approximately %.6f. ', ...
            'Newton-Raphson is notably faster in iterations, while bisection ', ...
            'preserves its robustness.'], newtonRoot), ...
        'mainTable', resultTable);
end
