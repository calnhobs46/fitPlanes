function [outlierdata] = findPlanebyGrid(data,method)
%findPlanebyGrid takes a set of points and a method and looks at the points
%from three different view points (xy, yz and xz) and using the grid finds
%planes using three or more points. The remainder of the points uses just
%the method

global perfplanes
global fitpt
global caxes
global allplanes
%global allaxes
global pl2del



minval=.01;
perfplanes=[];
fitpt=[];
pl2del=[];

%looks at data wrt grids with axes xy, yz and xz
[revdata,maxdata1]=gridpts(data,method,'x','y',minval);
[revdata1]=setdiff(revdata,maxdata1,'rows'); %take out maxdata points
grid
plot3(data(:,1),data(:,2),data(:,3),'m*')
title('xy planes')
xyplanes=perfplanes; perfplanes=[]; fitpt=[]; pl2del=[]; %zaxes=caxes; 

if ~isempty(revdata1)
    [revdata2,maxdata2]=gridpts(revdata1,method,'y','z',minval);
    [revdata21]=setdiff(revdata2,maxdata2,'rows'); %take out maxdata points
    grid
    plot3(data(:,1),data(:,2),data(:,3),'b*')
    title('yz planes')
    yzplanes=perfplanes; perfplanes=[]; fitpt=[]; pl2del=[]; %xaxes=caxes;
    if ~isempty(revdata21)
        [revdata3,maxdata3]=gridpts(revdata21,method,'x','z',minval);
        [revdata31]=setdiff(revdata3,maxdata3,'rows'); %take out maxdata points
        grid
        plot3(data(:,1),data(:,2),data(:,3),'k*')
        title('xz planes')
        xzplanes=perfplanes; %yaxes=caxes;
        outlierdata=revdata31;
    else
        outlierdata=[];
    end
else
    outlierdata=[];
end

yzplanes=[yzplanes(:,1:4) yzplanes(:,11:12) yzplanes(:,5:6) yzplanes(:,9:10) yzplanes(:,7:8)];
xzplanes=[xzplanes(:,1:6) xzplanes(:,11:12) xzplanes(:,9:10) xzplanes(:,7:8)];
figure
hold on
title('all planes')
allplanes=[xyplanes;yzplanes;xzplanes];
%allaxes=[zaxes;xaxes;yaxes];


k=size(find(allplanes(:,9)),1);
m=20;
while ~isequal(k,m)
    k=size(find(allplanes(:,9)),1);
    FinalRemovePlane(data);
    m=size(find(allplanes(:,9)),1);
    %allplanes=allplanes(m,:);
end
r=size(allplanes,1);
for w=1:r
    if ~isequal(allplanes(w,9),0)
        plane=allplanes(w,:);
        crange=allplanes(w,11:12);
        PlotPlane(plane,crange,w,1);
    end
end
plot3(data(:,1),data(:,2),data(:,3),'y*')



end


