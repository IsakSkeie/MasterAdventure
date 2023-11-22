clc
clear
%Simulation time;
start = 0;
stop = 2000;
%sampling time
dt = 6; %sampling time in seconds %dt = 6 seconds
Tlengt = ceil((stop-start)/dt);
tspan = linspace(start, stop, Tlengt);

%choose prediction horizon Np
Np = 20; %Np time steps ahead in the future


%initial values of the states

q_res       = 0;


Pp_init     = 7.2e6;%8*10^5; %Initial pressure for pump
qBit_init   = 0.0; %Initial flow rate through drill bit
Pc_init     = 7.2e6; %Initial pressure at controle choke valve
pbit_init   = 248e5; %Inital pressure for Pbit
q_pump_init = 0.0; %Initialize pump flow


state_ini_values = [Pp_init, qBit_init, Pp_init, pbit_init, q_pump_init];
%state_ini_values = [Pp_init, qBit_init, Pc_init, pbit_init, q_res];

%initial value for optimizer control
u_ini = ones(Np,2); 

u_ini(:,1)  = u_ini(:,1)* 0.025; %Initialize pump flow
u_ini(:,2) = u_ini(:,2)* 70;    %Initialize choke valve opening


%Reference
%make the reference vector offline (for the whole prediction horizon length).
Ref =   ones(Tlengt+Np, 1) * 250e5; %P_bit
Refp = zeros(Tlengt, 1);
RefMPC = zeros(Np, 1);

Pc = zeros(Tlengt,1);
u_valve = zeros(Tlengt,1);
u_pump = zeros(Tlengt,1);

timePsample = zeros(Tlengt,1);

qpump = ones(Tlengt+Np,1)*0.025;
pipeConnections = ones(Np, 1);
qpump(1) = 0;
for i=1:Tlengt
     if(i*dt>=dt*2 && i*dt < 500)
          qpump(i) = min(qpump(i-1) + 0.000333,0.025);
     elseif (i*dt>=1000 && i*dt < 1000+10*60)
        qpump(i) = max(qpump(i-1) - 0.000333,0);
     elseif(i*dt >= 1000+10*60 && i*dt< 1000+15*60)
         qpump(i) = min(qpump(i-1) + 0.000333,0.025);
     end
end

for i=1:Tlengt

    %Setting timesteps for when pipe connection is active
    

    %Setting the horizon Refference
    for j=1:Np
        RefMPC(j) = Ref(i+j);
        
       
        if qpump(j+i) == 0.025 
            pipeConnections(j) = 0;
        else 
            pipeConnections(j) = 1;
        end
    end
    
      

    state_ini_values(5) = qpump(i);

    tic
    %make the nonlinear optimization problem and solve it
    %u_k_ast = ones(Np, 2);
    %u_k_ast(:,2) = 70;
    u_k_ast = optimization_tank(u_ini,state_ini_values,dt,RefMPC,Np, pipeConnections);
    u = u_k_ast(1,:);
    timePsample(i) = toc;
    
    x_next = OilWell_runge_kutta(state_ini_values,dt,u);
    
    state_ini_values = x_next;
    u_ini = u_k_ast;

    %storing of values for plotting
    u_pump(i) = u(1);
    u_valve(i) = u(2);
    Pc(i,1) = x_next(4);
    Refp(i,1) = RefMPC(1);
    i
end


%u_pump = u_pump*60000;
%qpump = qpump*60000;

%plotting
figure,
subplot(411)
plot(tspan,Refp,'b-',tspan,Pc,'k-')
legend('ref Pc','Pc','Orientation','horizontal')
ylabel('Pc, Ref'); title('NL optimal control of tank pressure');

subplot(412)
plot(tspan,u_pump,'r-')
xlabel('time [sec]'); ylabel('u [l/min]');
legend('Control input: Pump speed');

subplot(413)
plot(tspan,u_valve,'r-')
xlabel('time [sec]'); ylabel('u [%]');
legend('Control input: Choke Valve');

subplot(414)
plot(tspan,qpump(1:size(tspan,2)),'magenta')
xlabel('time [sec]'); ylabel('flow [l/min]');
legend('Control input: Mud pump');

%%
 figure,
 plot(tspan,timePsample,'b-')
 legend('Time usage for one run','Orientation','horizontal')
 ylabel('seconds, time'); title('Time usage for MPC to calculate');