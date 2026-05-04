function [root, iterationCount, metadata] = newton_raphson_method( ...
    functionHandle, derivativeHandle, initialGuess, tolerance, maxIterations)
    narginchk(5, 5);

    if ~isa(functionHandle, 'function_handle')
        error('newton_raphson_method:InvalidFunctionHandle', ...
            'functionHandle must be a valid function handle.');
    end

    if ~isa(derivativeHandle, 'function_handle')
        error('newton_raphson_method:InvalidDerivativeHandle', ...
            'derivativeHandle must be a valid function handle.');
    end

    validateattributes(initialGuess, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'initialGuess', 3);
    validateattributes(tolerance, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'}, mfilename, 'tolerance', 4);
    validateattributes(maxIterations, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'integer', 'positive'}, ...
        mfilename, 'maxIterations', 5);

    approximationHistory = zeros(maxIterations + 1, 1);
    functionHistory = zeros(maxIterations + 1, 1);
    derivativeHistory = zeros(maxIterations + 1, 1);
    relativeStepHistory = zeros(maxIterations, 1);

    currentApproximation = initialGuess;
    approximationHistory(1) = currentApproximation;
    converged = false;

    for iterationIndex = 1:maxIterations
        currentValue = functionHandle(currentApproximation);
        currentDerivative = derivativeHandle(currentApproximation);

        validateattributes(currentValue, {'numeric'}, ...
            {'real', 'finite', 'scalar'}, mfilename, ...
            'functionHandle(currentApproximation)');
        validateattributes(currentDerivative, {'numeric'}, ...
            {'real', 'finite', 'scalar'}, mfilename, ...
            'derivativeHandle(currentApproximation)');

        functionHistory(iterationIndex) = currentValue;
        derivativeHistory(iterationIndex) = currentDerivative;

        if abs(currentDerivative) <= eps
            error('newton_raphson_method:ZeroDerivative', ...
                'The derivative became zero or numerically unstable.');
        end

        nextApproximation = currentApproximation - currentValue / currentDerivative;
        approximationHistory(iterationIndex + 1) = nextApproximation;

        denominator = max(1, abs(nextApproximation));
        relativeStepHistory(iterationIndex) = abs(nextApproximation - currentApproximation) / denominator;

        if abs(functionHandle(nextApproximation)) <= tolerance || ...
                relativeStepHistory(iterationIndex) <= tolerance
            currentApproximation = nextApproximation;
            converged = true;
            iterationCount = iterationIndex;
            break;
        end

        currentApproximation = nextApproximation;
    end

    if ~converged
        iterationCount = maxIterations;
    end

    root = currentApproximation;
    finalValue = functionHandle(root);

    approximationHistory = approximationHistory(1:(iterationCount + 1));
    functionHistory = functionHistory(1:iterationCount);
    derivativeHistory = derivativeHistory(1:iterationCount);
    relativeStepHistory = relativeStepHistory(1:iterationCount);

    metadata = struct( ...
        'converged', converged, ...
        'initialGuess', initialGuess, ...
        'tolerance', tolerance, ...
        'maxIterations', maxIterations, ...
        'root', root, ...
        'finalResidual', abs(finalValue), ...
        'approximationHistory', approximationHistory, ...
        'functionHistory', functionHistory, ...
        'derivativeHistory', derivativeHistory, ...
        'relativeStepHistory', relativeStepHistory);
end
