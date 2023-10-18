function x_next = my_runge_kutta(states_ini_values,dt,u_k_ast)
%the 4th oder runge kutta algorithm
K1 = tankPressure_equations([],states_ini_values,u_k_ast);
K2 = tankPressure_equations([],states_ini_values+K1.*(dt/2),u_k_ast);
K3 = tankPressure_equations([],states_ini_values+K2.*(dt/2),u_k_ast);
K4 = tankPressure_equations([],states_ini_values+K3.*dt,u_k_ast);
x_next = states_ini_values + (dt/6).*(K1+2.*K2+2.*K3 + K4);