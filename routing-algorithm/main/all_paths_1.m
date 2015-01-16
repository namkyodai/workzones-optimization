function [worksites, number] =...
    all_paths_1(object,network_data,adjacency_matrix,mwzl)
% paths with maximum workzone length constraint
%% INPUT ARGUMENTS
%{
'object': current/last object that has been added to 'path'
'network_data': n x 4 matrix
    - n: number of objects in the network
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
'adjacency_matrix': n x n matrix containing the connections
                    between the objects
'mwzl': maximum workzone length
%}
%% INITIALIZING
%  Initalize path, storage, worksites, position and j

path = zeros(length(adjacency_matrix),2);
storage = zeros(length(adjacency_matrix),20);
%{
Make sure that storage has enough columns in order to be able to store
all the eligible objects. The number of columns does not matter as 
long as it exceeds the largest intersection.
%}
worksites = zeros(length(adjacency_matrix),10000);
%{
'worksites' contains all the possible paths starting with 'object'
Make sure that enough columns are preallocated in order to store
every calculated path
%}
position = 1;
j = 1;

%% CALCULATE ALL PATHS
%{
all_paths_1() calculates all possible paths that start with 'object'
and stores the calculated paths in 'worksites'
%}

while true
    
    % Calculate a single path
    [path,storage] = path_calculator_1(object,path,storage,...
        position,network_data,adjacency_matrix,mwzl);
    % Store calculated path in 'worksites'
    worksites(:,j) = path(:,1);
    
    if all(all(storage == 0))
        % true if storage contains only zero-elements
        break;
        % break-statement will terminate the loop
    else
        % Request output for next path calculation
        [object,position,storage] = storage_output(storage);
    end
    
    path(position:end,:) = 0;
    j = j + 1;
end

% Delete the preallocated worksites columns that have not been used
worksites = worksites(:,any(worksites));
number = length(worksites(1,:));
end