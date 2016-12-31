% Automatic test driver (ATD)
% Set all file locations in setup.m
% This will overwrite the Rascal aircraft in the jsbsim directory

%TODO
%Init PQR? Init Pdot Qdot Rdot? Init UVW? Udot Vdot Wdot?
%init VN VE VD?
%init density/temp?
%script offset rc from trim pos

function error= ATD(vari)
global flight jsbsimlocation INFO FMT theStruct %I know...
cdir = pwd;
if nargin==0 %     if run without inputs, the ATD is running outside an optimizer.    
    vari = [24.4399755874371,-0.00202516216439148,-0.723171641204347,-2.06698030461429,-38.5824200922958,-3.69802056118875];
    setup(); %run setup if this is run standalone
    tic %start timing after loading 
end

% Flight data is a global variable set in the MAIN.m
mod.AERORPX = vari(1);
% mod.Clb = vari(2);
% mod.Clp = vari(3);
% mod.Clr = vari(4);
% mod.Clda = vari(5);
% mod.Cldr = vari(6);
mod.Cmo = vari(2);
mod.Cmalpha = vari(3);
mod.Cmde = vari(4);
mod.Cmq = vari(5);
mod.Cmadot = vari(6);
% mod.Cnb = vari(12);
% mod.Cnr = vari(13);
% mod.Cndr = vari(14);
% mod.Cnda = vari(15);
% mod.Cndi = vari(16);

%% modify aircraft file

%modify rascal parameter structure
theStruct = modifyAC(theStruct,mod);

%print back to rascal.xml
makeXML(theStruct,strcat(jsbsimlocation,'\aircraft\Rascal\rascal.xml'));
% copyfile('rascal.xml','C:\cygwin\home\Bill\jsbsim\aircraft\Rascal') ;
% delete('rascal.xml');


%% run JSBSim with args
%delete JSBSim output
cd(jsbsimlocation);
delete('gustavoutput.csv');

% [data1,data2]=system('JSBSim.exe --script=./scripts/gustav1.xml & ') %slow
dos('start /W /MIN JSBSim.exe --script=./scripts/gustav1.xml'); %faster
% !TASKKILL /F /IM JSBSim.exe /T

%% open jsbsim output
SIM=importdata('gustavoutput.csv',',',1);
cd(cdir);

%% plot
% plotcompare( FMT,flight,SIM );

%% errors
error=errors(FMT,flight,SIM);

if nargin==0 %if the ATD is run standalone, display time
    toc
end