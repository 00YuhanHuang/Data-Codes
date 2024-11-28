function [LMP,F,LF,tao] = DCOPF_lossy(mpc,ref)
% This function is for lossy LMP calculation
if nargin < 2
    ref = 0; % distributed slack bus
    if nargin < 1
        mpc = 'case9';
    end
end
[BASEMVA, BUS, GEN, BRANCH, GENCOST] = loadcase(mpc);
define_constants;

%% objective function
on = find(GEN(:,GEN_STATUS)>0);
if GENCOST(1,4) == 3
    a = GENCOST(on,5);
    b = GENCOST(on,6);
    c = GENCOST(on,7);
else
    a = zeros(length(on),1);
    b = GENCOST(on,5);
    c = GENCOST(on,6);
end
ngon = length(on);
Pg = sdpvar(ngon,1);
Loss = sdpvar(1,1);
obj = Pg'* diag(a) * Pg + Pg' * b + sum(c);

%% constraints
nb = length(BUS(:,1));
D = BUS(:,PD);
Cg = sparse(GEN(on,GEN_BUS),(1:ngon)',1,nb,ngon);
R = diag(BRANCH(:,BR_R));
if ref == 0
    W = D/sum(D);
else
    W = zeros(nb,1);
    W(ref) = 1;
end
H = makePTDF(BASEMVA, BUS, BRANCH,W);

con = [sum(Pg) == sum(D)];
con = con + [Pg <= GEN(on,PMAX)];
con = con + [GEN(on,PMIN) <= Pg];
con = con + [-BRANCH(:,RATE_A) <= H*(Cg*Pg-D)];
con = con + [H*(Cg*Pg-D) <= BRANCH(:,RATE_A)];

%% solving DCOPF
ses = sdpsettings('solver','gurobi+','savesolveroutput',1,'verbose',3,'debug',1);
optimize(con,obj,ses);
F = H*(Cg*double(Pg)-D);
Ploss = F'*R*F/BASEMVA;
LF = 2*H'*R*F/BASEMVA;
offset = Ploss-LF'*double((Cg*Pg-D));
P_unb = sum(double(Pg))-sum(D)-Ploss;
ind = abs(P_unb);
% recursive process
while ind >= 1e-10
    Ploss0 = Ploss;
    con1 = [sum(Pg)==sum(D)+Loss];
    con1 = con1 + [Pg <= GEN(on,PMAX)];
    con1 = con1 + [GEN(on,PMIN) <= Pg];
    con1 = con1 + [-BRANCH(:,RATE_A) <= H*(Cg*Pg-D-W*Loss)];
    con1 = con1 + [H*(Cg*Pg-D-W*Loss) <= BRANCH(:,RATE_A)];
    con1 = con1 + [Loss == LF'*(Cg*Pg-D)+offset];
    optimize(con1,obj,ses);
    % update results
    F = H*double((Cg*Pg-D-W*Loss));
    Ploss = F'*R*F/BASEMVA;
    LF = 2*H'*R*F/BASEMVA;
    offset = Ploss - LF'*double((Cg*Pg-D));
    ind = abs(Ploss-Ploss0);
end

%% LMP calulation
tao = -dual(con1(6));
mu1 = dual(con1(5));
mu2 = dual(con1(4));
if isnan(mu1)
    lmp_c = zeros(nb,1);
else
    lmp_c = -H'*(mu1-mu2);
end
lmp_e = tao;
lmp_l = -2*tao*H'*R*F/BASEMVA;
LMP = lmp_e + lmp_c + lmp_l;