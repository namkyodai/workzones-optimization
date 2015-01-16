%% ROAD NETWORK OF SWITZERLAND

% Load the complete road network of Switzerland into a cell array
[~,~, networkSwitzerland] = ...
    xlsread('Network Switzerland.xlsx',1,'A1:T60391');

%% ROAD NETWORK OF CANTON OF WALLIS

% Search for indices in cell array 'networkSwitzerland' containing 'Wallis'
kWallis = strfind(networkSwitzerland(:,15),'Wallis');

% Find the indices of non-empty cells
% Non-empty cells are the cells that comprise the road network of Wallis
indWallis = find(~cellfun(@isempty,kWallis));

% Complete Network of canton of Wallis
networkWallis = networkSwitzerland(indWallis,:);

%% ROAD TYPES IN THE CANTON OF WALLIS

% Find the different road types in the canton of Wallis
typesWallis = unique(networkWallis(:,5));

%% MOTORWAY CANTON OF WALLIS

% Search for indices in cell array 'networkWallis' containing 'motorway'
kWallisMotorway = strfind(networkWallis(:,5),'motorway');

% Find the indices of non-empty cells
indWallisMotorway = find(~cellfun(@isempty,kWallisMotorway));

% Motorway network of canton of Wallis
networkWallisMotorway = networkWallis(indWallisMotorway,:);

%% PRIMARY ROADS CANTON OF WALLIS

% Search for indices in cell array 'networkWallis' containing 'primary'
kWallisPrimary = strfind(networkWallis(:,5),'primary');

% Find the indices of non-empty cells
indWallisPrimary = find(~cellfun(@isempty,kWallisPrimary));

% Primary roads of canton of Wallis
networkWallisPrimary = networkWallis(indWallisPrimary,:);

%% SECONDARY ROADS CANTON OF WALLIS

% Search for indices in cell array 'networkWallis' containing 'secondary'
kWallisSecondary = strfind(networkWallis(:,5),'secondary');

% Find the indices of non-empty cells
indWallisSecondary = find(~cellfun(@isempty,kWallisSecondary));

% Secondary roads of canton of Wallis
networkWallisSecondary = networkWallis(indWallisSecondary,:);

%% TERTIARY ROADS CANTON OF WALLIS

% Search for indices in cell array 'networkWallis' containing 'tertiary'
kWallisTertiary = strfind(networkWallis(:,5),'tertiary');

% Find the indices of non-empty cells
indWallisTertiary = find(~cellfun(@isempty,kWallisTertiary));

% Tertiary roads of canton of Wallis
networkWallisTertiary = networkWallis(indWallisTertiary,:);

%% RESIDENTIAL ROADS CANTON OF WALLIS

% Search for indices in cell array 'networkWallis' containing 'residential'
kWallisResidential = strfind(networkWallis(:,5),'residential');

% Find the indices of non-empty cells
indWallisResidential = find(~cellfun(@isempty,kWallisResidential));

% Residential roads of canton of Wallis
networkWallisResidential = networkWallis(indWallisResidential,:);



