function [valid_objects] = objects_selector_2...
    (object,position,path,network_data,adjacency_matrix,mdbw)
% paths with minimum distance between workzones constraint
%% INPUT ARGUMENTS
%{
'object': current/last object that has been added to 'path'
'position': number of objects in 'path' / index of the last
            non-zero entry in 'path'
'path': n x 2 matrix
    - n: number of objects in the network
    - column 1: objects that have been selected for the current path
    - column 2: lengths of the selected objects
'network_data': n x 4 matrix
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
'adjacency_matrix': n x n matrix containing the connections
                    between the objects
'mdbw': minimum distance between workzones
%}

%% ADJACENT OBJECTS
%{
'adjacent_objects' are the objects that are connected (share at least 
one common node) to 'object'
%}

% find() returns the indices of a vector
object_connections = find(adjacency_matrix(object,:) == 1);
object_type = length(object_connections);
adjacent_objects = zeros(object_type,4);

%{
'adjacent_objects':
- column 1: connecting/adjacent objects
- column 2: lenghts of connecting/adjacent objects
- column 3: node 1 of connecting/adjacent objects
- column 4: node 2 of connecting/adjacent objects
%}

for j = 1 : object_type
    adjacent_objects(j,1) = object_connections(j);
    adjacent_objects(j,2:4) = network_data(object_connections(j),2:4);
end

%% POSSIBLE OBJECTS
%{
'possible_objects' are 'adjacent_objects' that are not
yet part of 'path'
%}

possible_objects = zeros(object_type,4);

for j = 1 : object_type
    if adjacent_objects(j,1) ~= path(:,1)
            possible_objects(j,:) = adjacent_objects(j,:);
    end
end

% Delete the preallocated rows that have not been used
possible_objects(possible_objects(:,1) == 0,:) = [];

%% VALID OBJECTS
%{
'valid_objects' are 'possible_objects' with the following constraint:
- Do not create an intersection when added to 'path':

  A path has exactly one start and one end node.
  A start/end node is a node that is connected to exactly one object
  in the current path; thus a path with intersection(s) is a path
  (= collection of objects) that has 3 or more start/end nodes.
  An object that creates an intersection is still a valid/eligible
  object as long as this object does not create an additional 
  start/end node.
%}

% Initialize 'valid_objects' with zeros
valid_objects = zeros(length(possible_objects(:,1)),4);

if (sum(path(:,2)) - path(1,2)) >= mdbw
    % current path is completed if true and 'valid_objects' is empty
    %{
    objects_selector_2() is used to calculate all the paths starting
    with a given object (= path(1,1)). Objects are added to 'path' as
    long as the minimum distance between workzones is not yet exceeded.
    The objects in the calculated paths are the objects that can not be
    selected for another workzone with respect to path(1:1).
    For this reason, path(1,2) is substracted from sum(path(:,2)).
    
    The condition in the above if-statement could theoretically be checked
    at the beginning of this function, but it is done here because the
    size of 'possible_objects' is not known at the beginning of the
    function.
    %}
    
    % 'valid_objects' has to be initalized first before its zero-columns
    % are deleted again, otherwise an error-message will occur
    valid_objects(valid_objects(:,1) == 0,:) = [];
    % return stops any further evaluation of this function
    return
end

if position == 1
    % 'path' contains only zero-elements
    valid_objects = possible_objects;
end

if position >= 2
    
    % Find the end node of 'path'
    nodes_1 = network_data(object,3:4);
    nodes_2 = network_data(path((position - 1),1),3:4);
    end_node = nodes_1(nodes_1 ~= intersect(nodes_1,nodes_2));
     %{
    Find commmon elements in two vectors A and B:
    - A(ismember(A,B)) / B(ismember(A,B)), or
    - intersect(A,B)
    %}
    
    if isempty(end_node)    
        % true when previous and current object share the same nodes
    
        if position == 2
            % Both nodes are end nodes
            valid_objects = possible_objects;
            return
        end
        if position >= 3
            nodes_3 = network_data(path((position - 2),1),3:4);
            end_node = intersect(nodes_1,nodes_3);
            %{
            Other possible syntax:
            - end_node = intersect(nodes_2,nodes_3);
            - nodes_1 and nodes_2 are equal vectors because 
              'object' and the previous object (path((position - 1),1))
              share the same nodes
            %}
        end
    end
    
    %{
    'possible_objects' that are connected to 'end_node'
    of 'path' are 'valid_objects'
    %}
    for j = 1 : length(possible_objects(:,1))
        if any(possible_objects(j,3:4) == end_node)
            valid_objects(j,:) = possible_objects(j,:);
        end
    end
end

% Delete the preallocated rows that have not been used
valid_objects(valid_objects(:,1) == 0,:) = [];
end






