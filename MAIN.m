clc
clear

%% load flight settings and set time interval
setup();


%% setup and run optimization
lb = [...
      19.9 -0.1 -0.8 -4 -40 -7
    ];

ub = [...
      25 0 -0.3 -0.5 -8 -3
    ];


A = [];

b = [];

Aeq = [];
beq = [];

nvars = 6;
TolCon_Data = 1e-6; 
TolFun_Data = 1e-08;
% lastrun = load('run1.mat');
options = gaoptimset;
options = gaoptimset(options,'TolFun', TolFun_Data);
% options = gaoptimset(options,'CrossoverFraction', 0.5);
options = gaoptimset(options,'Display', 'iter');
% options = gaoptimset(options,'InitialPopulation', lastrun.population);
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv @gaplotexpectation @gaplotscorediversity @gaplotstopping });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 0 );
options = gaoptimset(options,'Generations',200,'StallGenLimit', 50);
[x,fval,exitflag,output,population,score] = ga(@ATD,nvars,A,b,Aeq,beq,lb,ub,[],options);
