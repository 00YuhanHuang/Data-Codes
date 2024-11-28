%% Basic parameter setting
% If ISLOSS equals to zero, the network loss is neglected.
% If ISLOSS equals to one, the network loss is included.
ISLOSS = 0;

%% Data input
define_constants;
mpc = loadcase('case7');

%% Scenario 1/Scenario 1-L
mpc_S1 = mpc;
if ISLOSS == 0
    [LMP_S1,F_S1,tao_S1] = DCOPF_lossless(mpc_S1);
elseif ISLOSS == 1
    [LMP_S1,F_S1,LF_S1,tao_S1] = DCOPF_lossy(mpc_S1);
end

%% Scenario 2/Scenario 2-L
mpc_S2 = mpc;
mpc_S2.bus(3,PD) = 700;
if ISLOSS == 0
    [LMP_S2,F_S2,tao_S2] = DCOPF_lossless(mpc_S2);
elseif ISLOSS == 1
    [LMP_S2,F_S2,LF_S2,tao_S2] = DCOPF_lossy(mpc_S2);
end

%% Scenario 3/Scenario 3-L/Scenario 3'/Scenario 3'-L
mpc_S3 = mpc;
mpc_S3.gencost(2,5) = -20;
mpc_S3.gencost(3,5) = -40;
mpc_S3.branch(end,RATE_A) = 40;
% In Scenario 3'/Scenario 3'-L, 
if ISLOSS == 0
    [LMP_S3,F_S3,tao_S3] = DCOPF_lossless(mpc_S3,3);
elseif ISLOSS == 1
    [LMP_S3,F_S3,LF_S3,tao_S3] = DCOPF_lossy(mpc_S3,3);
end
