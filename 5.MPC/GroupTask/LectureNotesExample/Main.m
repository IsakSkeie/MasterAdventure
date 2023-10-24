clc
clear
%choose prediction horizon Np
Np = 150; %Np time steps ahead in the future
%sampling time
dt = 5; %sampling time in seconds %dt = 6 seconds
%initial values of the states
Pp_init     = 4e5;%8*10^5; %Initial pressure for pump
qBit_init   = 0.025; %Initial flow rate through drill bit
Pc_init     = 5*10^5; %Initial pressure at controle choke valve
pbit_init   = 255e5; %Inital pressure for Pbit
q_res       = 0;


state_ini_values = [Pp_init, qBit_init, Pp_init, pbit_init];
%state_ini_values = [Pp_init, qBit_init, Pc_init, pbit_init, q_res];

%initial value for optimizer control
u_ini = ones(Np,2); 

u_ini(:,1)  = u_ini(:,1)* 0.025; %Initialize pump flow
u_ini(:,2) = u_ini(:,2)* 50;    %Initialize choke valve opening


%Reference
%make the reference vector offline (for the whole prediction horizon length).
Ref =   ones(Np, 1) * 250e5; %P_bit


%make the nonlinear optimization problem and solve it
u_k_ast = optimization_tank(u_ini,state_ini_values,dt,Ref,Np);
%we now have optimal values of 'u' to fulfill the objective function
%we can use the optimal values of 'u' to calculate the variables of interest
%to us.
%the ouput variables and the states are of interest. They should be
%calculated using the optimal values of 'u'. We use the model to calculate
%the output and the states.
%for storing
%storage place for the output
Pc = zeros(Np,1);
%Important note: We don't need this loop for MPC, only for NL opt. control
for i = 1:Np
%calculate the outputs: for this example, outputs are the states
%store the outputs
Pc(i,1) = state_ini_values(4);
%update the state with the optimal control inputs
%with RK method
x_next = OilWell_runge_kutta(state_ini_values,dt,u_k_ast(i,:));
state_ini_values = x_next;
end
%make time steps for plotting
tspan = linspace(0,Np-1,Np);
figure,
subplot(311)
plot(tspan,Ref,'b-',tspan,Pc,'k-')
legend('ref Pc','Pc','Orientation','horizontal')
ylabel('Pc, Ref'); title('NL optimal control of tank pressure');
subplot(312)
plot(tspan,u_k_ast(:,1),'r-')
xlabel('time [sec]'); ylabel('u');
legend('Control input: Pump speed');

subplot(313)
plot(tspan,u_k_ast(:,2),'r-')
xlabel('time [sec]'); ylabel('u');
legend('Control input: Choke Valve');