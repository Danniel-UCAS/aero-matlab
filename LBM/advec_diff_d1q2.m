%% 1D Advection-Difussion LBM D1Q2
% by Manuel Diaz
clc; clear; %close all;

%% Domain Grid
L = 100;    % Length
n = 100;    % Nodes
dx = L/n; dt = 1;
x  = 1:dx:L;

%% Initial Condition
f1  = zeros(1,n);
f2  = zeros(1,n);
rho = zeros(1,n); % initial value of the dependent variable rho = T(x,t)
feq1= zeros(1,n);
feq2= zeros(1,n);

%% Constants
u     = 0.1; % Flow velocity
ck    = dx/dt;
csq   = (dx^2)/(dt^2);
alpha = 0.25;
omega = 1/(alpha/(dt*csq)+0.5);
w     = [1/2,1/2];
cx    = [  1, -1];
cy    = [  0,  0];
links = [  1,  2];
tEnd  = 500; % time steps

%% Movie Parameters
tPlot = 10; frames= tEnd/tPlot; count = 0;
figure(1) 
colordef white

%% Boundary Conditions
twall = 1; 

%% Main Loop
for cycle = 1:tEnd;
    % Collision process
    rho = f1+f2;
    
    feq1 = 0.5*rho*(1+u/ck);  
    feq2 = 0.5*rho*(1-u/ck);
            
    f1 = (1-omega) * f1 + omega * feq1;
    f2 = (1-omega) * f2 + omega * feq2;
    % Streaming process
    
    f1 = stream2d( f1 , [cy(1),cx(1)]);
    f2 = stream2d( f2 , [cy(2),cx(2)]);

    % Boundary condition
    f1(1) = twall-f2(1);    %Dirichlet BC
    f1(n) = f1(n-1);        %Neumann BC
    f2(n) = f2(n-1);        %Neumann BC

    % Visualization every tPlot
    if mod(cycle,tPlot) == 1
        count = count + 1;
        plot(x,rho);
        title '1D Advection-Diffusion using LBM D1Q2'
        xlabel 'x cell'
        ylabel 'Temperature'
        M(count)=getframe;
    end
    
        % Animated gif file
    if mod(cycle,tPlot) == 1
        F = getframe;
        if count == 1
            [im,map] = rgb2ind(F.cdata,256,'nodither');
            im(1,1,1,tEnd/tPlot) = 0;
        end
        im(:,:,1,count) = rgb2ind(F.cdata,map,'nodither');
    end
end
%% Make Movie
movie(M,2,10); % movie(M,n,fps)

%% Export to Gif
imwrite(im,map,'advec_diff_d1q2.gif','DelayTime',0,'LoopCount',3)