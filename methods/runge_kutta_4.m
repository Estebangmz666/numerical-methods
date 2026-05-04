function [tValues, yValues, metadata] = runge_kutta_4( ...
    odeFunction, interval, initialValue, stepSize)
    narginchk(4, 4);

    if ~isa(odeFunction, 'function_handle')
        error('runge_kutta_4:InvalidFunctionHandle', ...
            'odeFunction must be a valid function handle.');
    end

    validateattributes(interval, {'numeric'}, ...
        {'real', 'finite', 'vector', 'numel', 2}, mfilename, 'interval', 2);
    validateattributes(initialValue, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'initialValue', 3);
    validateattributes(stepSize, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'}, mfilename, 'stepSize', 4);

    interval = interval(:).';
    startPoint = interval(1);
    endPoint = interval(2);

    if endPoint <= startPoint
        error('runge_kutta_4:InvalidInterval', ...
            'interval(2) must be greater than interval(1).');
    end

    stepCount = round((endPoint - startPoint) / stepSize);
    reconstructedEndPoint = startPoint + stepCount * stepSize;

    if abs(reconstructedEndPoint - endPoint) > 1e-10
        error('runge_kutta_4:IncompatibleStepSize', ...
            'stepSize must divide the interval length exactly.');
    end

    tValues = linspace(startPoint, endPoint, stepCount + 1).';
    yValues = zeros(stepCount + 1, 1);
    k1History = zeros(stepCount, 1);
    k2History = zeros(stepCount, 1);
    k3History = zeros(stepCount, 1);
    k4History = zeros(stepCount, 1);
    yValues(1) = initialValue;

    for stepIndex = 1:stepCount
        currentTime = tValues(stepIndex);
        currentValue = yValues(stepIndex);

        k1 = odeFunction(currentTime, currentValue);
        k2 = odeFunction(currentTime + stepSize / 2, currentValue + stepSize * k1 / 2);
        k3 = odeFunction(currentTime + stepSize / 2, currentValue + stepSize * k2 / 2);
        k4 = odeFunction(currentTime + stepSize, currentValue + stepSize * k3);

        validateattributes(k1, {'numeric'}, {'real', 'finite', 'scalar'}, mfilename, 'k1');
        validateattributes(k2, {'numeric'}, {'real', 'finite', 'scalar'}, mfilename, 'k2');
        validateattributes(k3, {'numeric'}, {'real', 'finite', 'scalar'}, mfilename, 'k3');
        validateattributes(k4, {'numeric'}, {'real', 'finite', 'scalar'}, mfilename, 'k4');

        k1History(stepIndex) = k1;
        k2History(stepIndex) = k2;
        k3History(stepIndex) = k3;
        k4History(stepIndex) = k4;

        yValues(stepIndex + 1) = currentValue + ...
            (stepSize / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
    end

    metadata = struct( ...
        'interval', interval, ...
        'initialValue', initialValue, ...
        'stepSize', stepSize, ...
        'stepCount', stepCount, ...
        'k1History', k1History, ...
        'k2History', k2History, ...
        'k3History', k3History, ...
        'k4History', k4History);
end
