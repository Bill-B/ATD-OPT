function theStruct = modifyAC(theStruct,mod)
%% Metrics

theStruct.Children(7).Children(16).Children(2).Children.Data = ...
    sprintf('%3f',mod.AERORPX);

%% LIFT
% CLalpha
%generate table
alpharad = [-0.2618, 0, 0.244];
CL = mod.CLo +( mod.CLa .* alpharad );

alpharad(4:5) = [0.25 1]; %stall model for now
CL(4:5) = [0.7 0.7];

appendtext = sprintf('\n');
for n = 1:length(alpharad)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,alpharad(n),CL(n));
end

theStruct.Children(17).Children(6).Children(2).Children(4).Children(6).Children(4).Children.Data = appendtext; 

% CLde

theStruct.Children(17).Children(6).Children(4).Children(4).Children(8).Children.Data =...
    sprintf('%3f',mod.CLde); 

%% Pitch
% Cmo

theStruct.Children(17).Children(10).Children(2).Children(4).Children(8).Children(2).Children.Data = ...
  sprintf('%3f',mod.Cmo);  

% Cmalpha

theStruct.Children(17).Children(10).Children(2).Children(4).Children(8).Children(4).Children(4).Children.Data = ...
    sprintf('%3f',mod.Cmalpha);

%Cmde
theStruct.Children(17).Children(10).Children(4).Children(4).Children(10).Children(4).Children(1).Data= ...
    sprintf('\n0.000\t%3f\n2.000\t-0.2750\n',mod.Cmde);

%Cmq
theStruct.Children(17).Children(10).Children(6).Children(4).Children(12).Children.Data = ...
    sprintf('%3f',mod.Cmq);

% Cmadot
theStruct.Children(17).Children(10).Children(8).Children(4).Children(12).Children.Data = ...
    sprintf('%3f',mod.Cmadot);