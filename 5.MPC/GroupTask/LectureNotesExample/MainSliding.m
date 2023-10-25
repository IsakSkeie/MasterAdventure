clc
clear
%Simulation time;
start = 0;
stop = 1000;
%sampling time
dt = 4; %sampling time in seconds %dt = 6 seconds
Tlengt = ((stop-start)/dt);
tspan = linspace(start, stop, Tlengt);

%choose prediction horizon Np
Np = 5; %Np time steps ahead in the future

%initial values of the states
Pp_init     = 6.7e6;%8*10^5; %Initial pressure for pump
qBit_init   = 0.025; %Initial flow rate through drill bit
Pc_init     = 8.9e6; %Initial pressure at controle choke valve
pbit_init   = 255e5; %Inital pressure for Pbit
q_res       = 0;


Pp_init     = 6.5e6;%8*10^5; %Initial pressure for pump
qBit_init   = 0.025; %Initial flow rate through drill bit
Pc_init     = 6.5^7; %Initial pressure at controle choke valve
pbit_init   = 255e5; %Inital pressure for Pbit


state_ini_values = [Pp_init, qBit_init, Pp_init, pbit_init];
%state_ini_values = [Pp_init, qBit_init, Pc_init, pbit_init, q_res];

%initial value for optimizer control
u_ini = ones(Np,2); 

u_ini(:,1)  = u_ini(:,1)* 0.025; %Initialize pump flow
u_ini(:,2) = u_ini(:,2)* 50;    %Initialize choke valve opening


%Reference
%make the reference vector offline (for the whole prediction horizon length).
Ref =   ones(Tlengt+Np, 1) * 250e5; %P_bit
Refp = zeros(Tlengt, 1);
RefMPC = zeros(Np, 1);

Pc = zeros(Tlengt,1);
u_valve = zeros(Tlengt,1);
u_pump = zeros(Tlengt,1);

timePsample = zeros(Tlengt,1);

for i=1:Tlengt+Np
    if (i>=100)
        Ref(i) = Ref(i) - 3e5;
    end
end

for i=1:Tlengt

    for j=1:Np
        RefMPC(j) = Ref(i+j);
    end
    tic
    %make the nonlinear optimization problem and solve it
    %u_k_ast = ones(Np, 2);
    %u_k_ast(:,2) = 70;
    u_k_ast = optimization_tank(u_ini,state_ini_values,dt,RefMPC,Np);
    u = u_k_ast(1,:);
    timePsample(i) = toc;

    x_next = OilWell_runge_kutta(state_ini_values,dt,u);
    
    state_ini_values = x_next;

    %storing of values for plotting
    u_pump(i) = u(1);
    u_valve(i) = u(2);
    Pc(i,1) = state_ini_values(4);
    Refp(i,1) = RefMPC(1);
    i = i
end


%plotting
figure,
subplot(311)
plot(tspan,Refp,'b-',tspan,Pc,'k-')
legend('ref Pc','Pc','Orientation','horizontal')
ylabel('Pc, Ref'); title('NL optimal control of tank pressure');

subplot(312)
plot(tspan,u_pump,'r-')
xlabel('time [sec]'); ylabel('u');
legend('Control input: Pump speed');

subplot(313)
plot(tspan,u_valve,'r-')
xlabel('time [sec]'); ylabel('u');
legend('Control input: Choke Valve');