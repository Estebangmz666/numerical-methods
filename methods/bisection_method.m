function [root, iterationCount, metadata] = bisection_method( ...
    functionHandle, leftEndpoint, rightEndpoint, tolerance, maxIterations)
    narginchk(5, 5);

    if ~isa(functionHandle, 'function_handle')
        error('bisection_method:InvalidFunctionHandle', ...
            'functionHandle must be a valid function handle.');
    end

    validateattributes(leftEndpoint, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'leftEndpoint', 2);
    validateattributes(rightEndpoint, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'rightEndpoint', 3);
    validateattributes(tolerance, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'}, mfilename, 'tolerance', 4);
    validateattributes(maxIterations, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'integer', 'positive'}, ...
        mfilename, 'maxIterations', 5);

    if leftEndpoint >= rightEndpoint
        error('bisection_method:InvalidInterval', ...
            'leftEndpoint must be smaller than rightEndpoint.');
    end

    leftValue = functionHandle(leftEndpoint);
    rightValue = functionHandle(rightEndpoint);

    validateattributes(leftValue, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'functionHandle(leftEndpoint)');
    validateattributes(rightValue, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'functionHandle(rightEndpoint)');

    if leftValue == 0
        root = leftEndpoint;
        iterationCount = 0;
        metadata = buildMetadata(true, leftEndpoint, rightEndpoint, tolerance, ...
            maxIterations, leftValue, rightValue, root, 0, abs(leftValue), true);
        return;
    end

    if rightValue == 0
        root = rightEndpoint;
        iterationCount = 0;
        metadata = buildMetadata(true, leftEndpoint, rightEndpoint, tolerance, ...
            maxIterations, leftValue, rightValue, root, 0, abs(rightValue), true);
        return;
    end

    if leftValue * rightValue > 0
        error('bisection_method:NoSignChange', ...
            'The interval must contain a sign change.');
    end

    intervalHistory = zeros(maxIterations, 2);
    midpointHistory = zeros(maxIterations, 1);
    functionHistory = zeros(maxIterations, 1);
    errorHistory = zeros(maxIterations, 1);

    root = NaN;
    converged = false;

    for iterationIndex = 1:maxIterations
        midpoint = (leftEndpoint + rightEndpoint) / 2;
        midpointValue = functionHandle(midpoint);

        validateattributes(midpointValue, {'numeric'}, ...
            {'real', 'finite', 'scalar'}, mfilename, 'functionHandle(midpoint)');

        intervalHistory(iterationIndex, :) = [leftEndpoint, rightEndpoint];
        midpointHistory(iterationIndex) = midpoint;
        functionHistory(iterationIndex) = midpointValue;
        errorHistory(iterationIndex) = (rightEndpoint - leftEndpoint) / 2;

        root = midpoint;

        if abs(midpointValue) <= tolerance || errorHistory(iterationIndex) <= tolerance
            iterationCount = iterationIndex;
            converged = true;
            break;
        end

        if leftValue * midpointValue < 0
            rightEndpoint = midpoint;
            rightValue = midpointValue;
        else
            leftEndpoint = midpoint;
            leftValue = midpointValue;
        end
    end

    if ~converged
        iterationCount = maxIterations;
    end

    metadata = buildMetadata(converged, leftEndpoint, rightEndpoint, tolerance, ...
        maxIterations, leftValue, rightValue, root, iterationCount, ...
        abs(functionHistory(iterationCount)), false);
    metadata.intervalHistory = intervalHistory(1:iterationCount, :);
    metadata.midpointHistory = midpointHistory(1:iterationCount);
    metadata.functionHistory = functionHistory(1:iterationCount);
    metadata.errorHistory = errorHistory(1:iterationCount);
end

function metadata = buildMetadata(converged, leftEndpoint, rightEndpoint, tolerance, ...
    maxIterations, leftValue, rightValue, root, iterationCount, finalResidual, hitEndpoint)
    metadata = struct( ...
        'converged', converged, ...
        'leftEndpoint', leftEndpoint, ...
        'rightEndpoint', rightEndpoint, ...
        'tolerance', tolerance, ...
        'maxIterations', maxIterations, ...
        'leftValue', leftValue, ...
        'rightValue', rightValue, ...
        'root', root, ...
        'iterationCount', iterationCount, ...
        'finalResidual', finalResidual, ...
        'hitEndpoint', hitEndpoint);
end
