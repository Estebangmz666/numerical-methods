function result = problem_integration()
    f = @(t) 40 + 15 .* sin(pi .* t ./ 12) + 0.8 .* t;

    lowerBound = 0;
    upperBound = 12;
    subintervalCounts = [6, 12, 24];
    exactIntegral = integral(f, lowerBound, upperBound);

    resultRows = zeros(numel(subintervalCounts) * 2, 5);
    rowIndex = 1;

    for index = 1:numel(subintervalCounts)
        currentSubintervalCount = subintervalCounts(index);

        [trapIntegral, trapStepSize] = trapezoidal_rule( ...
            f, lowerBound, upperBound, currentSubintervalCount);
        [simpsonIntegral, simpsonStepSize] = simpson_rule( ...
            f, lowerBound, upperBound, currentSubintervalCount);

        resultRows(rowIndex, :) = [1, currentSubintervalCount, trapStepSize, ...
            trapIntegral, abs(exactIntegral - trapIntegral)];
        rowIndex = rowIndex + 1;

        resultRows(rowIndex, :) = [2, currentSubintervalCount, simpsonStepSize, ...
            simpsonIntegral, abs(exactIntegral - simpsonIntegral)];
        rowIndex = rowIndex + 1;
    end

    tValues = linspace(lowerBound, upperBound, 400);

    problemFigure = figure('Name', 'Numerical Integration', 'NumberTitle', 'off');
    plot(tValues, f(tValues), 'b', 'LineWidth', 2);
    grid on;
    xlabel('t');
    ylabel('f(t)');
    title('Traffic Function for Numerical Integration');

    methodLabels = strings(size(resultRows, 1), 1);
    methodLabels(resultRows(:, 1) == 1) = "Trapezoidal";
    methodLabels(resultRows(:, 1) == 2) = "Simpson";

    resultTable = table( ...
        methodLabels, ...
        resultRows(:, 2), ...
        resultRows(:, 3), ...
        resultRows(:, 4), ...
        resultRows(:, 5), ...
        'VariableNames', {'Method', 'Subintervals', 'StepSize', 'ApproxIntegral', 'AbsoluteError'});

    disp('=== PROBLEM 4: NUMERICAL INTEGRATION ===');
    disp(resultTable);
    fprintf('Reference integral from MATLAB integral(): %.10f\n', exactIntegral);

    referenceTable = table(exactIntegral, 'VariableNames', {'ReferenceIntegral'});

    save_figure_file(problemFigure, 'problem_4_numerical_integration');
    save_table_file(resultTable, 'problem_4_integration_metrics');
    save_table_file(referenceTable, 'problem_4_reference_integral');

    result = struct( ...
        'problemNumber', 4, ...
        'title', 'Numerical Integration', ...
        'summary', sprintf(['Simpson''s rule yields the smallest error and improves ', ...
            'consistently as the number of subintervals increases. Reference integral: %.6f.'], ...
            exactIntegral), ...
        'mainTable', resultTable);
end
