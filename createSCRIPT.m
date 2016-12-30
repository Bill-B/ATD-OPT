function createSCRIPT(FMT,flight,scriptname)
% this function creates the flight script xml directly (does not use makeXML,
% maybe one day it will).

% aileron = (pwm[0]-1500)/500.0
% elevator = (pwm[1]-1500)/500.0
% throttle = (pwm[2]-1000)/1000.0
% rudder = (pwm[3]-1500)/500.0
% set fcs/aileron-cmd-norm %s
% set fcs/elevator-cmd-norm %s
% set fcs/rudder-cmd-norm %s\n
% set fcs/throttle-cmd-norm %s\n


%     wind.speed = speed*0.01 %why does ardupilot do this?
%     wind.direction = direction*0.01
%     wind.turbulance = turbulance*0.01%
%     atmosphere/psiw-rad
%     atmosphere/wind-mag-fps

%% Get necessary data from the flight log
timeindx= (find(FMT.RCOU.TimeS>flight(1),1):1:find(FMT.RCOU.TimeS>flight(2),1));
timeS = FMT.RCOU.TimeS(timeindx);
ail = (FMT.RCOU.C1(timeindx)-1540) ./ 500;
ele = (FMT.RCOU.C2(timeindx)-1600) ./ 500;
rud = (FMT.RCOU.C4(timeindx)-1500) ./ 500;
thr = (FMT.RCOU.C3(timeindx)-982) ./ 919;

windtimeindx = (find(FMT.WIND.TimeS>flight(1),1):1:find(FMT.WIND.TimeS>flight(2),1));
windspd = FMT.WIND.SPD(windtimeindx).*3.28084;
winddir = deg2rad(FMT.WIND.DIR(windtimeindx));

%% TRIM DATA OFFSETS
ele = ele - ele(1); %elevator trim automatically moves the pitch trim
ail = ail - ail(1); %ail trim moves aileron, so we copy aileron to roll trim manually at start of flight
rud = rud - rud(1); %rud trim moves rudder, so we copy rud to yaw trim manually at start of flight

%% Initial XML stuff
docNode = com.mathworks.xml.XMLUtils.createDocument('runscript');
runscript = docNode.getDocumentElement;
runscript.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
runscript.setAttribute('xsi:noNamespaceSchemaLocation','http://jsbsim.sf.net/JSBSimScript.xsd');
runscript.setAttribute('name','GUSTAV SCRIPT');

%set aircraft and initialize xml file
use = docNode.createElement('use');
use.setAttribute('aircraft','rascal');
use.setAttribute('initialize','reset0');
runscript.appendChild(use);

%% set start and end times, step rate
run = docNode.createElement('run');
run.setAttribute('start',num2str(timeS(1)));
run.setAttribute('end',num2str(timeS(end)));
run.setAttribute('dt','0.005');
runscript.appendChild(run);

%% trim and more initial conditions (for some reason we set these here and not in the reset script...?)
% ic/alpha-deg
% ic/alpha-rad
% ic/beta-deg
% ic/beta-rad
% ic/gamma-deg
% ic/gamma-rad
% ic/h-agl-ft
% ic/h-sl-ft
% ic/lat-gc-deg
% ic/lat-gc-rad
% ic/long-gc-deg
% ic/long-gc-rad
% ic/mach
% ic/p-rad_sec
% ic/phi-deg
% ic/phi-rad
% ic/psi-true-deg
% ic/psi-true-rad
% ic/q-rad_sec
% ic/r-rad_sec
% ic/roc-fpm
% ic/roc-fps
% ic/sea-level-radius-ft
% ic/terrain-altitude-ft
% ic/theta-deg
% ic/theta-rad
% ic/u-fps
% ic/v-fps
% ic/vc-kts
% ic/vd-fps
% ic/ve-fps
% ic/ve-kts
% ic/vg-fps
% ic/vg-kts
% ic/vn-fps
% ic/vt-fps
% ic/vt-kts
% ic/vw-bx-fps
% ic/vw-by-fps
% ic/vw-bz-fps
% ic/vw-dir-deg
% ic/vw-down-fps
% ic/vw-east-fps
% ic/vw-mag-fps
% ic/vw-north-fps
% ic/w-fps
event = docNode.createElement('event'); 
event.setAttribute('name','Trim');
condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','ic/p-rad_sec');
set.setAttribute('value',num2str(FMT.IMU.GyrX(find(FMT.IMU.TimeS>flight(1),1)),9));
event.appendChild(set);

set = docNode.createElement('set');
set.setAttribute('name','ic/q-rad_sec');
set.setAttribute('value',num2str(FMT.IMU.GyrY(find(FMT.IMU.TimeS>flight(1),1)),9));
event.appendChild(set);

set = docNode.createElement('set');
set.setAttribute('name','ic/r-rad_sec');
set.setAttribute('value',num2str(FMT.IMU.GyrZ(find(FMT.IMU.TimeS>flight(1),1)),9));
event.appendChild(set);


% typedef enum { tLongitudinal=0, tFull=1, tGround=2, tPullup=3,
%                tCustom=4, tTurn=5, tNone=6 } TrimMode;
%     -0 tLongitudinal: Trim wdot with alpha, udot with thrust, qdot with elevator
%     -1 tFull: tLongitudinal + vdot with phi, pdot with aileron, rdot with rudder
%              and heading minus ground track (hmgt) with beta
%     -2 tPullup: tLongitudinal but adjust alpha to achieve load factor input
%                with SetTargetNlf()
%     -3 tGround: wdot with altitude, qdot with theta, and pdot with phi
%     -5 tTurn: tFull except vdot with beta and no heading minus ground track
%     -6 off
set = docNode.createElement('set');
set.setAttribute('name','simulation/do_simple_trim');
set.setAttribute('value','5');
event.appendChild(set);
run.appendChild(event);
 

%% SET ROLL TRIM FROM TRIMMED AIL POS
event = docNode.createElement('event');
event.setAttribute('name','Roll trim');
condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  '));
condition.appendChild(docNode.createTextNode(num2str(0)));
event.appendChild(condition);
set = docNode.createElement('set');
set.setAttribute('name','fcs/roll-trim-cmd-norm');
set.setAttribute('action','FG_STEP');
funct = docNode.createElement('function');
set.appendChild(funct);

sum = docNode.createElement('sum');
property = docNode.createElement('property');
property.appendChild(docNode.createTextNode('fcs/left-aileron-pos-norm'));
% set.setAttribute('action','FG_STEP');
% set.setAttribute('value',));
% set.setAttribute('tc','0.25');
sum.appendChild(property);
funct.appendChild(sum);
event.appendChild(set);
run.appendChild(event);
% 
% end

%% SET YAW TRIM FROM TRIMMED RUD POS
%create events with one condition and sets
event = docNode.createElement('event');
event.setAttribute('name','Yaw trim');
condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  '));
condition.appendChild(docNode.createTextNode(num2str(0)));
event.appendChild(condition);
set = docNode.createElement('set');
set.setAttribute('name','fcs/yaw-trim-cmd-norm');
set.setAttribute('action','FG_STEP');
funct = docNode.createElement('function');
set.appendChild(funct);

sum = docNode.createElement('sum');
property = docNode.createElement('property');
property.appendChild(docNode.createTextNode('fcs/rudder-pos-norm'));
% set.setAttribute('action','FG_STEP');
% set.setAttribute('value',));
% set.setAttribute('tc','0.25');
sum.appendChild(property);
funct.appendChild(sum);
event.appendChild(set);
run.appendChild(event);
% 
% end

%%  create continuous event (aileron)
event = docNode.createElement('event');
event.setAttribute('name','aileron positions');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for aileron'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','fcs/aileron-cmd-norm');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),-ail(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%%  create continuous event (elevator)
event = docNode.createElement('event');
event.setAttribute('name','elevator positions');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for elevator'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','fcs/elevator-cmd-norm');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),ele(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%%  create continuous event (rudder)
event = docNode.createElement('event');
event.setAttribute('name','rudder positions');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for rudder'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','fcs/rudder-cmd-norm');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),-rud(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%%  create continuous event (throttle)
event = docNode.createElement('event');
event.setAttribute('name','throttle positions');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for throttle'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','fcs/throttle-cmd-norm');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),thr(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%%  create continuous event (wind speed)
event = docNode.createElement('event');
event.setAttribute('name','wind speed');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for wind speed'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','atmosphere/wind-mag-fps');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),windspd(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%%  create continuous event (wind dir)
event = docNode.createElement('event');
event.setAttribute('name','wind dir');
event.setAttribute('continuous','true');
run.appendChild(event);

description= docNode.createElement('description');
description.appendChild(docNode.createTextNode('Time history for wind dir'));
event.appendChild(description);

condition= docNode.createElement('condition');
condition.appendChild(docNode.createTextNode('simulation/sim-time-sec  ge  0.0'));
event.appendChild(condition);

set = docNode.createElement('set');
set.setAttribute('name','atmosphere/psiw-rad');
set.setAttribute('action','FG_STEP');
event.appendChild(set);

funct = docNode.createElement('function');
set.appendChild(funct);

table = docNode.createElement('table');
funct.appendChild(table);

indep = docNode.createElement('independentVar');
indep.setAttribute('lookup','row');
indep.appendChild(docNode.createTextNode('simulation/sim-time-sec'));
table.appendChild(indep);

appendtext = sprintf('\n');
for n = 1:length(timeS)
    appendtext = sprintf('%s%.10f\t%.10f\n',appendtext,timeS(n),winddir(n));
end

tabledata = docNode.createElement('tableData');
tabledata.appendChild(docNode.createTextNode(appendtext));
% tabledata.appendChild(docNode.createElement('br'));
% tabledata.appendChild(docNode.createTextNode('1.2   0.2'));
table.appendChild(tabledata);

%     atmosphere/psiw-rad
%     atmosphere/wind-mag-fps
%% make XML
xmlwrite(scriptname,docNode);


