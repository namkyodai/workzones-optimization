function [all_worksites_2] =...
    complete_network_2(network_data,adjacency_matrix,mdbw)
% paths with minimum distance between workzones constraint
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
'mdbw': minimum distance between workzones
%}

%% UNIQUE WORKSITES
%{
complete_network_2() does not calculate the unique paths (see output
arguments of complete_network_1()) because the computational time of 
delete_copies_and_subsets_3() grows exponentially with increasing
size of 'all_worksites_2'. The size (number of paths) in 'all_worksites_2'
is usually significantly larger than the size of 'all_worksites_1'
because the minimum distance between workzones is larger than the
maximum workzone length and thus the number of possible paths.

Even in complete_network_1(), the calculation of 'unique_worksites_1' is
not needed for the setup of the minimum distance between workzones /
maximum workzone length constraint, but it is only calculated to show
all the possible worksites.
%}

%% PREALLOCATION
%{
Important remark: make sure that 'all_worksites_2' has enough space;
if 'all_worksites_2' does not have enough preallocated columns to store
all the calculated paths, then this will result in an error message 
or some paths will be missing.
%}

all_worksites_2 = zeros(length(adjacency_matrix),200000);
column = 1;

%% CALCULATE ENTIRE NETWORK
%{
Calculate all possible paths for every object and assign them
to 'all_worksites_2'. The double entries and subsets won't be 
removed as explained above.
%}

for j = 1 : length(adjacency_matrix)
 
   [worksites, number] = all_paths_2(network_data(j,1),...
       network_data,adjacency_matrix,mdbw);
    all_worksites_2(:,column:(column + number - 1)) = worksites;
    column = column + number;
end

% Delete preallocated columns that have not been used
all_worksites_2 = all_worksites_2(:,any(all_worksites_2));

%% REMOVE ROWS THAT CONTAIN ONLY ZEROS

[all_worksites_2] = shortening(all_worksites_2);

end