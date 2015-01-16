function [object,position,storage] = storage_output(storage)
% This function returns an error message when 'storage' is a zero-matrix
%% INPUT ARGUMENTS
%{
'storage': matrix with n rows and variable number of columns
           n: number of objects in the network
%}
%% OUTPUT REQUEST
%{
storage_output() is called from all_paths_1() / all_paths_2() only if
'storage' contains at least one non-zero element
%}

j = 0;
len = length(storage(:,1));

while true
    position = len - j;
    row = storage(position,:);
    if any(row)
        non_zeros = find(row);
        object = row(non_zeros(1));
        storage(position,non_zeros(1)) = 0;
       break;
       % break-statment will terminate the loop
    end
        j = j + 1;
end
end