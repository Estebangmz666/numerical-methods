function save_figure_file(figureHandle, baseFileName)
    validateattributes(baseFileName, {'char', 'string'}, ...
        {'nonempty'}, mfilename, 'baseFileName', 2);

    outputPath = fullfile('results', 'figures', char(baseFileName));
    exportgraphics(figureHandle, strcat(outputPath, '.png'), 'Resolution', 300);
end
