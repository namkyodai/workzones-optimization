function [continuity_matrix] =...
    establish_continuity_matrix(adjacency_matrix,int_types)
%% INPUT ARGUMENTS
%{
'adjacency_matrix': n x n matrix containing the connections
                    between the objects
                    n : number of objects in the network
'int_types': n x 1 matrix
             contains the number of possible intervention types for every
             object
%}
%% ESTABLISH THE CONTINUITY MATRIX
%{
'continuity_matrix' is a matrix with n rows and a varying number of
columns. The number of columns depends on the number of possible
intervention types for every object.

Fictive example:
Assume that every object in the network can have 3 different intervention
types; the size of 'continuity_matrix' will be n x (3 * n).
%}

continuity_matrix = zeros(length(adjacency_matrix),...
    (max(int_types) * length(adjacency_matrix)));

l = 1;

for j = 1 : length(adjacency_matrix)
    continuity_matrix(:,l:(l + int_types(j) - 1)) =...
        repmat(adjacency_matrix(:,j),1,int_types(j));
        %{
        B = repmat(A,m,n) consists of copies of A
        Size of B: [length(A(:,1))*m, length(A(1,:))*n]
        %}
        
    l = l + int_types(j);
    
end

% Delete the columns that conatin only zeros
continuity_matrix = continuity_matrix(:,any(continuity_matrix));
end
