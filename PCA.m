function [zeq,sumdists] = PCA(xyzdata,otitl,specpt)
%PCA Takes data and uses PCA to find the 'best fit' plane
%DON'T put in rand(), put the random numbers in through a variable

%Plots the points, midpoint, least eigenvalued vector, and the 'best
%fit'plane and gives the value of coplanarity

%fprintf('DEBUGGING:In PCA\n')
global zmat %1-x, 2-y 3-constant
global D
global evt3

%plotting points
%figure
titl=['PCA:' otitl];
xdata=xyzdata(:,1); ydata=xyzdata(:,2); zdata=xyzdata(:,3);
plot3(xdata,ydata, zdata,specpt,'LineWidth',8)
hold on
grid
xlabel('x axis'); ylabel('y axis'); zlabel('z axis')
N=length(xdata);

%find means
x_bar=mean(xdata); y_bar=mean(ydata); z_bar=mean(zdata);

%find covariances
covxx=(1/(N-1))*sum((xdata-x_bar).^2);
covxy=(1/(N-1))*sum((xdata-x_bar).*(ydata-y_bar));
covxz=(1/(N-1))*sum((xdata-x_bar).*(zdata-z_bar));
covyy=(1/(N-1))*sum((ydata-y_bar).^2);
covyz=(1/(N-1))*sum((ydata-y_bar).*(zdata-z_bar));
covzz=(1/(N-1))*sum((zdata-z_bar).^2);
covyx=covxy;covzy=covyz;covzx=covxz;

%covariance matrix
covmat=[covxx covxy covxz; covyx covyy covyz; covzx covzy covzz];

%eigenvectors and values each column of vecs/val corresponds to one
[evt,D]=eigs(covmat); %  eigenvector and the value
    %planeproject(evt(:,1),evt(:,2),projpts)
%graphing the least eigenvalued eigenvector b/c this ev is the cv of plane
evt3=evt(:,3);
plot3([(x_bar),(evt3(1)+x_bar)],[(y_bar),(evt3(2)+y_bar)],[(z_bar),(evt3(3)+z_bar)]);
plot3(x_bar,y_bar,z_bar,'bd','LineWidth',8);
%To plot longer eigenvector line 
%plot3([(evt3(1)+x_bar),(x_bar)],[(evt3(2)+y_bar),(y_bar)],[(evt3(3)+z_bar),(z_bar)],'c-');

%math before plotting the plane
barmx=[x_bar;y_bar;z_bar];
%so use least eigenvector and mean coordinates for the plane

%setting up the plane
syms x y

z=((evt3(1).*x)+(evt3(2).*y)-(evt3(1)*x_bar)-(evt3(2)*y_bar)-(evt3(3)*z_bar))/(-evt3(3));
zmat(1,1)=vpa((evt3(1)/(-evt3(3))),4);
zmat(1,2)=vpa((evt3(2)/(-evt3(3))),4);
zmat(1,3)=vpa(((-(evt3(1)*x_bar)-(evt3(2)*y_bar)-(evt3(3)*z_bar))/(-evt3(3))),3);
zeq=vpa(z,4);

%plotting the plane
mini=floor(min(min(xyzdata)));%min of mesh
maxi=ceil(max(max(xyzdata)));%max of mesh
[X,Y]=meshgrid((mini:maxi),(mini:maxi));
Z=((evt3(1).*X)+(evt3(2).*Y)-(evt3(1)*x_bar)-(evt3(2)*y_bar)-(evt3(3)*z_bar))/(-evt3(3));
surf(X,Y,Z)
freezeColors
colormap(rand(1,3))

%measuring how coplanar it is: dot of u3 and (xn-xp), sum of squared distances
sumdists=0;

size=length(xyzdata);
if size==3
    size=2;
end
for n=1:size
    dataset=xyzdata(n,:);
    sumdists=sumdists+(dot(evt3',(dataset-barmx'))).^2;
        
end

%editing the graph
title(titl)

if strfind(otitl,'and')==[] %when the two planes aren't graphed on same figure
    legend('data points','3rd ev', 'mean mid point', 'PCA plane')
elseif strfind(otitl,'and')~=0
  %when both planes are graphed on same figure
    legend('High: data points','High: 3rd ev', 'High: mean mid point', 'High: PCA plane','Low: data points','Low: 3rd ev', 'Low: mean mid point', 'Low: PCA plane') 
    val=strfind(otitl,'and')+4;
    ntitl='';
    for n=val:length(otitl)
        ntitl=[ntitl otitl(n)];
    end
    otitl=ntitl;
end
grid

%print out statements
fprintf('%s: Equation of Plane: ', otitl); disp(zeq)
fprintf('\n Coplanarity: %s', otitl); disp(sumdists)


end

