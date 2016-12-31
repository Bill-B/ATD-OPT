function [ error ] = errors(  FMT,flight,SIM )
imutime_idx = find(FMT.IMU.TimeS>flight(1),1):1:find(FMT.IMU.TimeS>flight(2),1);
NKF1time_idx = find(FMT.NKF1.TimeS>flight(1),1):1:find(FMT.NKF1.TimeS>flight(2),1);
%subtract the two functions, then trapz(x,abs(y))
vu = interp1(SIM.data(:,1),SIM.data(:,24),FMT.NKF1.TimeS(NKF1time_idx)-0.1,'linear','extrap');
diffu = vu./3.28084-FMT.NKF1.U(NKF1time_idx); %m/s
erroru = trapz(FMT.NKF1.TimeS(NKF1time_idx)-0.1,abs(diffu));

vv = interp1(SIM.data(:,1),SIM.data(:,25),FMT.NKF1.TimeS(NKF1time_idx)-0.1,'linear','extrap');
diffv = vv./3.28084-FMT.NKF1.V(NKF1time_idx); %m/s
errorv = trapz(FMT.NKF1.TimeS(NKF1time_idx)-0.1,abs(diffv));

vw = interp1(SIM.data(:,1),SIM.data(:,26),FMT.NKF1.TimeS(NKF1time_idx)-0.1,'linear','extrap');
diffw = vw./3.28084-FMT.NKF1.W(NKF1time_idx); %m/s
errorw = trapz(FMT.NKF1.TimeS(NKF1time_idx)-0.1,abs(diffw));


vp= interp1(SIM.data(:,1),SIM.data(:,11),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffp = vp-FMT.IMU.GyrX(imutime_idx)*57.2958; %deg/s
errorp = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffp));

vq=interp1(SIM.data(:,1),SIM.data(:,12),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffq = vq-FMT.IMU.GyrY(imutime_idx)*57.2958;  %deg/s
errorq = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffq));

vr= interp1(SIM.data(:,1),SIM.data(:,13),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffr = vr-FMT.IMU.GyrZ(imutime_idx)*57.2958; %deg/s
errorr = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffr)); 

% error = errorp+errorq+errorr;
error = errorq+errorw;
end
