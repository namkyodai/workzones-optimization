function [storage] = storage_input(storage,position,valid_objects)
%% INPUT ARGUMENTS
%{
'storage': matrix with n rows and variable number of columns
           n: number of objects in the network
'position': number of objects in 'path' / index of the last
            non-zero entry in 'path'
'valid_objects': objects that are eligible to be added to a path
%}

%% ASSIGNING OBJECTS TO STORAGE
%{
storage_input() is called from path_calculator_1() / path_calculator_2()
if 'valid_objects' contains two or more objects.
%}

l = 1;

for j = 1 : (length(valid_objects(:,1)) - 1) 
    %{
    (length(valid_objects(:,1)) - 1): 
    - first object from 'valid_objects' is used in the current
      path calculation
    - remaining objects are assigned to storage...
      (position,1:(length(valid_objects(:,1)) - 1))
    %}
    storage(position,l) = valid_objects((l + 1),1);
    l = l + 1;
end
end