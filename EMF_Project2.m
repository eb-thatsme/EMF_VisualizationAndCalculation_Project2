clear;
clc;
%%
%Initializations
urI = 5000; %Mu iron
ur = 1; %Mu for everywhere else
uo = 4 * pi * 10e-7; %Mu intial
I = 10; %Current
frequency = 60; %60Hz for alternating current

N=41; % Number of unknown points (arbitrary)
deltaX = 10e-2/N; %Distance between each point on x-axis
deltaY = deltaX; %These are equal since this is a square

A=zeros(N,N); %Generates array NxN of "0" for magnetic potential
B=zeros(N,N); %Generates array NxN of "0" for flux density
J=zeros(N,N); %Generates array NxN of "0" for volume current density 
u=ones(N,N); %Generates array NxN of "0" for magnetic permeability

%Find u everywhere else
for q=1:41
    for v=1:41
        u(q,v)= ur * uo; 
    end
end

%Find u inside the first iron bar
for y=1:41 
    for x=1:13
        u(x,y)= urI * uo; 
    end
end

%Find u inside the second iron bar
for y=28:41 
    for x=1:41
        u(x,y)= urI * uo; 
    end
end

%Find J inside conductor 
for g=19:23
    for f=19:23
        J(g,f) = 10/(pi*(1e-2)^2);
    end
end

%Loops determine the Magnetic Potential in Domain and Flux Density
for k=1:2000 %number of iterations
    for p=2:N-1
       for r=2:N-1
           %Solve for magnetism
           M = (1/((u(p,r)+u(p+1,r))/2)) + ...
                    (1/((u(p,r)+u(p-1,r))/2)) + ...
                    (1/((u(p,r)+u(p,r+1))/2)) + ...
                    (1/((u(p,r)+u(p,r-1))/2));
           A(p,r) = ((A(p+1,r)/((u(p,r)+u(p+1,r))/2)) + ...
                    (A(p-1,r)/((u(p,r)+u(p-1,r))/2)) + ...
                    (A(p,r+1)/((u(p,r)+u(p,r+1))/2)) + ...
                    (A(p,r-1)/((u(p,r)+u(p,r-1))/2)) + ...
                    ((deltaX)^2 * J(p,r)))/M;   
          %Tests A for convergence
          %A_Converg(k)=norm(A);
       end
    end
end
for i=2:N-1
    for j=2:N-1
       BAy(i,j)= (-(A(i+1,j))+A(i-1,j))/(2*deltaX);
       BAx(i,j) = (A(i,j+1)-A(i,j-1))/(2*deltaY);
    end
end

B= sqrt((BAx.^2) + (BAy.^2));

%Plots a contour map of the Magnetic Potential for V
subplot(1,2,1);
contour(A,10,'ShowText','on')
set(gca,'yDir','reverse');

%Plots Electric Field
subplot(1,2,2);
quiver(BAy,BAx)
set(gca,'yDir','reverse');
