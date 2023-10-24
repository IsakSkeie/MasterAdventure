%function [dot_Pp, dot_qbit, dot_Pc, Pbit] = oilWell_equations(U, X)
function Y = oilWell_equations(U, X)

%States
Pp = X(1);
qbit = X(2);
Pc = X(3);
Pbit = X(4);

%input
qpump = U(1);
uc = U(2);
%qpump = 0.025;
%
Y = [];


%Parameters

pl  = 1150;              %kg/m^3    Drill mud density
pw  = 1000;              %kg/m^3    Water Density
WC  = 0.1;               %          Water cut of the reservoir fluid
Ad  = 0.0067;            %m^2       Cross sectional area of drilling string
Aa  = 0.278;             %m^2       Cross sectional area of annulus
Dd  = 0.0925;            %m         Hydraulic diameter of drill string
Da  = 0.211;             %m         Hydraulic diameter of annulus
L   = 1600.0;            %m         Vertical depth of the well
PI  = 1.6667*10^(-9);    %m^5/Ns    Productivity Index Value          
Pres = 250*10^5;         %N/m^2     Reservoir pressure
Pfrac = 270*10^5;        %N/m^2     Fracture pressure
Pcoll = 220*10^5;        %N/m^2     Collapse pressure
Prefbit = 0;             %N/m^2     Reference pressure 
P0  =  4*10^5;           %N/m^2     Pressure downstream the choke valve
eDd = 10^(-5);           %Relative roughness of pipe in drill string
eDa = 10^(-4);           %Relative roughness of pipe in the annulus
ud = 0.015;              %kg/ms     Dynamic viscosity of the drill fluid
bd = 3*10^8;             %N/m^2     Bulk modulus in the drill string
ba = 2.4*10^8;           %N/m^2     Bulk modulus in the annulus
qnom = 1500;             %l/min     Nominal flow rate of the drill fluid
%uc = 70;                 %%         Nominal choke valve opening
g = 9.81;                %m/s^2     Acceleration due to gravity
fd = 0.02;               %          Friction factor




%Declare Process Variables
%deltaP_df = 0;           %N/m^2      Pressure difference due to friction drill string   
%deltaP_af = 0;           %N/m^2      Pressure difference due to friction in annulus
%Pbit = 0;                %N/m^2      Bottom hole pressure 
%qres = 0;                %m^3/s      Flow rate of reservoir fluid
qback = 0;               %m^3/s      Flow rate of Back pressure pump
%qchoke = 0;              %m^3/s      Flow rate through choke valve
 
              
pmix     = pw*WC + (1 - WC)*pl;                          %Density of fluid in annulus     !! qres = 0 then WX = 0
  
N6 = 27.3 / (3600*sqrt(10^5));
Zc = 0;                 %Valve characteristics as function of opening

if uc < 5              
    Zc = 0;
elseif (5 <= uc) && uc < 50
    Zc = 0.111*uc - 0.556;
elseif uc >= 50
     Zc = 0.5*uc - 20;
end




%Functions
 qres     = max(PI*(Pres - Pbit),0); 
 va = (qbit+qres)/( Aa); 
 deltaP_af = (fd*L*pmix*va^2)/(2*Da);
 Pbit     = Pc + pmix*g*L + deltaP_af;                    %Bottom hole pressure   
                              %Flow rate into Annulus
 vd = qpump/(Ad);                                        %Drill string velocity
                                 %Annulus velocity
 deltaP_df = (fd*L*pl*vd^2)/(2*Dd);                      %Pressure difference due to friction drill string 
  
 
 %Conditions
     
if qres == 0
     WX = 0;
end


if Pc < P0
     qchoke = 0;
else 
     qchoke   = N6*Zc*sqrt((Pc-P0)/pmix);                     %Flow rate through choke valve, Do MAX??
end



dot_L    = 0;  



%Differential equations
  
  dot_Pp   = (bd/(Ad*L))*(qpump - qbit);                   %N/m^2/s    Well head pressure change
  dot_qbit = (Ad/(pl*L))*(Pp + pl*g*L - deltaP_df - Pbit); %m^3/s      Flow rate through drill bit
  dot_Pc   = (ba/(Aa*L))*(qbit + qres + qback - qchoke);   %N/m^2/s    Change in pressure at annulus head

  

 %Conditions
if qbit <= 0 & dot_qbit < 0
    dot_qbit = 0;
    qbit = 0;
end



% Assigns Output values
Y(1) = dot_Pp;
Y(2) = dot_qbit;
Y(3) = dot_Pc;
Y(4) = Pbit;


         