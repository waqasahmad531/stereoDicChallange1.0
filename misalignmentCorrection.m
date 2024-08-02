% clc; clear all; close all; format compact
% Correction angles from Jeff
alpha = -0.0001;
beta = -0.0099;
gamma = -0.0042;

rotx = [1,0,0,0;0,cos(alpha),-sin(alpha),0;0,sin(alpha),cos(alpha),0;0,0,0,1];
roty = [cos(beta),0,sin(beta),0;0,1,0,0;-sin(beta),0,cos(beta),0;0,0,0,1];
rotz = [cos(gamma),-sin(gamma),0,0;sin(gamma),cos(gamma),0,0;0,0,1,0;0,0,0,1];
rot = rotx*roty*rotz;

% X,Y and Z of the stage movement

stepVals = [0 0 0; 0 0 -10;0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0;...
    -10 0 0; -20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10;...
    20 0 -20; -10 0 10; -20 0 20; 0 0 0];

% Transforming from stage coordinates to plate coordinates.
% Results in [Xn,Yn,Zn,1] matching [U,V,W,1]

plateMovement = rot\stepVals';



