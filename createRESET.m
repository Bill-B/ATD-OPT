function createRESET(FMT,flight,resetname)

% These are the items that can be set in an initialization file:
% 
%    - ubody (velocity, ft/sec)
%    - vbody (velocity, ft/sec)
%    - wbody (velocity, ft/sec)
%    - vnorth (velocity, ft/sec)
%    - veast (velocity, ft/sec)
%    - vdown (velocity, ft/sec)
%    - latitude (position, degrees)
%    - longitude (position, degrees)
%    - phi (orientation, degrees)
%    - theta (orientation, degrees)
%    - psi (orientation, degrees)
%    - alpha (angle, degrees)
%    - beta (angle, degree

%    - gamma (angle, degrees)
%    - roc (vertical velocity, ft/sec)
%    - elevation (local terrain elevation, ft)
%    - altitude (altitude AGL, ft)
%    - altitudeAGL (altitude AGL, ft)
%    - altitudeMSL (altitude MSL, ft)
%    - winddir (wind from-angle, degrees)
%    - vwind (magnitude wind speed, ft/sec)
%    - hwind (headwind speed, knots)
%    - xwind (crosswind speed, knots)
%    - vc (calibrated airspeed, ft/sec)
%    - mach (mach)
%    - vground (ground speed, ft/sec)
%    - running (0 or 1)

  
docNode = com.mathworks.xml.XMLUtils.createDocument('initialize');
initialize = docNode.getDocumentElement;
initialize.setAttribute('name','Start up location');

value = [FMT.GPS.Lat(find(FMT.GPS.TimeS>flight(1),1)),...
    FMT.GPS.Lng(find(FMT.GPS.TimeS>flight(1),1)),...
    FMT.GPS.Alt(find(FMT.GPS.TimeS>flight(1),1))*3.28084,...
    FMT.ARSP.Airspeed(find(FMT.ARSP.TimeS>flight(1),1))*3.28084,...
    FMT.ATT.Roll(find(FMT.ATT.TimeS>flight(1),1)),...
    FMT.ATT.Pitch(find(FMT.ATT.TimeS>flight(1),1)),...
    FMT.ATT.Yaw(find(FMT.ATT.TimeS>flight(1),1)),...
    -FMT.GPS.VZ(find(FMT.GPS.TimeS>flight(1),1))*3.28084,...
    FMT.WIND.SPD(find(FMT.WIND.TimeS>flight(1),1))*3.28084,...
    FMT.WIND.DIR(find(FMT.WIND.TimeS>flight(1),1)),...
    FMT.NKF1.VN(find(FMT.NKF1.TimeS>flight(1),1))*3.28084,...
    FMT.NKF1.VE(find(FMT.NKF1.TimeS>flight(1),1))*3.28084,...
    FMT.NKF1.VD(find(FMT.NKF1.TimeS>flight(1),1))*3.28084];

params = {'latitude','longitude','altitude','vt','phi','theta','psi','roc','vwind','winddir','vnorth','veast','vdown'};
units = {'DEG','DEG','FT','FT/SEC','DEG','DEG','DEG','FT/SEC','FT/SEC','DEG','FT/SEC','FT/SEC','FT/SEC'};
for idx = 1:numel(params)
    curnode = docNode.createElement(params{idx});
    curnode.setAttribute('unit',units{idx});
    curnode.appendChild(docNode.createTextNode(num2str(value(idx),9)));
    initialize.appendChild(curnode);
end

xmlwrite(resetname,docNode);

end

