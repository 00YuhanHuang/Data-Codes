function [LMP,F,lambda] = DCOPF_lossless(mpc,ref)
% This function is for lossless LMP calculation
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
obj = Pg'* diag(a) * Pg + Pg' * b + sum(c);

%% constraints
nb = length(BUS(:,1));
D = BUS(:,PD);
Cg = sparse(GEN(on,GEN_BUS),(1:ngon)',1,nb,ngon);
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

%% LMP calculation
lambda = -dual(con(1));
mu1 = dual(con(5));
mu2 = dual(con(4));
if isnan(mu1)
    lmp_c = zeros(nb,1);
else
    lmp_c = -H'*(mu1-mu2);
end
lmp_e = lambda;
LMP = lmp_e + lmp_c;