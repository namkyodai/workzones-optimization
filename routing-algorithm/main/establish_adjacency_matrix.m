function [adjacency_matrix,network_nodes] =...
    establish_adjacency_matrix(network_data)
%% INPUT ARGUMENTS
%{
'network_data': n x 4 matrix
    - n: number of objects in the network
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
%}

%% NETWORK NODES
%{
'network_nodes' is a matrix with  a varying number of rows and
two columns. The number of rows is equal to the number of
nodes in the network.
- network_nodes(:,1): nodes of the network
- network_nodes(:,2): number of objects attached to each node
%}

% Find number of nodes in the network
nodes = unique(cat(1,network_data(:,3),network_data(:,4)));
%{
- cat(dim,A,B): concatenates arrays A and B along dimension dim
  dim = 1: concatenate along rows
- unique(A): returns all the different elements contained in A
%}

network_nodes = zeros(length(nodes),2);

network_nodes(:,1) = nodes;

% Find the number of objects connected to each node
for j = 1 : length(nodes)
    network_nodes(j,2) =...
        length(find(network_data(:,3:4) == network_nodes(j,1)));
end

%% ADJACENCY MATRIX
%{
'adjacency_matrix' is a square matrix that contains the object
connections. 1 stands for connection and zero stands for no 
connection.
It is important that the objects are listed in ascending
order starting at 1 and that no numbers are missing.
This is due to the fact that this program uses find()
in several functions; find() returns the index of an array and
the indices must be equal to the object numbers. If the objects
do not match the indices, then references to the wrong objects
will be made and wrong/impossible paths will be calculated.
%}

adjacency_matrix = zeros(length(network_data(:,1)));    % Square matrix

for j = 1 : length(network_data(:,1))
    
    node_1 = network_data(j,3);
    node_2 = network_data(j,4);
    [r_1,~] = find(network_data(:,3:4) == node_1);
    [r_2,~] = find(network_data(:,3:4) == node_2);
    
    for l = 1 : length(r_1)
        if r_1(l) == j    
            % Do nothing if true (= remains 0)
        else
        adjacency_matrix(j,r_1(l)) = 1;
        end
    end
    
    for s = 1 : length(r_2)
        if r_2(s) == j    
            % Do nothing if true (= remains 0)
        else
        adjacency_matrix(j,r_2(s)) = 1;
        end
    end
    
end
end
