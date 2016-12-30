function [jsbsimlocation]= setup()
global flight jsbsimlocation INFO FMT theStruct
cdir = pwd;

%% USER SPECIFIC INFORMATION
% flight directory
basefolder = 'C:\Users\Bill\Documents\ryEng\MASc\alton\GustAV\2016-12-03';
flightnumber = 2;

%location of fcnFMTLOAD
loadlocation = 'C:\Users\Bill\Documents\ryEng\MASc\alton\GustAV';

%location of jsbsim
jsbsimlocation = 'C:\cygwin\home\Bill\jsbsim';

%specify timeS of flight to analyze [start end]
flight = [1055 1058];

%% LOAD FILES
cd(loadlocation);

% find all files in subdirectories with specific extensions
% subfolders
pixhawkpath = sprintf('%s/Pixhawk',basefolder);
pixhawkfiles = fcnFILELIST(pixhawkpath,'.mat');

% Load all files and format
% SETUP
INFO.timezone = -4;

% pixhawk output
[INFO, FMT] = fcnFMTLOAD(INFO,pixhawkpath,pixhawkfiles(flightnumber));
evalc('[INFO]=fcnGETINFO( INFO, FMT )');
cd(cdir)


%% create inital condition script

createRESET(FMT,flight,strcat(jsbsimlocation,'\aircraft\Rascal\reset0.xml'));
%copy to aircraft directory
% copyfile('reset0.xml','C:\cygwin\home\Bill\jsbsim\aircraft\Rascal')
% delete('reset0.xml')
% cd(cdir);

%% create test script
createSCRIPT(FMT,flight,strcat(jsbsimlocation,'\scripts\gustav1.xml'));
% copyfile('gustav1.xml','C:\cygwin\home\Bill\jsbsim\scripts');
% delete('gustav1.xml');
% cd(cdir);

%% load aircraft file

%load rascal.xml into a structure
[tree,theStruct]=parseXML(strcat(jsbsimlocation,'\aircraft\Rascal\rascal.xml')); %slow