function [interpolatedValues, coefficients, metadata] = lagrange_interpolation( ...
    xData, yData, evaluationPoints)
    narginchk(3, 3);
    [xData, yData] = validateInterpolationInput(xData, yData, mfilename);

    originalSize = size(evaluationPoints);
    evaluationPoints = evaluationPoints(:);

    nodeCount = numel(xData);
    interpolatedValues = zeros(size(evaluationPoints));
    basisDenominators = ones(nodeCount, 1);

    vandermondeMatrix = zeros(nodeCount, nodeCount);
    for rowIndex = 1:nodeCount
        vandermondeMatrix(rowIndex, :) = xData(rowIndex) .^ (0:(nodeCount - 1));
    end
    coefficients = (vandermondeMatrix \ yData).';

    for basisIndex = 1:nodeCount
        basisPolynomial = ones(size(evaluationPoints));
        denominator = 1;

        for nodeIndex = 1:nodeCount
            if nodeIndex ~= basisIndex
                basisPolynomial = basisPolynomial .* ...
                    (evaluationPoints - xData(nodeIndex)) ./ ...
                    (xData(basisIndex) - xData(nodeIndex));
                denominator = denominator * (xData(basisIndex) - xData(nodeIndex));
            end
        end

        interpolatedValues = interpolatedValues + yData(basisIndex) .* basisPolynomial;
        basisDenominators(basisIndex) = denominator;
    end

    interpolatedValues = reshape(interpolatedValues, originalSize);

    metadata = struct( ...
        'nodeCount', nodeCount, ...
        'xData', xData, ...
        'yData', yData, ...
        'basisDenominators', basisDenominators, ...
        'polynomialHandle', @(x) polyval(fliplr(coefficients), x));
end

function [xData, yData] = validateInterpolationInput(xData, yData, functionName)
    validateattributes(xData, {'numeric'}, ...
        {'real', 'finite', 'vector', 'nonempty'}, functionName, 'xData', 1);
    validateattributes(yData, {'numeric'}, ...
        {'real', 'finite', 'vector', 'nonempty'}, functionName, 'yData', 2);

    xData = xData(:);
    yData = yData(:);

    if numel(xData) ~= numel(yData)
        error('%s:DimensionMismatch', functionName, ...
            'xData and yData must have the same number of elements.');
    end

    if numel(unique(xData)) ~= numel(xData)
        error('%s:RepeatedNodes', functionName, ...
            'xData must not contain repeated interpolation nodes.');
    end
end
