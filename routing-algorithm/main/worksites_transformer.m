function [transformed_worksites] =...
    worksites_transformer(worksites,network_data)
%% INPUT ARGUMENTS
%{
'worksites': 
    - matrix with n rows and varying number of columns
    - n: number of objects in the network
    - contains calculated paths
'network_data': n x 4 matrix
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
%}

%% TRANSFORMATION
%{
This function transforms the possible paths/worksites into another syntax:
- Every object is listed in its corresponding row (e.g object 4 in row 4)
- The length of the object (instead of the object itself) is assigned
%}

rows = length(network_data(:,1));
columns = length(worksites(1,:));
transformed_worksites = zeros(rows,columns);

% Append additional row of zeros at the bottom
worksites = [worksites; zeros(columns)];
%{
Add a row of zeros at the bottom of 'worksites'.
If 'worksites' has been stripped/shorted with
the shortening()-function, then the while loop
would return an error message (out of bounds
indices) without this additional row of zeros.
%}

for j = 1 : columns
    l = 1;
    while worksites(l,j) > 0
        transformed_worksites(worksites(l,j),j) =...
            network_data(worksites(l,j),2);
        l = l + 1;
    end
end
end