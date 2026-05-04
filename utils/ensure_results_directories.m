function ensure_results_directories()
    requiredDirectories = {
        'results'
        fullfile('results', 'figures')
        fullfile('results', 'tables')
    };

    for directoryIndex = 1:numel(requiredDirectories)
        currentDirectory = requiredDirectories{directoryIndex};
        if ~exist(currentDirectory, 'dir')
            mkdir(currentDirectory);
        end
    end
end
