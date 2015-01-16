%% LOAD THE DATA

% Turn the profiler on
profile on

% Define the Excel file
excel_file = 'Input_Network.xlsx';

% Define the Excel sheet
sheet = 3;

% Load the network from the input excel file
network_data = xlsread(excel_file,sheet,'A:D');

% Load the intervention types from the input excel file
int_types = xlsread(excel_file,sheet,'F:F');

% Load the maximum workzone length from the input excel file
mwzl = xlsread(excel_file,sheet,'H1');

% Load the minimum distance between workzones from the input file
% IMPORTANT REMARK: mdbw >= mwzl
mdbw = xlsread(excel_file,sheet,'J1');

%% ESTABLISH THE MATRICES NEEDED FOR THE OPTIMIZATION

% Establish the adjacency matrix
[adjacency_matrix,network_nodes] =...
    establish_adjacency_matrix(network_data);

% Establish the continuity matrix
[continuity_matrix] =...
    establish_continuity_matrix(adjacency_matrix,int_types);

% Calculate the paths for the maximum workzone length constraint
[all_worksites_1] =...
    complete_network_1(network_data,adjacency_matrix,mwzl);

% Calculate the paths for the minimum distance between workzones
[all_worksites_2] =...
    complete_network_2(network_data,adjacency_matrix,mdbw);

% Calculate the object combinations that cannot be chosen simultaneously
[combinations] = find_combinations...
    (all_worksites_1,all_worksites_2,network_data);

% Establish the combinations matrix
[pairs,combinations_matrix] =...
    establish_combinations_matrix(combinations,int_types);

% Create additional vectors needed for the optimazation
[RHS_continuity,object_matrix] = create_vectors...
    (adjacency_matrix,int_types);

% View the profiler
profile viewer

%% WRITE TO EXCEL FILE
% This just an example that shows how to import the matrices into Excel

%{
xlswrite('Output_Network.xlsx',continuity_matrix,2,'J14')

xlswrite('Output_Network.xlsx',combinations_matrix,2,'J61')

xlswrite('Output_Network.xlsx',object_matrix,2,'J10')

xlswrite('Output_Network.xlsx',pairs,2,'G61')

xlswrite('Output_Network.xlsx',RHS_continuity,2,'EI14')
%}









