function [unique_worksites_1] =...
    delete_copies_and_subsets_3(all_worksites_1,network_data)
%% INPUT ARGUMENTS
%{
'all_worksites_1': 
    - matrix with n rows and varying number of columns
    - n: number of objects in the network
    - contains all the paths calculated in complete_network_1()
'network_data': n x 4 matrix
    - column 1: objects of the network
    - column 2: lengths of the objects
    - column 3: node 1 of the object
    - column 4: node 2 of the object
%}

%% EXPLANATIONS
%{
'all_worksites_1' contains a lot of double entries (same paths) and
subsets of other paths. complete_network_1() calculates all possible
paths for all the objects in the network where the object is the
starting point of the calculation; this leads to 'all_worksites_1'
containing the same path (calculated in opposite directions) twice.
For every start/end point several subsets of existing paths are
created.

'unique_worksites_1' contains all possible paths only once and has no
subsets. Thus the size (number of columns) in 'unique_worksites_1' is 
less than half the size of 'all_worksites_1'.

A myriad of comparisons need to be done and this can take several 
minutes (or even more) to calculate. The required time to execute all
comparisons depends on the number of paths in 'all_worksites_1'.

The number of paths calculated in complete_network_1() depends on
the following variables:
- maximum workzone length
- number of objects in the network
- number of intersections and the proximity of these intersections
  in the network; with an increasing amount of intersections and
  an increasing intersection density, the number of possible paths
  grows exponentially.
    
The most time for the network calculation is spent in this function
and it's child functions.
%}
    
%% STEP 1: REMOVE THE DOUBLE ENTRIES
%{
Every path, which is constrainted by the maximum workzone length
is stored exactly twice (calculated from both start/end objects)
in 'all_worksites_1'. In step 1, these double entries are removed.
%}

[all_worksites_1] = shortening(all_worksites_1);
sorted_worksites_1 = sort(all_worksites_1);
length_worksites_1 = length(sorted_worksites_1(1,:));

for j = 1 : (length_worksites_1 - 1)
    
    for l = (j + 1) : length_worksites_1
        
        if isequal(sorted_worksites_1(:,j),sorted_worksites_1(:,l))
            all_worksites_1(:,l) = 0;
            break
            %{
            As soon as the double entry is found, the inner for-loop
            can be exited because there is no other copy of
            sorted_worksites_1(:,j) in the remaining network. This 
            reduces the amount of comparisons significantly.
            %}
        end
    end
end

% Delete the columns of the double entries (zero-columns)
reduced_worksites_1 = all_worksites_1(:,any(all_worksites_1));

%% STEP 2: TRANSFORM THE PATHS INTO ANOTHER FORMAT
%{
This transformation is done in order to speed the program up.
This transformation allows to get rid of the intersect()-function.
The execution of intersect() takes a lot of time and increases the 
calculation time significantly.
%}

[reduced_worksites_2] =...
    worksites_transformer(reduced_worksites_1,network_data);

%% STEP 3: REMOVE THE SUBSETS

length_worksites_2 = length(reduced_worksites_2(1,:));

for j = 1 : (length_worksites_2 - 1)
    path_1 = reduced_worksites_2(:,j);
    
    for l = (j + 1) : length_worksites_2
        path_2 = reduced_worksites_2(:,l);
        
        if all((path_1 - path_2) <= 0)
            % true when path_1 is a subset of path_2
            reduced_worksites_1(:,j) = 0;
            break
        end
        if all((path_1 - path_2) >= 0)
            % true when path_2 is a subset of path_1
            reduced_worksites_1(:,l) = 0;
        end
    end
end

% Delete the columns of the subsets (zero-columns)
unique_worksites_1 = reduced_worksites_1(:,any(reduced_worksites_1));
end
