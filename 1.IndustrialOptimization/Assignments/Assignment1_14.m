syms x0 h a b c f0 f1 f2 x
x1 = x0+h;
x2 = (x0+2*h);
[sola, solb, solc] = solve(-1/(x0^2)*(x0*b+c-f0)==a, -(1/x1)*(a*x1^2+c-f1)==b, -a*x2^2+x2*b-f2==c, 'ReturnConditions', true)

f = sola*x^2+ solc;
pretty(f)