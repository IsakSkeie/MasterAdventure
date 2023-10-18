clc
clear
%choose prediction horizon Np
Np = 136; %Np time steps ahead in the future
%sampling time
dt = 0.1*60; %sampling time in seconds %dt = 6 seconds
%initial values of the states
state_ini_values = 10e5; %intial pressure at the bottom of the tank
%initial value for optimizer
u_ini = ones(Np,1).*1; %the unknowns are initialized as full valve opening
%Reference
%make the reference vector offline (for the whole prediction horizon length).
Ref = [ones(Np/4,1)*10e5;ones(Np/4,1)*12e5;ones(Np/4,1)*16e5;ones(Np/4,1)*11e5];

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
Pc(i,1) = state_ini_values;
%update the state with the optimal control inputs
%with RK method
x_next = my_runge_kutta(state_ini_values,dt,u_k_ast(i));
state_ini_values = x_next;
end
%make time steps for plotting
tspan = linspace(0,Np-1,Np);
figure,
subplot(211)
plot(tspan,Ref,'b-',tspan,Pc,'k-')
legend('ref Pc','Pc','Orientation','horizontal')
ylabel('Pc, Ref'); title('NL optimal control of tank pressure');
subplot(212)
plot(tspan,u_k_ast,'r-')
xlabel('time [sec]'); ylabel('u');
legend('Control input: valve opening');