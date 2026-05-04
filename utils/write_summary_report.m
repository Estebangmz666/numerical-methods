function write_summary_report(problemResults, outputPath)
    fileIdentifier = fopen(outputPath, 'w');

    if fileIdentifier == -1
        error('write_summary_report:FileOpenError', ...
            'Unable to create the summary report at %s.', outputPath);
    end

    cleanupObject = onCleanup(@() fclose(fileIdentifier));

    fprintf(fileIdentifier, 'NUMERICAL METHODS PROJECT SUMMARY\n');
    fprintf(fileIdentifier, 'Generated on: %s\n\n', char(datetime('now')));

    for resultIndex = 1:numel(problemResults)
        currentResult = problemResults{resultIndex};

        fprintf(fileIdentifier, 'Problem %d: %s\n', ...
            currentResult.problemNumber, currentResult.title);
        fprintf(fileIdentifier, '%s\n\n', currentResult.summary);

        if isfield(currentResult, 'mainTable') && istable(currentResult.mainTable)
            tableText = evalc('disp(currentResult.mainTable)');
            tableText = regexprep(tableText, '</?strong>', '');
            fprintf(fileIdentifier, '%s\n', tableText);
            fprintf(fileIdentifier, '\n');
        end
    end

    clear cleanupObject;
end
