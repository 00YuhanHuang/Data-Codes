function mpc = case7
%% MATPOWER Case Format : Version 2
mpc.version = '2';
%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;
%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
    1	1	0	    0	0	0	1	1	0	230	1	1.1	0.9;
	2	1	0   	0	0	0	1	1	0	230	1	1.1	0.9;
    3	3	1500	0	0	0	1	1	0	230	1	1.1	0.9;
    4	1	1000	0	0	0	1	1	0	230	1	1.1	0.9;
    5	1	0	    0	0	0	1	1	0	230	1	1.1	0.9;
	6	1	0	    0	0	0	1	1	0	230	1	1.1	0.9;
	7	1	500	    0	0	0	1	1	0	230	1	1.1	0.9;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	800	    0	100	-100	1	100	1	800	    0	0	0	0	0	0	0	0	0	0	0	0;
    2	1000   	0	100	-100	1	100	1	2000	0	0	0	0	0	0	0	0	0	0	0	0;
    5	1500	0	100	-100	1	100	1	2000    0	0	0	0	0	0	0	0	0	0	0	0;
    6	200	    0	100	-100	1	100	1	1500	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.0020	0.0020	0.0775	500     250	250	0	0	1	-360	360;
    1	3	0.0020	0.0020	0.0775	1000    250	250	0	0	1	-360	360;
	2	3	0.0020	0.0020	0.1275	1000 	250	250	0	0	1	-360	360;
    3	4	0.0020	0.0010	0.1025	200 	250	250	0	0	1	-360	360;
    4	5	0.0020	0.0020	0.0775	1000 	250	250	0	0	1	-360	360;
	4	6	0.0020	0.0020	0.1275	1500 	250	250	0	0	1	-360	360;
    5	7	0.0020	0.0020	0.0775	550     250	250	0	0	1	-360	360;
	6	7	0.0020	0.0020	0.1025	2000 	250	250	0	0	1	-360	360;
];

%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
    2	0	0	2   20  0;
    2	0	0	2   80  0;
    2	0	0	2   40  0;
	2	0	0	2   60  0;
];