function [ error ] = errors(  FMT,flight,SIM )
imutime_idx = find(FMT.IMU.TimeS>flight(1),1):1:find(FMT.IMU.TimeS>flight(2),1);

%subtract the two functions, then trapz(x,abs(y))
vp= interp1(SIM.data(:,1),SIM.data(:,11),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffp = vp-FMT.IMU.GyrX(imutime_idx)*57.2958;
errorp = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffp));

vq=interp1(SIM.data(:,1),SIM.data(:,12),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffq = vq-FMT.IMU.GyrY(imutime_idx)*57.2958;
errorq = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffq));

vr= interp1(SIM.data(:,1),SIM.data(:,13),FMT.IMU.TimeS(imutime_idx)-0.1,'linear','extrap');
diffr = vr-FMT.IMU.GyrZ(imutime_idx)*57.2958;
errorr = trapz(FMT.IMU.TimeS(imutime_idx)-0.1,abs(diffr));

% error = errorp+errorq+errorr;
error = errorq;
end
