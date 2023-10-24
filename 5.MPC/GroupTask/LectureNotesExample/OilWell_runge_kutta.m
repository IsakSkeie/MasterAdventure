function x_next = OilWell_runge_kutta(states_ini_values,dt,u_k_ast)
% %the 4th oder runge kutta algorithm
% K1 = tankPressure_equations([],states_ini_values,u_k_ast);
% K2 = tankPressure_equations([],states_ini_values+K1.*(dt/2),u_k_ast);
% K3 = tankPressure_equations([],states_ini_values+K2.*(dt/2),u_k_ast);
% K4 = tankPressure_equations([],states_ini_values+K3.*dt,u_k_ast);
% x_next = states_ini_values + (dt/6).*(K1+2.*K2+2.*K3 + K4);


%OilWell runge kutta
K1 = oilWell_equations(u_k_ast, states_ini_values);
K2 = oilWell_equations(u_k_ast, states_ini_values+K1.*(dt/2));
K3 = oilWell_equations(u_k_ast, states_ini_values+K2.*(dt/2));
K4 = oilWell_equations(u_k_ast, states_ini_values+K3.*dt);

%OilWell runge kutta for Torbjørns oilwell
% K1 = TBsOilWellEq(u_k_ast, states_ini_values);
% K2 = TBsOilWellEq(u_k_ast, states_ini_values+K1.*(dt/2));
% K3 = TBsOilWellEq(u_k_ast, states_ini_values+K2.*(dt/2));
% K4 = TBsOilWellEq(u_k_ast, states_ini_values+K3.*dt);

x_next = states_ini_values + (dt/6).*(K1+2.*K2+2.*K3 + K4);

%Pbit for memory
x_next(4) = K1(4);
%x_next(5) = K1(5);





