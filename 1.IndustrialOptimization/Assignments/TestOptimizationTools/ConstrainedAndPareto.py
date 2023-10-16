#%%
import scipy.optimize as optimize
import numpy as np
from matplotlib import pyplot as plt


def Rosenbrock():
    '''Rosenbrock function constrained with a cubic and a line'''
    def f(xy):
        z = (1-xy[0])**2+100*(xy[1]-xy[0]**2)**2
        return z
    
    xy_0 = [0,0]
    #Constraints
    def cons1(xy):
        return ((xy[0]-1)**3-xy[1]+1)
    def cons2(xy):
        return (xy[0]+xy[1]-2)
    
    constraints = [{'type': 'ineq', 'fun': cons1},
                   {'type': 'ineq', 'fun': cons2}]
    bounds = optimize.Bounds([-1.5,-0.5],[1.5,2.5])
    
    
    result = optimize.minimize(f, xy_0, bounds=bounds, constraints=constraints)
    
    if result.success: print(result)
    


def Rosenbrock_disk():
    """Rosenbrock function constrained with a disk"""
    def f(xy):
        z = (1-xy[0])**2+100*(xy[1]-xy[0]**2)**2
        return z
    
    xy_0 = [0,0]
    #Constraints
    def cons1(xy):
        x = xy[0]
        y = xy[1]
        return 2-x**2-y**2
    
    
    constraints = {'type': 'ineq', 'fun': cons1}
    bounds = optimize.Bounds([-1.5,-1.5],[1.5,1.5])
    
    
    result = optimize.minimize(f, xy_0, bounds=bounds, constraints=constraints)
    
    if result.success: print(result)
# %%
#Function collected from https://code.activestate.com/recipes/578230-pareto-front/ , 26.10.21
def pareto_frontier(Xs, Ys, maxX = False, maxY = False):
    myList = sorted([[Xs[i], Ys[i]] for i in range(len(Xs))], reverse=maxX)
    p_front = [myList[0]]    
    for pair in myList[1:]:
        if maxY: 
            if pair[1] >= p_front[-1][1]:
                p_front.append(pair)
        else:
            if pair[1] <= p_front[-1][1]:
                p_front.append(pair)
    p_frontX = [pair[0] for pair in p_front]
    p_frontY = [pair[1] for pair in p_front]
    return p_frontX, p_frontY

def BinhAndKorn():
    res = 50
    x = np.linspace(0, 5, res)
    y = np.linspace(0, 3, res)
    f1 = []
    f2 = []
    for n in range(res):
        for i in range(res):
            g1 = (x[n]-5)**2+y[i]**2
            g2 = (x[n]-8)**2+(y[i]+3)**2
            if g1 <= 25:
                f1.append(4*x[n]**2+4*y[i]**2)
            else: f1.append(0)
            if g2 >= 7.7:
                f2.append((x[n]-5)**2+(y[i]-5)**2)
            else: f2.append(0)
    
    return f1, f2

def ChankongAndHaimes():
    res = 50
    x = np.linspace(-20, 20, res)
    y = np.linspace(-20, 20, res)
    f1 = []
    f2 = []
    for n in range(res):
        for i in range(res):
            g1 = x[n]**2+y[i]**2
            g2 = x[n]-3*y[i]+10
            if g1 <= 225:
                
                if g2 <= 0:
                    f2.append(9*x[n]-(y[i]-1)**2)
                    f1.append(2+(x[n]-2)**2+(y[i]-1)**2)
    
    
    return f1, f2   


def paretorFront1():
    f1, f2 = BinhAndKorn()
    px, py = pareto_frontier(f1[500:], f2[500:])
    
    plt.plot(px, py)
    #plt.plot(f1[500:], f2[500:])
    plt.title("Pareto Line")
    plt.xlabel("f1")
    plt.ylabel("f2")
    plt.grid()
    plt.show()
    
def paretoFront2():
    f1, f2 = ChankongAndHaimes()
    px, py = pareto_frontier(f1, f2)
    
    plt.plot(px, py)
    #plt.plot(f1, f2)
    plt.title("Pareto Line")
    plt.xlabel("f1")
    plt.ylabel("f2")
    plt.grid()
    plt.show()
    
    
    
#%%
if __name__ == '__main__':
    
    
    #Rosenbrock()
    #Rosenbrock_disk()
    #paretorFront1()
    paretoFront2()
    
    
    
    
    
# %%
