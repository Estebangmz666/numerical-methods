function result = problem_ode()
    odeFunction = @(t, y) 0.6 .* y .* (1 - y ./ 500);
    interval = [0, 10];
    initialValue = 50;
    stepSizes = [1, 0.5, 0.25];

    denseTime = linspace(interval(1), interval(2), 1000);
    exactSolution = @(t) 500 ./ (1 + 9 .* exp(-0.6 .* t));

    problemFigure = figure('Name', 'ODE Numerical Solution', 'NumberTitle', 'off');
    plot(denseTime, exactSolution(denseTime), 'k', 'LineWidth', 2, ...
        'DisplayName', 'Exact logistic solution');
    hold on;
    grid on;

    colorMap = lines(numel(stepSizes) * 2);
    resultRows = zeros(numel(stepSizes) * 2, 4);
    rowIndex = 1;

    for index = 1:numel(stepSizes)
        currentStepSize = stepSizes(index);

        [tEuler, yEuler] = euler_method( ...
            odeFunction, interval, initialValue, currentStepSize);
        [tRungeKutta, yRungeKutta] = runge_kutta_4( ...
            odeFunction, interval, initialValue, currentStepSize);

        exactEuler = exactSolution(tEuler);
        exactRungeKutta = exactSolution(tRungeKutta);

        eulerMaxError = max(abs(yEuler - exactEuler));
        rungeKuttaMaxError = max(abs(yRungeKutta - exactRungeKutta));

        plot(tEuler, yEuler, '--', 'Color', colorMap((index - 1) * 2 + 1, :), ...
            'LineWidth', 1.5, 'DisplayName', sprintf('Euler h = %.2f', currentStepSize));
        plot(tRungeKutta, yRungeKutta, ':', 'Color', colorMap((index - 1) * 2 + 2, :), ...
            'LineWidth', 2, 'DisplayName', sprintf('RK4 h = %.2f', currentStepSize));

        resultRows(rowIndex, :) = [1, currentStepSize, yEuler(end), eulerMaxError];
        rowIndex = rowIndex + 1;

        resultRows(rowIndex, :) = [2, currentStepSize, yRungeKutta(end), rungeKuttaMaxError];
        rowIndex = rowIndex + 1;
    end

    xlabel('t');
    ylabel('y(t)');
    title('Euler vs Runge-Kutta 4');
    legend('Location', 'best');
    hold off;

    methodLabels = strings(size(resultRows, 1), 1);
    methodLabels(resultRows(:, 1) == 1) = "Euler";
    methodLabels(resultRows(:, 1) == 2) = "Runge-Kutta 4";

    resultTable = table( ...
        methodLabels, ...
        resultRows(:, 2), ...
        resultRows(:, 3), ...
        resultRows(:, 4), ...
        'VariableNames', {'Method', 'StepSize', 'FinalApproximation', 'MaxAbsoluteError'});

    disp('=== PROBLEM 5: ODE SOLUTION ===');
    disp(resultTable);

    save_figure_file(problemFigure, 'problem_5_ode_solution');
    save_table_file(resultTable, 'problem_5_ode_metrics');

    result = struct( ...
        'problemNumber', 5, ...
        'title', 'ODE Numerical Solution', ...
        'summary', sprintf(['Runge-Kutta 4 is substantially more accurate than Euler ', ...
            'for all evaluated step sizes on the interval [0, 10].']), ...
        'mainTable', resultTable);
end
