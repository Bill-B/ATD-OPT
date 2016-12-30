function theStruct = modifyAC(theStruct,mod)
%% Metrics

theStruct.Children(7).Children(16).Children(2).Children.Data = ...
    sprintf('%3f',mod.AERORPX);


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