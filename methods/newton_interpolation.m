function [interpolatedValues, dividedDifferenceTable, metadata] = newton_interpolation( ...
    xData, yData, evaluationPoints)
    narginchk(3, 3);
    [xData, yData] = validateInterpolationInput(xData, yData, mfilename);

    originalSize = size(evaluationPoints);
    evaluationPoints = evaluationPoints(:);

    nodeCount = numel(xData);
    dividedDifferenceTable = zeros(nodeCount, nodeCount);
    dividedDifferenceTable(:, 1) = yData;

    for columnIndex = 2:nodeCount
        for rowIndex = 1:(nodeCount - columnIndex + 1)
            numerator = dividedDifferenceTable(rowIndex + 1, columnIndex - 1) - ...
                dividedDifferenceTable(rowIndex, columnIndex - 1);
            denominator = xData(rowIndex + columnIndex - 1) - xData(rowIndex);
            dividedDifferenceTable(rowIndex, columnIndex) = numerator / denominator;
        end
    end

    newtonCoefficients = dividedDifferenceTable(1, :);
    interpolatedValues = zeros(size(evaluationPoints));

    for pointIndex = 1:numel(evaluationPoints)
        currentPoint = evaluationPoints(pointIndex);
        currentValue = newtonCoefficients(1);
        cumulativeProduct = 1;

        for coefficientIndex = 2:nodeCount
            cumulativeProduct = cumulativeProduct * ...
                (currentPoint - xData(coefficientIndex - 1));
            currentValue = currentValue + ...
                newtonCoefficients(coefficientIndex) * cumulativeProduct;
        end

        interpolatedValues(pointIndex) = currentValue;
    end

    interpolatedValues = reshape(interpolatedValues, originalSize);

    metadata = struct( ...
        'nodeCount', nodeCount, ...
        'xData', xData, ...
        'yData', yData, ...
        'newtonCoefficients', newtonCoefficients, ...
        'polynomialHandle', @(x) evaluateNewtonPolynomial(newtonCoefficients, xData, x));
end

function values = evaluateNewtonPolynomial(newtonCoefficients, xData, evaluationPoints)
    values = zeros(size(evaluationPoints));

    for pointIndex = 1:numel(evaluationPoints)
        currentPoint = evaluationPoints(pointIndex);
        currentValue = newtonCoefficients(1);
        cumulativeProduct = 1;

        for coefficientIndex = 2:numel(newtonCoefficients)
            cumulativeProduct = cumulativeProduct * ...
                (currentPoint - xData(coefficientIndex - 1));
            currentValue = currentValue + ...
                newtonCoefficients(coefficientIndex) * cumulativeProduct;
        end

        values(pointIndex) = currentValue;
    end
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
