function [RHS_continuity,object_matrix] = create_vectors...
    (adjacency_matrix,int_types)
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
'int_types': n x 1 matrix
contains the number of possible interventions for every
object
%}

%% RHS OF CONTINUITY CONSTRAINT
%{
'RHS_continuity' is a n x 1 vector containing the number of connections
of every object in the network.
%}

RHS_continuity_transpose = sum(adjacency_matrix);
RHS_continuity = RHS_continuity_transpose';

%% OBJECT VECTOR
%{
'object_matrix' is a matrix with two rows and a varying number of
columns. The number of columns depends on the number of objects in
the network and the number of possible interventions for every
object. Every object is represented for every possible intervention
in a seperate column.
%}

object_matrix = zeros(2,(max(int_types) * length(adjacency_matrix)));
l = 1;

for j = 1 : length(adjacency_matrix)
    object_matrix(1,l:(l + int_types(j) - 1)) = j;
    object_matrix(2,l:(l + int_types(j) - 1)) = ...
        (0 : (int_types(j) - 1));
   
    l = l + int_types(j);
end

% Delete the preallocated columns that have not been used
object_matrix = object_matrix(:,any(object_matrix));
end
