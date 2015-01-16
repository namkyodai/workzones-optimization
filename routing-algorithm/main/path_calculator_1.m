function [path,storage] = path_calculator_1...
    (object,path,storage,position,network_data,adjacency_matrix,mwzl)
% paths with maximum workzone length constraint
%% INPUT ARGUMENTS
%{
'object': current/last object that has been added to 'path'
'path': n x 2 matrix
    - n: number of objects in the network
    - column 1: objects that have been selected for the current path
    - column 2: lengths of the selected objects
'storage': matrix with n rows and variable number of columns
'position': number of objects in 'path' / index of the last
            non-zero entry in 'path'
'network_data': n x 4 matrix
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
'adjacency_matrix': n x n matrix containing the connections
                    between the objects
'mwzl': maximum workzone length
%}

%% CHECK OBJECT LENGTH

if network_data(object,2) > mwzl
    %{
    Check if object is longer than the maximium workzone length.
    This if-statement should usually never be entered because no
    object in the road network should be longer than the maximum
    workzone length.
    %}
    return
end

%% CALCULATE A SINGLE PATH
%{
path_calculator_1() calculates a single path where 'object' is the last
object in the current path. If several objects (valid_objects) are
eligible to be added to the path, then the object with the lowest
number (= name/reference) is added to the current path an the other
object(s) are assigned to 'storage'.
%}

path(position,:) = network_data(object,1:2);
[valid_objects] = objects_selector_1...
    (object,position,path,network_data,adjacency_matrix,mwzl);

while true
    position = position + 1;
    
    if length(valid_objects(:,1)) >= 2
        storage = storage_input(storage,position,valid_objects);
    end
    
    %{
    isempty() returns logical 1 (true) if 'valid_objects' is 
    an empty matrix (= contains no elements).
    An empty matrix is not a zero-matrix!
    %}
    empty = isempty(valid_objects);
    if not(empty)
        %{
        not(true) = false
        not(false) = true
        %}
        path(position,:) = valid_objects(1,1:2);
    else
        break
        % break-statment will terminate the loop
    end
    
    [valid_objects] = objects_selector_1(valid_objects(1,1),...
        position,path,network_data,adjacency_matrix,mwzl);
    %{
    Other possible syntax:
    path(position,1) instead of valid_objects(1,1) because
    valid_objects(1,1) is added to path(position,1)
    %}
end
end