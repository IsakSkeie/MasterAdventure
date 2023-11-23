function [myJ myG myHeq] = compute_both(u,state_ini_values,dt,Ref, Np, pipeConnections, u_ini)
%this is the function where we compute the objective function and the
%constraints together at the same time.
%weighting matrices for error and control inputs
Qe = eye(1).*0.001; %weighting matrix for the error
Pu = eye(2).*1; %weighting matrix for the control inputs
R  = eye(1).*1; %Wighting matrix for relaxed constraint on back pump
Pu_Pump = eye(1).*1000; %Weight matrix for Back pump control input
Pu(2) = 4e10; %Valve
Pu(1) = 2e15; %Pumpe


R = 1e11; 

n_uGroup        = 4; %Number of groups for deviation control variables
GroupInterval   = (Np) / 4;



%to store the output variable
Pc = zeros(Np,1);

%Parameters for constraints
   Pfrac = 270e5; %fracture pressure
   Pres  = 250e5; %Reservoir pressure
   Pcoll = 220e5; %Collaps perssure

%Stopping pump


%since we need to calculate the outputs for the whole prediction horizon we use a for loop and
%solve the ODE (model of the nonlinear process) using runge kutta. To solve the ODEs we need to
%know the initial values of the states. Thus they are passed into the “compute_both” function.
for i = 1:Np

    %find out which control input to use for each time step within the prediction horizon.
    u_k = u(i,:);
    %use runge kutta to update the states
    x_next = OilWell_runge_kutta(state_ini_values,dt,u_k);
    %use the states to calculate the output
    %in this case, the output is simply the state.
    %//Note: Sometimes outputs have to be calculated using algebriac
    %equations and the states. In such a case, please make a separate
    %function for calculating the output variables.
    Pc(i) = x_next(4);

    %update the state
    state_ini_values = x_next;
    


end
%For this example, there is also constraint on the rate of change of control input variables (du)
%such that -0.1<=du<=0.1
%since in the objective function, we don't have 'du' but only 'u', we have to calculate 'du' ourself.
%find du from the input signals


u = [u_ini(1,:); u];
du = (u(2:end,:)-u(1:end-1,:));

%now make the objective function
J = 0;
for i = 1:Np-1

    J = (Ref(i)-Pc(i))'*Qe*(Ref(i)-Pc(i)) + du(i,:)*Pu*du(i,:)' + J ;

    
end


%P_debug = du(1,:)*Pu*du(1,:)'

 %J = (Ref-Pc)'*Qe(i)*(Ref-Pc);%  + u_ini(i,:)*Pu*u_ini(i,:)' + J;
    
myJ = J;

%if there are equaltiy constraints, it should be listed as a column vector
myHeq = [];
%Create vector for equality constraint for grouping

for i = 3:Np
    if i ~= 4 & i ~= 7 & i ~= 11  
        tempGroup = [u(i,:)' - u(i-1,:)'];
        myHeq = vertcat(myHeq, tempGroup);

    end
end

%Create equality constraint for back pump when pipe is not connected

for i = 1:Np

    if pipeConnections(i) == 0 
       tempConstraint =  [u(i, 1)];
       myHeq = vertcat(myHeq, tempConstraint);   

    else 
        
       tempConstraint =  [u(i, 1) - u(i, 1)];
       myHeq = vertcat(myHeq, tempConstraint);   

    end 
end 


%list the inequality constraints as column vector
myG = [-Pc + 220e5; % Pressure in bit needs to be greater than reservoir pressure
       Pc - 270e5; % Pressure in bit needs to be less than Fracture pressure
        u(:,2) - 100;     % Highest vale opening is 100%
        -u(:,2) + 0;      %Lowest valve opening is 0%
        u(:,1) - (0.0167);   % Highest pump flow is 0.25 m^3/s
       -u(:,1) + 0 ;      %Lowest pump flow is 0 l/min
       -du(:,2) - 2;          %Valve opening cannot change more than two over a timsetep  
        du(:,2) - 2;          %Valve opening cannot change more than two over a timsetep  
       -du(:,1) - 0.002;          %Valve opening cannot change more than two over a timsetep  
        du(:,1) - 0.002;          %Valve opening cannot change more than two over a timsetep  
    ];





%Add constraint for back pump, to only run when pipe connections are
%performed

