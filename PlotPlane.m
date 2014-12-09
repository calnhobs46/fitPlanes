function [] = PlotPlane(plane,crange,s,x) %could put only xy, yz, and xz planes in and graph them that way
%PlotPlane plots planes in perfplanes
%   Detailed explanation goes here

%*changes for x, y, z allplanes


global ainc
global binc
%global perfplanes- to do the loop itself
global int


cmin=crange(1);
cmax=crange(2);


axes=plane(10);
if cmin==cmax
    cmin=cmin-.5;
    cmax=cmax+.5;
end
if x==0
    if isequal(axes,12)
        zmaxi=cmax; zmini=cmin; zinc=abs(cmax-cmin)/int;
        xmini=min(plane(5),plane(6)); xmaxi=max(plane(6),plane(5)); xinc=ainc/int;
        ymini=min(plane(7),plane(8)); ymaxi=max(plane(8),plane(7)); yinc=binc/int;
    elseif isequal(axes,13)
        ymaxi=cmax; ymini=cmin; yinc=abs(cmax-cmin)/int;
        xmini=min(plane(5),plane(6)); xmaxi=max(plane(6),plane(5)); xinc=ainc/int;
        zmini=min(plane(7),plane(8)); zmaxi=max(plane(8),plane(7)); zinc=binc/int;
    elseif isequal(axes,23)
        xmaxi=cmax; xmini=cmin; xinc=abs(cmax-cmin)/int;
        ymini=min(plane(5),plane(6)); ymaxi=max(plane(6),plane(5)); yinc=ainc/int;
        zmini=min(plane(7),plane(8)); zmaxi=max(plane(8),plane(7)); zinc=binc/int;
    end
    if isequal(xmini,xmaxi)
        xmini=xmini-.5;
        xmaxi=xmaxi+.5;
    end
    if isequal(ymini,ymaxi)
        ymini=ymini-.5;
        ymaxi=ymaxi+.5;
    end
    if isequal(zmini,zmaxi)
        zmini=zmini-.5;
        zmaxi=zmaxi+.5;
    end
else
    zmaxi=cmax; zmini=cmin; zinc=abs(cmax-cmin)/int;
    xmini=min(plane(5),plane(6)); xmaxi=max(plane(6),plane(5)); xinc=(xmaxi-xmini)/int;
    ymini=min(plane(7),plane(8)); ymaxi=max(plane(8),plane(7)); yinc=(ymaxi-ymini)/int;
end
a=plane(1); b=plane(2); c=plane(3); d=plane(4); 
% amini=plane(5); amaxi=plane(6);
% bmini=plane(7); bmaxi=plane(8);
if b==0 && c==0 %x equation
    [Y,Z]=meshgrid((ymini:yinc:ymaxi),(zmini:zinc:zmaxi));
    X=d+0*Z+0*Y;
    %fprintf('\nplotting')
    surf(X,Y,Z,'DisplayName',num2str(s))
elseif a==0 && c==0 %y equation
    [X,Z]=meshgrid((xmini:xinc:xmaxi),(zmini:zinc:zmaxi));
    Y=d+0*Z+0*X;
    %fprintf('\nplotting')   
    surf(X,Y,Z)
elseif c==0
    [X,Z]=meshgrid((xmini:xinc:xmaxi),(zmini:zinc:zmaxi));
    Y=(a/-b)*X+(d/-b);
    %fprintf('\nplotting')    
    surf(X,Y,Z,'DisplayName',num2str(s))
else
    [X,Y]=meshgrid((xmini:xinc:xmaxi),(ymini:yinc:ymaxi));
    Z=(((a/-c).*X)+((b/-c).*Y)+(d/-c));
    %fprintf('\nplotting')    
    surf(X,Y,Z,'DisplayName',num2str(s))
end
% end

end

