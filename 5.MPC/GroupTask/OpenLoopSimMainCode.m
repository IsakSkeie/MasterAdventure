%the main file to be run

clc
clear

%start time
tstart = 0;
tend = 80*60; %in sec
%sampling time
dt = 0.1*60; %sampling time in seconds %dt = 6 seconds
%time span
tspan = tstart:dt:tend;
%length of the sliding loop: how many times to slide
looplen = length(tspan);

%Initial values
P_c = 4*10^5;
P_p = 4*10^5;
q_bit = 0.025;


%make space for storing variables of interest
P_bit = zeros(looplen,1);
P_frac = zeros(looplen,1);
P_coll = zeros(looplen,1);
u = zeros(looplen,1)+70;
Qpump = zeros(looplen,1);
elapsed_time = zeros(looplen,1);

P_min = 220;
p_max = 270;
Q_pump_SS = 0.025;

%make a loop for sliding each time step forward
for i = 1:looplen
    tic
      
    
    %store the output
    %if output is not the states, make a separate .m file for calculating
    %it.
    Pc(i,1) = state_ini_values;
    
    %call the optimizer
    %make the nonlinear optimization problem and solve it
    u_k_ast = optimization_tank(u_ini,state_ini_values,dt,Ref(i:i+Np-1,1),Np,i);
    
    %use only the first control move
    u_first = u_k_ast(1);
    %store the optimal control input
    u(i,1) = u_first;
    
   
    %for warm start
    u_ini = u_k_ast;
    
    %use the first control move to slide one time step forward
    %with RK method
    [x_next, Qin] = my_runge_kutta(state_ini_values,dt,u_first,Ref(i:i+Np-1,1),i);
    state_ini_values = x_next;
    
%         %store the output
%     %if output is not the states, make a separate .m file for calculating
%     %it.
%     Pc(i,1) = state_ini_values;

      Qpump(i,1) = Qin;

elapsed_time(i,1) = toc;
end

tspan = tspan./60; %to plot in minutes as time axis
%plot figures,
figure,
subplot(311)
plot(tspan,Ref(1:looplen,1),'b-',tspan,Pc,'k-')
legend('ref Pc','Pc','Orientation','horizontal')
ylabel('Pc, Ref'); title('MPC for tank pressure');
subplot(312)
plot(tspan,u,'r-')
xlabel('time [min]'); ylabel('u');
legend('Control input: valve opening');
subplot(313)
plot(tspan,Qpump,'b-')
xlabel('time [min]'); ylabel('Flow in');
legend('Uncontrolled pump: flow in');


%figure,
%plot(tspan,elapsed_time);
%xlabel('time[min]'); ylabel('execution time [s]');
%title('Execution time for nonlinear MPC');
%legend('without grouping');
