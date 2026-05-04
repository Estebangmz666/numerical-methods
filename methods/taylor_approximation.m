function [approximatedValues, coefficients, metadata] = taylor_approximation( ...
    functionHandle, derivativeHandles, expansionPoint, evaluationPoints, order)
%TAYLOR_APPROXIMATION Approximate a function using its Taylor polynomial.
%   [approximatedValues, coefficients, metadata] = TAYLOR_APPROXIMATION( ...
%       functionHandle, derivativeHandles, expansionPoint, evaluationPoints, order)
%   computes the Taylor polynomial of the requested ORDER around
%   EXPANSIONPOINT and evaluates it at EVALUATIONPOINTS.
%
%   Inputs:
%       functionHandle      - Function handle for f(x).
%       derivativeHandles   - Cell array of function handles for the
%                             derivatives of f:
%                             {f'(x), f''(x), ..., f^(order)(x)}.
%       expansionPoint      - Point a where the Taylor series is expanded.
%       evaluationPoints    - Scalar, vector or matrix of x values.
%       order               - Non-negative integer polynomial order.
%
%   Outputs:
%       approximatedValues  - Taylor approximation evaluated at the input
%                             points, preserving the original shape.
%       coefficients        - Row vector with polynomial coefficients in
%                             ascending powers:
%                             [c0, c1, c2, ..., c_order].
%       metadata            - Struct with additional information:
%                             .expansionPoint
%                             .order
%                             .polynomialHandle
%                             .termValuesAtExpansionPoint
%
%   Example:
%       f = @(t) exp(0.15 .* t) .* sin(t) + 50;
%       derivatives = {
%           @(t) exp(0.15 .* t) .* (0.15 .* sin(t) + cos(t))
%           @(t) exp(0.15 .* t) .* (-0.9775 .* sin(t) + 0.3 .* cos(t))
%       };
%       points = linspace(0, 5, 100);
%       [yApprox, coefficients] = taylor_approximation(f, derivatives, 0, points, 2);

    narginchk(5, 5);

    validateattributes(expansionPoint, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'expansionPoint', 3);
    validateattributes(evaluationPoints, {'numeric'}, ...
        {'real', 'finite'}, mfilename, 'evaluationPoints', 4);
    validateattributes(order, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'integer', 'nonnegative'}, ...
        mfilename, 'order', 5);

    if ~isa(functionHandle, 'function_handle')
        error('taylor_approximation:InvalidFunctionHandle', ...
            'functionHandle must be a valid function handle.');
    end

    if ~iscell(derivativeHandles)
        error('taylor_approximation:InvalidDerivativeContainer', ...
            'derivativeHandles must be a cell array of function handles.');
    end

    if numel(derivativeHandles) < order
        error('taylor_approximation:InsufficientDerivatives', ...
            ['At least %d derivative handles are required for order %d. ', ...
             'Received %d.'], order, order, numel(derivativeHandles));
    end

    for derivativeIndex = 1:order
        if ~isa(derivativeHandles{derivativeIndex}, 'function_handle')
            error('taylor_approximation:InvalidDerivativeHandle', ...
                'Each derivative entry must be a function handle.');
        end
    end

    originalSize = size(evaluationPoints);
    flattenedEvaluationPoints = evaluationPoints(:);

    coefficients = zeros(1, order + 1);
    termValuesAtExpansionPoint = zeros(1, order + 1);

    baseValue = functionHandle(expansionPoint);
    validateattributes(baseValue, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'functionHandle(expansionPoint)');

    coefficients(1) = baseValue;
    termValuesAtExpansionPoint(1) = baseValue;

    for derivativeOrder = 1:order
        derivativeValue = derivativeHandles{derivativeOrder}(expansionPoint);

        validateattributes(derivativeValue, {'numeric'}, ...
            {'real', 'finite', 'scalar'}, mfilename, ...
            sprintf('derivativeHandles{%d}(expansionPoint)', derivativeOrder));

        termValuesAtExpansionPoint(derivativeOrder + 1) = derivativeValue;
        coefficients(derivativeOrder + 1) = derivativeValue / factorial(derivativeOrder);
    end

    shiftedPoints = flattenedEvaluationPoints - expansionPoint;
    approximatedValues = zeros(size(flattenedEvaluationPoints));

    for derivativeOrder = 0:order
        approximatedValues = approximatedValues + ...
            coefficients(derivativeOrder + 1) .* shiftedPoints .^ derivativeOrder;
    end

    approximatedValues = reshape(approximatedValues, originalSize);

    metadata = struct( ...
        'expansionPoint', expansionPoint, ...
        'order', order, ...
        'polynomialHandle', @(x) evaluateTaylorPolynomial(coefficients, expansionPoint, x), ...
        'termValuesAtExpansionPoint', termValuesAtExpansionPoint);
end

function values = evaluateTaylorPolynomial(coefficients, expansionPoint, evaluationPoints)
    shiftedPoints = evaluationPoints - expansionPoint;
    values = zeros(size(evaluationPoints));

    for derivativeOrder = 0:(numel(coefficients) - 1)
        values = values + coefficients(derivativeOrder + 1) .* shiftedPoints .^ derivativeOrder;
    end
end