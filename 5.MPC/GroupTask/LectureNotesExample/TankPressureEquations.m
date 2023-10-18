function dP_dt = tankPressure_equations(t,x0,u)
%this is the function where we write the differential equations of the
%given model.
%needed parameters
Cf = 2.04e-4;
Rf = 1e6;
Qin = 1; %constant inflow
Kv = 1.5; %gain of the valve
dP_dt = Qin/Cf - (x0*u*Kv)/(Rf*Cf);