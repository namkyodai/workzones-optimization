%% LOAD THE DATA

% Define the Excel file
excel_file = 'data_geoadmin.xlsx';

% Define the sheet in the Excel file
sheet = 1;

% Define the range in the Excel file that contains the network_data
range_network_data = 'A2:D568';

% Define the range in the Excel file that contains the intervention types
range_int_types = 'M2:M568';

% Define the range in the Excel file that contains condition state data
range_cs_data = 'O15:R19';

% Load the network from the input excel file
network_data = xlsread(excel_file,sheet,range_network_data);

% Load the intervention types from the input excel file
int_types = xlsread(excel_file,sheet,range_int_types);

% Number of objects in the network
 num = length(network_data(:,1));

% Load the condition state data
cs_data = xlsread(excel_file,sheet,range_cs_data);

%% GENERATE LOGNORMAL RANDOM VARIABLS
%{
It is assumed that the distribution of the condition states follows a
lognormal distribution.
%}

% Define the mean and variance of the condition states
mean = 2;
variance = 1;

% Parameters of the lognormal distribution
mu = log((mean^2)/sqrt(variance+mean^2));
sigma = sqrt(log(variance/(mean^2)+1));

% Generate lognormal random variables
X = lognrnd(mu,sigma,num,1);

% Initialize the condition state vector
cs_vector = zeros(num,1);

% num_cs indicates the number of objects in a specific condition state
num_cs = zeros(5,1);

for j = 1 : num
    if X(j) < 1
        cs_vector(j) = 1;
        num_cs(1) = num_cs(1) + 1;
    end
    
    if and(1 <= X(j), X(j) < 2)
        cs_vector(j) = 2;
        num_cs(2) = num_cs(2) + 1;
    end
    
    if and(2 <= X(j), X(j) < 3)
        cs_vector(j) = 3;
        num_cs(3) = num_cs(3) + 1;
    end
    
    if and(3 <= X(j), X(j) < 4)
        cs_vector(j) = 4;
        num_cs(4) = num_cs(4) + 1;
    end
    
    if 4 <= X(j)
        cs_vector(j) = 5;
        num_cs(5) = num_cs(5) + 1;
    end
end

%% ESTABLISH THE COSTS MATRIX

costs_matrix = zeros(7,(max(int_types) * num));
l = 1;

for j = 1 : num
    costs_matrix(1,l:(l + int_types(j) - 1)) = j;
    costs_matrix(2,l:(l + int_types(j) - 1)) = ...
        (0 : (int_types(j) - 1));
    costs_matrix(3,l:(l + int_types(j) - 1)) = cs_vector(j);
    
    l = l + int_types(j);
end

% Delete the preallocated columns that have not been used
costs_matrix = costs_matrix(:,any(costs_matrix));

for j = 1 : length(costs_matrix(1,:))
    cs = costs_matrix(3,j);
    int_type = costs_matrix(2,j);
    
    % Assign the benefits (MU / 1000 m)
    if int_type == 0
        % Do nothing
    end
    if int_type == 1
        costs_matrix(4,j) = cs_data(cs,2);
    end
    if int_type == 2
        costs_matrix(4,j) = cs_data(cs,3);
    end
    
    % Assign the costs (MU / 1000 m)
    if int_type == 0
        % Do nothing
    else
        costs_matrix(5,j) = cs_data(cs,4);
    end
    
    % Benefit
    costs_matrix(6,j) =...
        costs_matrix(4,j) * network_data(costs_matrix(1,j),2) / 1000;
    % Costs
    costs_matrix(7,j) =...
        costs_matrix(5,j) * network_data(costs_matrix(1,j),2) / 1000;
end





