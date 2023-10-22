function [myJ myG myHeq] = compute_both(u_ini,state_ini_values,dt,Ref,Np)
%this is the function where we compute the objective function and the
%constraints together at the same time.
%weighting matrices for error and control inputs
Qe = eye(Np).*1; %weighting matrix for the error
Pu = eye(Np).*1; %weighting matrix for the control inputs
%to store the output variable
Pc = zeros(Np,4);
%since we need to calculate the outputs for the whole prediction horizon we use a for loop and
%solve the ODE (model of the nonlinear process) using runge kutta. To solve the ODEs we need to
%know the initial values of the states. Thus they are passed into the “compute_both” function.
for i = 1:Np
%find out which control input to use for each time step within the prediction horizon.
u_k = u_ini(i,:);
%use runge kutta to update the states
x_next = OilWell_runge_kutta(state_ini_values,dt,u_k);
%use the states to calculate the output
%in this case, the output is simply the state.
%//Note: Sometimes outputs have to be calculated using algebriac
%equations and the states. In such a case, please make a separate
%function for calculating the output variables.
Pc(i,1) = x_next;
%update the state
state_ini_values = x_next;

end
%For this example, there is also constraint on the rate of change of control input variables (du)
%such that -0.1<=du<=0.1
%since in the objective function, we don't have 'du' but only 'u', we have to calculate 'du' ourself.
%find du from the input signals
du = u_ini(2:end)-u_ini(1:end-1);

%now make the objective function
J = (Ref-Pc)'*Qe*(Ref-Pc) + du'*Pu*du;
myJ = J/2;
%if there are equaltiy constraints, it should be listed as a column vector
%here we don't have equality constraints so we use empty matrix
myHeq = [];


%//Important Note: If the objective function was formulated such that it
%had " (du)'P du ",then we don't have to calculate 'du' here because 'du' would be passed to
%this function “compute_both” by the optimizer and so we already would have it.
%list the inequality constraints as column vector
myG =[u_ini-1; % valve opening should be less than 1
-u_ini+0; %valve opening should be greater than 0
du - (0.1); % du should be less than 0.1 for each sample
-du-(0.1); % du should be greater than -0.1 for each sample
];