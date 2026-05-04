function [tValues, yValues, metadata] = euler_method( ...
    odeFunction, interval, initialValue, stepSize)
    narginchk(4, 4);

    if ~isa(odeFunction, 'function_handle')
        error('euler_method:InvalidFunctionHandle', ...
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
        error('euler_method:InvalidInterval', ...
            'interval(2) must be greater than interval(1).');
    end

    stepCount = round((endPoint - startPoint) / stepSize);
    reconstructedEndPoint = startPoint + stepCount * stepSize;

    if abs(reconstructedEndPoint - endPoint) > 1e-10
        error('euler_method:IncompatibleStepSize', ...
            'stepSize must divide the interval length exactly.');
    end

    tValues = linspace(startPoint, endPoint, stepCount + 1).';
    yValues = zeros(stepCount + 1, 1);
    slopeHistory = zeros(stepCount, 1);
    yValues(1) = initialValue;

    for stepIndex = 1:stepCount
        currentSlope = odeFunction(tValues(stepIndex), yValues(stepIndex));

        validateattributes(currentSlope, {'numeric'}, ...
            {'real', 'finite', 'scalar'}, mfilename, 'odeFunction(t, y)');

        slopeHistory(stepIndex) = currentSlope;
        yValues(stepIndex + 1) = yValues(stepIndex) + stepSize * currentSlope;
    end

    metadata = struct( ...
        'interval', interval, ...
        'initialValue', initialValue, ...
        'stepSize', stepSize, ...
        'stepCount', stepCount, ...
        'slopeHistory', slopeHistory);
end
