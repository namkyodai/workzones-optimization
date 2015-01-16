function [worksites] = shortening(worksites)
%% INPUT ARGUMENTS
%{
'worksites': matrix with n rows and varying number of columns
             n: number of objects in the network
%}

%% DELETE ROWS THAT CONTAIN ONLY ZEROS 
%{
shortening() deletes the rows in 'worksites' that conatins only
zeros for improved visibility and handling in the command window
%}

worksites_ones = worksites;

% Transform every non-zero entry into one
worksites_ones(worksites_ones ~= 0) = 1;

% Find the maximum amount of objects comprising a path
max_worksites = max(sum(worksites_ones));

% Delete all the rows that contain only zeros
worksites((max_worksites + 1):end,:) = [];

end