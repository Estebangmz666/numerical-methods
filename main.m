clear;
clc;
close all;

addpath('methods', 'problems', 'utils');

ensure_results_directories();

problemResults = {
    problem_taylor()
    problem_roots()
    problem_interpolation()
    problem_integration()
    problem_ode()
};

write_summary_report(problemResults, fullfile('results', 'summary_report.txt'));
