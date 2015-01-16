function [combinations] = find_combinations...
    (all_worksites_1,all_worksites_2,network_data)
%% INPUT ARGUMENTS
%{
'all_worksites_1': all possible paths with maximum workzone 
                   length constraint
'all_worksites_2': all possible paths with minimum distance 
                   between workzones constraint
'network_data': n x 4 matrix
    - n: number of objects in the network
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
%}

%% FIND COMBINATIONS
%{
find_combinations() finds all the possible combinations of objects
in the network that violate both the maximum workzone length constraint
and the minimum distance between workzones.

Fictive example:
If object 1 is part of a workzone, then objects 4 and 5 cannot be part
of any workzone in the network:
- Objects 4 and 5 are too far away to be part of the same workzone as
  object 1 (they violate the maximum workzone length constraint)
- Objects 4 and 5 are too close to object 1 to be part of another
  workzone (they violate the minimum distance between workzones constraint)

find_combinations() calculates for every object in the network these
combinations of objects that cannot be chosen simultaneously.
%}

rows = length(network_data(:,1));

combinations = zeros(rows);

for j = 1 : rows
    
    % Find all paths that start with j
    indices_1 = all_worksites_1(1,:) == j;
    indices_2 = all_worksites_2(1,:) == j;
    
    % Find all the objects that are part of paths starting with j
    elements_1 = unique(all_worksites_1(:,indices_1));
    elements_2 = unique(all_worksites_2(:,indices_2));
    
    % Delete zeros because zero is not an object
    elements_1 = elements_1(elements_1 ~= 0);
    elements_2 = elements_2(elements_2 ~= 0);
    
    % Remove j
    elements_1 = elements_1(elements_1 ~= j);
    elements_2 = elements_2(elements_2 ~= j);
    
    for l = 1 : length(elements_1)
        % Find common objects
        index = (elements_2 == elements_1(l));
        % Remove the common object from 'elements_2'
        elements_2(index) = [];
    end
   
    combinations(j,1:length(elements_2)) = elements_2; 
end

% Delete preallocated columns that have not been used
combinations = combinations(:,any(combinations));
end