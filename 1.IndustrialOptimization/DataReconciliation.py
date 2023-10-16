# -*- coding: utf-8 -*-
"""
Created on Thu Oct  7 15:34:15 2021

@author: isak.skeie
"""

import numpy as np





def recondiliation(y, A, V):
    Yhat = np.linalg.inv(A.dot(V.dot(A.T))).dot(A.dot(y))
    Yhat = y-V.dot(A.T.dot(Yhat))
    return Yhat

if __name__ == "__main__":

    y = np.array((120.2, 95.2, 180, 142.8, 35.7, 80.2))
    
    A = np.array(([1, 0, -1, 1, 0, -1],[0, 0, 1, -1, -1, 0]))
    
    V = np.zeros((6,6))
    V[0,0] = 1.2
    V[1,1] = 0.5
    V[2,2] = 5
    V[3,3] = 0.8
    V[4,4] = 0.5
    V[5,5] = 0.2
    
    
    y1 = np.array((110.5, 60.8, 35, 68.9, 38.6, 101.4))
    V1 = np.array(([0.6724, 0,0,0,0,0],[0, 0.2809,0,0,0,0],[0,0,0.2116,0,0,0],
                   [0,0,0,0.504,0,0], [0,0,0,0,0.2025,0], [0,0,0,0,0,1.44]))
    A1 = np.array(([1,-1,-1,0,0,0],[0,1,0,-1,0,0],[0,0,1,0,-1,0],[0,0,0,1,1,-1]))
    
    Yhat = recondiliation(y, A, V)
  