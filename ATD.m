% Automatic test driver (ATD)
% Set all file locations in setup.m
% This will overwrite the Rascal aircraft in the jsbsim directory

%TODO
%Init PQR? Init Pdot Qdot Rdot? Init UVW? Udot Vdot Wdot?
%init VN VE VD?
%wind Z?
%init density/temp?
%script offset rc from trim pos
%jsbsim fix
function error= ATD(vari)
global flight jsbsimlocation INFO FMT theStruct %I know...
cdir = pwd;
if nargin==0 %     if run without inputs, the ATD is running outside an optimizer.    
    vari = [21.6620279712671,0.32,4.6028,0.3,-0.0946685988055871,-0.310113997503891,-0.718592684747903,-18.8692934326798,-3.14943689122259];
    setup(); %run setup if this is run standalone
    tic %start timing after loading 
end

% Flight data is a global variable set in the MAIN.m

mod.AERORPX = vari(1);
mod.CLo = vari(2);
mod.CLa = vari(3);
mod.CLde = vari(4);
% mod.Clb = vari(2);
% mod.Clp = vari(3);
% mod.Clr = vari(4);
% mod.Clda = vari(5);
% mod.Cldr = vari(6);
mod.Cmo = vari(5);
mod.Cmalpha = vari(6);
mod.Cmde = vari(7);
mod.Cmq = vari(8);
mod.Cmadot = vari(9);
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

% [data1,data2]=system('JSBSim.exe --script=./scripts/gustav1.xml  ') %slow
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