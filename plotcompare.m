function [  ] = plotcompare(FMT,flight ,SIM  )

%% ROLL

fig=figure(1);
clf(1);

fig.Name = 'Roll Data';
s1 = subplot(4,1,1);

hold on
% yyaxis left
ylabel('Roll Rate P (deg/s)')
plot(FMT.IMU.TimeS-0.1,FMT.IMU.GyrX*57.2958)
% yyaxis right
plot(SIM.data(:,1),SIM.data(:,11))
grid on
box on

s2 = subplot(4,1,2);
hold on
ylabel('Roll Angle Phi (deg)')
plot(FMT.ATT.TimeS,FMT.ATT.Roll)
plot(SIM.data(:,1),SIM.data(:,104));
grid on
box on

s3 = subplot(4,1,3);
hold on
ylabel('AIL Norm')

plot(FMT.RCOU.TimeS,(FMT.RCOU.C1-1540)./500);
plot(SIM.data(:,1),SIM.data(:,150));
% toc

xlim([SIM.data(1,1),SIM.data(end,1)]);
grid on
box on

s4 = subplot(4,1,4);
hold on
ylabel('L AIL Deg')

plot(FMT.RCOU.TimeS,(FMT.RCOU.C1-1540)./-16.436);
plot(SIM.data(:,1),SIM.data(:,6));
% toc


grid on
box on
linkaxes([s1,s2,s3,s4],'x');
xlim([SIM.data(1,1),SIM.data(end,1)]);
%% PITCH

fig2=figure(2);
clf(2)

fig2.Name = 'Pitching Data';
s1 = subplot(4,1,1);

hold on
% yyaxis left
ylabel('Pitch Rate Q (deg/s)')
plot(FMT.IMU.TimeS-0.1,FMT.IMU.GyrY*57.2958)
% yyaxis right
plot(SIM.data(:,1),SIM.data(:,12))
grid on
box on

s2 = subplot(4,1,2);
hold on
ylabel('Pitch Angle Theta (deg)')
plot(FMT.ATT.TimeS,FMT.ATT.Pitch)
plot(SIM.data(:,1),SIM.data(:,105));
grid on
box on

s3 = subplot(4,1,3);
hold on
ylabel('ELE Norm')

plot(FMT.RCOU.TimeS,(FMT.RCOU.C2-1600)./500);
plot(SIM.data(:,1),SIM.data(:,143));
% toc
xlim([SIM.data(1,1),SIM.data(end,1)]);
grid on
box on

s4 = subplot(4,1,4);
hold on
ylabel('ELE Deg')

plot(FMT.RCOU.TimeS,(FMT.RCOU.C2-1600)./18.242);
plot(SIM.data(:,1),SIM.data(:,8));
% toc
linkaxes([s1,s2,s3,s4],'x');
xlim([SIM.data(1,1),SIM.data(end,1)]);
grid on
box on
%% YAW

fig3=figure(3);
clf(3)

fig3.Name = 'Yaw Data';
s1 = subplot(3,1,1);

hold on
% yyaxis left
ylabel('Yaw Rate R (deg/s)')
plot(FMT.IMU.TimeS-0.1,FMT.IMU.GyrY*57.2958)
% yyaxis right
 plot(SIM.data(:,1),SIM.data(:,13))
grid on
box on

 s2 = subplot(3,1,2);
 hold on
 ylabel('Yaw Angle Psi (deg)');
 plot(FMT.ATT.TimeS,FMT.ATT.Yaw);
 plot(SIM.data(:,1),SIM.data(:,106));
 grid on
 box on
 s3 = subplot(3,1,3);
 hold on
 ylabel('RUD Norm')

plot(FMT.RCOU.TimeS,(FMT.RCOU.C4-1500)./500);
 plot(SIM.data(:,1),SIM.data(:,154));
% toc
linkaxes([s1,s2,s3],'x');
xlim([SIM.data(1,1),SIM.data(end,1)]);
grid on
box on

fig4=figure(4);
clf(4)

fig4.Name = 'Velocity Data';
s1=subplot(4,1,1);
hold on
ylabel('ROC m/s')
plot(FMT.GPS.TimeS,-FMT.GPS.VZ)
plot(SIM.data(:,1),-SIM.data(:,35)./3.28084);
grid on
box on

s2 = subplot(4,1,2);
hold on
ylabel('U Body (m/s)')
plot(FMT.NKF1.TimeS,FMT.NKF1.U);
plot(SIM.data(:,1),SIM.data(:,24)./3.28084);
grid on
box on

s3 = subplot(4,1,3);
hold on
ylabel('V Body (m/s)');
plot(FMT.NKF1.TimeS,FMT.NKF1.V);
plot(SIM.data(:,1),SIM.data(:,25)./3.28084);
grid on
box on

s4 = subplot(4,1,4);
hold on
ylabel('W Body (m/s)');
plot(FMT.NKF1.TimeS,FMT.NKF1.W);
plot(SIM.data(:,1),SIM.data(:,26)./3.28084);
grid on
box on

linkaxes([s1,s2,s3,s4],'x');
xlim([SIM.data(1,1),SIM.data(end,1)]);


% fig5=figure(5);
% clf(5)
% hold on
% plot(FMT.RCOU.TimeS,(FMT.RCOU.C3-982)./919) 
% plot(SIM.data(:,1),SIM.data(:,206));
% xlim([SIM.data(1,1),SIM.data(end,1)]);
% grid on
% box on
end

