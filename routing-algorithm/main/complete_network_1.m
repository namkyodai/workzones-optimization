function [all_worksites_1,unique_worksites_1] =...
    complete_network_1(network_data,adjacency_matrix,mwzl)
% paths with maximum workzone length constraint
%% INPUT ARGUMENTS
%{
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

%% PREALLOCATION
%{
Important remark: make sure that 'all_worksites_1' has enough space;
if 'all_worksites_1' does not have enough preallocated columns to store
all the calculated paths, then this will result in an error message 
or some paths will be missing.
%}

all_worksites_1 = zeros(length(adjacency_matrix),200000);
column = 1;

%% CALCULATE ENTIRE NETWORK
%{
Calculate all possible paths for every object and assign them
to 'all_worksites_1'. 'all_worksites_1' will contain a lot of double
entries and subsets of other paths. These surplus paths can be
removed (if desired) with the delete_copies_and_subsets_3()-function.
%}

for j = 1 : length(adjacency_matrix)
 
   [worksites, number] = all_paths_1(network_data(j,1),...
       network_data,adjacency_matrix,mwzl);
    all_worksites_1(:,column:(column + number - 1)) = worksites;
    column = column + number;
end

% Delete preallocated columns that have not been used
all_worksites_1 = all_worksites_1(:,any(all_worksites_1));

%% REMOVE SURPLUS PATHS

[unique_worksites_1] = ...
    delete_copies_and_subsets_3(all_worksites_1,network_data);

%% DELETE ROWS THAT CONTAIN ONLY ZEROS

[all_worksites_1] = shortening(all_worksites_1);
%{
'unique_worksites_1' is already shorted/stripped in
delete_copies_and_subsets_3()
%}
end

