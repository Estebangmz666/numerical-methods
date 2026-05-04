function save_table_file(tableValue, baseFileName)
    if ~istable(tableValue)
        error('save_table_file:InvalidTable', ...
            'tableValue must be a MATLAB table.');
    end

    validateattributes(baseFileName, {'char', 'string'}, ...
        {'nonempty'}, mfilename, 'baseFileName', 2);

    outputPath = fullfile('results', 'tables', char(baseFileName));
    writetable(tableValue, strcat(outputPath, '.csv'));
end
