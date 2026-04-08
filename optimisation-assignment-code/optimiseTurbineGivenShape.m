function [result, x] = optimiseTurbineGivenShape(fx, num_blades)
% OPTIMISETURBINEGIVENSHAPE Inner-loop scaffold for a fixed airfoil.
%
% Suggested steps:
%   1. set the usual global parameters (Vu, rho, eta, nSections, etc.)
global Vu rho eta nSections clearance B R Curve

%   2. set B = num_blades
B = num_blades;

%   3. choose lower and upper bounds for chord and beta
chord_upper = 0.3; %temp value -> potentially bad initial values
chord_lower = 0.14; %temp value

beta_upper = 40; %temp value
beta_lower = 14; %temp value

% upper and lower bound vectors for optimiser:
lb = [chord_lower*ones(1,nSections), deg2rad(beta_lower)*ones(1,nSections)]; %note: double check if beta is expected in degrees or radians
ub = [chord_upper*ones(1,nSections), deg2rad(beta_upper)*ones(1,nSections)];

%   4. define objective function
objective = @(design) turbineObj(design, fx);

%   5. run ga (or another justified optimiser)
% Simple Genitic-Algorithm attempt

Pop = 40;
MaxGens = 30;

options = optimoptions('ga', ...
'PopulationSize', Pop, ...
'MaxGenerations', MaxGens, ...
'Display', 'iter', ...
'PlotFcn', {@gaplotbestf, @gaplotbestindiv}); % can remove plots to run faster

%   6. evaluate the best design across the chosen wind speeds
[x_best, f_best] = ga(objective, 2*nSections, [], [], [], [], lb, ub, [], options);
performance = evaluateTurbine(x_best, fx); % can use this to determine convergence, issues, etc etc

%   7. return the best design and a short summary in result

% A simple starting point is to use a smooth reference design such as:
%   chord_ref = linspace(0.3, 0.14, nSections);
%   beta_ref = linspace(40, 14, nSections) * pi/180;
%
% You may then build sensible bounds around that reference, or use bounds
% based on a BEM design from your previous assignment.

result = struct();
result.performance = performance;
result.f_best = f_best; % note: couldn't find expected result format
result.num_blades = num_blades;
result.lb = lb;
result.ub = ub;
result.scheme = "Genetic";
result.PopulationSize = Pop;
result.MaxGenerations = MaxGens;

x = x_best; %x output might be expected as nonscalar, not sure []

%% function outputs -> [result, x]

% TODO: implement this file.
% Some groups may find it helpful to:
%   - start with a smaller population / fewer generations
%   - seed the initial population near a smooth reference design
%   - tighten bounds if completely random designs behave badly

%error('optimiseTurbineGivenShape:NotImplemented', ...
%    'Complete optimiseTurbineGivenShape.m before using it.');
%end
