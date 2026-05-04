function result = problem_taylor()
    f = @(t) exp(0.15 .* t) .* sin(t) + 50;

    derivatives = {
        @(t) exp(0.15 .* t) .* (0.15 .* sin(t) + cos(t))
        @(t) exp(0.15 .* t) .* (0.3 .* cos(t) - 0.9775 .* sin(t))
        @(t) exp(0.15 .* t) .* (-0.446625 .* sin(t) - 0.9325 .* cos(t))
        @(t) exp(0.15 .* t) .* (0.86550625 .* sin(t) - 0.5865 .* cos(t))
        @(t) exp(0.15 .* t) .* (0.7163259375 .* sin(t) + 0.77753125 .* cos(t))
        @(t) exp(0.15 .* t) .* (-0.670082359375 .* sin(t) + 0.832955625 .* cos(t))
    };

    tValues = linspace(0, 5, 400);
    approximationOrders = [2, 4, 6];

    problemFigure = figure('Name', 'Taylor Approximation', 'NumberTitle', 'off');
    plot(tValues, f(tValues), 'k', 'LineWidth', 2, 'DisplayName', 'Original function');
    hold on;
    grid on;

    lineStyles = {'--r', '--b', '--g'};
    resultRows = zeros(numel(approximationOrders), 4);
    intervalWindowMaximumErrors = zeros(numel(approximationOrders), 1);

    for index = 1:numel(approximationOrders)
        currentOrder = approximationOrders(index);
        approximatedValues = taylor_approximation( ...
            f, derivatives, 0, tValues, currentOrder);

        absoluteError = abs(f(tValues) - approximatedValues);
        maxAbsoluteError = max(absoluteError);
        meanAbsoluteError = mean(absoluteError);
        nearExpansionMask = tValues <= 2;
        intervalWindowMaximumErrors(index) = max(absoluteError(nearExpansionMask));

        resultRows(index, :) = [currentOrder, maxAbsoluteError, meanAbsoluteError, ...
            intervalWindowMaximumErrors(index)];

        plot(tValues, approximatedValues, lineStyles{index}, 'LineWidth', 1.5, ...
            'DisplayName', sprintf('Taylor order %d', currentOrder));
    end

    xlabel('t');
    ylabel('f(t)');
    title('Taylor Approximation Around t = 0');
    legend('Location', 'best');
    hold off;

    resultTable = array2table(resultRows, ...
        'VariableNames', {'Order', 'MaxAbsoluteError', 'MeanAbsoluteError', ...
        'MaxAbsoluteErrorNearExpansion'});

    disp('=== PROBLEM 1: TAYLOR APPROXIMATION ===');
    disp(resultTable);

    save_figure_file(problemFigure, 'problem_1_taylor_approximation');
    save_table_file(resultTable, 'problem_1_taylor_metrics');

    result = struct( ...
        'problemNumber', 1, ...
        'title', 'Taylor Approximation', ...
        'summary', sprintf(['Orders 2, 4 and 6 were evaluated on [0, 5]. ', ...
            'As expected, the local error near the expansion point decreases ', ...
            'when higher-order polynomials are used.']), ...
        'mainTable', resultTable);
end
