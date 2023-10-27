%function [dPc_dt, dPp_dt, dqbit_dt, P_bit, Pcoll, Pfrac, DeltaP_f_d, q_res] = OilWell(u_c, q_back, q_pump, Pc, Pp, q_bit, q_res_last)
function Y = TBsOilWellEq(U, X)
%For å gjøre ending for å sjekke om GIT funker
%States
Pp = X(1);
q_bit = X(2);
Pc = X(3);
q_res_prev = X(5);

%input
q_pump = U(1);
u_c = U(2);
%qpump = 0.025;
%
Y = [];

%Density
rho_l = 1150;
rho_water = 1000;

%Others
WC = 0.1;
PI = 1.6667*10^-9;
Betta_d = 3*10^8;
Betta_a = 2.4*10^8;
g = 9.81;
f_d = 0.02;
q_back = 0;

%Area
Ad = 0.0067;
Aa = 0.278;

%Hight
Dd = 0.0925;
Da = 0.211;
L = 1600;

%Pressure
Pres = 250*10^5;
Pfrac = 270*10^5;
Pcoll = 220*10^5;
Pbit_ref = 215*10^5;
P0 = 4*10^5;

%Equations:
rho_mix = rho_water*WC + (1-WC)*rho_l;

%v = q_bit/Aa;

DeltaP_f_a = (f_d*L*rho_mix*((q_bit+q_res_prev)/Aa)^2)/(2*Da);
DeltaP_f_d = (f_d*L*rho_l*(q_pump/Ad)^2)/(2*Dd);


P_bit = Pc + rho_mix*g*L + DeltaP_f_a;



q_res = max(PI*(Pres-P_bit),0);

N6 = 27.3/(3600*sqrt(10^5));

if u_c < 5  
    Z_c = 0;
elseif u_c >= 5 && u_c < 50
    Z_c = 0.111*u_c-0.557;
else
    Z_c = 0.5*u_c-20;
end

q_choke = N6*Z_c*sqrt(max((Pc-P0),0)/rho_mix);

%differential equatios
dPp_dt = Betta_d/(Ad*L) * (q_pump - q_bit); 

dqbit_dt = (Ad/(rho_l*L) * (Pp + rho_l*g*L - DeltaP_f_d - P_bit));

if q_bit <= 0 && dqbit_dt < 0
    q_bit = 0;
    dqbit_dt = 0;
end

dPc_dt = Betta_a/(Aa*L) * (q_bit + q_res + q_back - q_choke);


% Assigns Output values
Y(1) = dPp_dt;
Y(2) = dqbit_dt;
Y(3) = dPc_dt;
Y(4) = P_bit;
Y(5) = q_res;







