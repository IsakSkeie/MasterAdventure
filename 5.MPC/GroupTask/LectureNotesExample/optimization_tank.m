function u = optimization_tank(u_ini,state_ini_values,dt,Ref,Np)
%In this function we:
%define functions for objective and constraints
%choose the slover types + other options to the solver
%######## Structure 2 ############################### %efficient
%reduces computation time by half
%We can cut the computational time by NOT repeating the same calculations
%for calculating the objective function and the nonlinear constraints
%let us try by making use of nested function
%options for chosing the type of method for optimization and other options
ops = optimset('Algorithm','sqp','Display','off','MaxIter',5000);
%ops =optimset('Algorithm','interior-point','Display','off','MaxIter',5000);
%ops = optimset('Algorithm','active-set','Display','off','MaxIter',20);
uLast = [];% Last place compute_both was called
myJ = [];% Use for objective at xLast
myG = [];% Use for nonlinear inequality constraint
myHeq = [];% Use for nonlinear equality constraint
%define the function where the objective function will be calculated
137
obj_func = @(u)objfun_tank(u,state_ini_values,dt,Ref,Np);
%define the function where the nonlinear constraints will be
%calculated (both equality and inequality constraints will be calculated in
%the same function
cons_func = @(u)confun_tank(u,state_ini_values,dt,Ref,Np);
%use the fmincon solver
[u,fval,exitflag,output,solutions] = fmincon(obj_func,u_ini,[],[],[],[],[],[],cons_func,ops);
function J = objfun_tank(u,state_ini_values,dt,Ref,Np)
if ~isequal(u,uLast) %check if computation is necessary
% disp('button pressed: objective call');
% pause;
[myJ myG myHeq] = compute_both(u,state_ini_values,dt,Ref,Np);
uLast = u;
end
%now compute objective function
J = myJ;
end
function [G Heq] = confun_tank(u,state_ini_values,dt,Ref,Np)
if ~isequal(u,uLast) %check if computation is necessary
% disp('button pressed: constraint call');
% pause;
[myJ myG myHeq] = compute_both(u,state_ini_values,dt,Ref,Np);
uLast = u;
end
%now compute constraints
G = myG;
Heq = myHeq;
end
end
%######### Structure 2 ENDS ##################################