function [pairs,combinations_matrix] =...
    establish_combinations_matrix(combinations,int_types)
%% INPUT ARGUMENTS
%{
'combinations': 
matrix with n rows and varying number of columns containing the
combinations of objects that cannot be selected simultaneously
'int_types': n x 1 matrix
contains the number of possible interventions for every
object
%}

%% CALCULATE OBJECT PAIRS
%{
For every entry in 'combinations', an object pair is created and stored
in 'pairs'.
Fictive example:
The first row of 'combinations' contains the objects that cannot be
selcted if object 1 is selected; in this case 4 and 5 are the non-zero
entries.
- pairs(:,1) = [1 ; 4]
- pairs(:,2) = [1 ; 5]
....
%}

[rows,~] = size(combinations);
n = 1;

% Append additional column to avoid out-of-bounds error message
combinations = [combinations, zeros(rows,1)];

% Make sure that enough space is preallocated
pairs = zeros(2,1000000);

for j = 1 : rows
    
    l = 1;
    while combinations(j,l) ~= 0
        pairs(1,n) = j;
        pairs(2,n) = combinations(j,l);
        l = l + 1;
        n = n + 1;
    end
    
end

% Delete preallocated columns that have not been used
pairs = pairs(:,any(pairs));

%% DETECT AND DELETE DOUBLE ENTRIES

[~,n] = size(pairs);

% Sort the pairs to make them comparable
sorted_pairs = sort(pairs);

for j = 1 : (n - 1)
    for l = (j + 1) : n
        if isequal(sorted_pairs(:,j),sorted_pairs(:,l))
            pairs(:,l) = 0;
            break
        end
    end
end

% Delete the columns that contain only zeros
pairs = pairs(:,any(pairs));

%% ESTABLISH THE COMBINATIONS MATRIX
%{
The combinations matrix contains zeros and ones and is used to formulate
the maximum workzone length and the minimum distance between workzones
constraint. The number of rows is equal to the number of object pairs
and the number of columns depends on the number of objects in the
network and the number of possible interventions for every
object.
%}

pairs = pairs';
[n,~] = size(pairs);

pairs_matrix = zeros(n,length(int_types));

for j = 1 : n
    
    pairs_matrix(j,pairs(j,1)) = 1;
    pairs_matrix(j,pairs(j,2)) = 1;
    
end

combinations_matrix = zeros(n,sum(int_types));
l = 1;

for j = 1 : length(int_types)
    
    n = int_types(j);
    combinations_matrix(:,l:(l + n - 1)) = repmat(pairs_matrix(:,j),1,n);
    combinations_matrix(:,l) = 0;
    
    l = l + n;
    
end
end