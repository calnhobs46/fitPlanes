function [orevdata,maxdata] = gridpts(data,method,a,b,mind)
%Gridpts find planes of more than 3 points in a grid 
%   start of planar region growing

revdata=data; %xdata=revdata(:,1); ydata=revdata(:,2);
% to make this work for any two axes for a grid
orevdata=data;


global perfplanes
global aaxismax
global aaxismin
global ainc
global binc
global baxismax
global baxismin
global int
global numgrids
global fitpt
global blocks
global caxes

global pl2del
global ppbG

%figuring out which axes to use
if a=='x' && b=='y'
    adata=revdata(:,1); bdata=revdata(:,2);
    acol=1;bcol=2;
elseif a=='x' && b=='z'
    adata=revdata(:,1); bdata=revdata(:,3);
    acol=1; bcol=3;
elseif a=='y' && b=='x'
    adata=revdata(:,2); bdata=revdata(:,1);
    acol=2; bcol=2;
elseif a=='y' && b=='z'
    adata=revdata(:,2); bdata=revdata(:,3);
    acol=2; bcol=3;
elseif a=='z' && b=='x'
    adata=revdata(:,3); bdata=revdata(:,1);
    acol=3; bcol=1;
elseif a=='z' && b=='y'
    adata=revdata(:,3); bdata=revdata(:,2);
    acol=3; bcol=2;
else
    fprintf('Not a valid axes pair\n')
    return
end

aaxismax=ceil(max(adata));
aaxismin=floor(min(adata)); 
baxismax=ceil(max(bdata));
baxismin=floor(min(bdata));
aaxisd=abs(aaxismax-aaxismin);
baxisd=abs(baxismax-baxismin);

nums=[aaxisd aaxismax aaxismin baxisd baxismax baxismin];

maxdata=[(max(nums)+1) (max(nums)+1) (max(nums)+1)]; %when points have been fitted to a plane, this matrix 'deletes' them
%make same amount of grids so that it's a square and sets the boundary
%points for each square of the grid

if aaxisd==0
    aaxisd=1;
elseif baxisd==0
    baxisd=1;
end
if max(baxisd,aaxisd)>=10
    if baxisd>aaxisd
        ainc=(aaxisd/baxisd); binc=1;
        blocks=(baxisd.^2);int=baxisd;
    elseif aaxisd>baxisd
            binc=(baxisd/aaxisd); ainc=1;
            blocks=(aaxisd.^2); int=aaxisd;
    elseif aaxisd==baxisd
        binc=1;ainc=1;
        int=(aaxisd); blocks=int.^2;
    end
else
    if aaxisd==0
        ainc=1;binc=baxisd/10;
        blocks=10; int=10;
    elseif baxisd==0
        binc=1; ainc=aaxisd/10;
        blocks=10; int=10;
    else
        ainc=aaxisd/10; binc=baxisd/10;
        int=10; blocks=100;
    end
end

ain=[];
bin=[];
plotpts=[];
i=0;
numgrids=zeros(2,6);
j=0;
coord=str2num([num2str(acol) num2str(bcol)]);

for k=1:blocks %goes through each block of the grid
    a1=ceil(k/int); b1=mod(k,int);
    %fprintf('\na interval: %i b interval: %i',a1,b1)
    if b1==0
        bb=(int*binc)+baxismin;
    else
        bb=(binc*b1)+baxismin;
    end
    ab=(a1*ainc)+aaxismin;
    %fprintf('\na increment %f, b incrment %f',ab,bb)
    ain=find(revdata(:,acol)<=ab);
    bin=find(revdata(:,bcol)<=bb);
    common=intersect(ain,bin,'rows'); %the points in that specific part of the grid
    %fprintf('Number of points in grid:')
    %disp(length(common))
    j=j+1;
    numgrids(j,1:9)=[0 (ab-ainc) ab (bb-binc) bb 0 coord 100 j]; 
    if ~isempty(common)
        row=size(common,1);
        numgrids(j,1)=row;
        for v=1:row
            fitpt=[fitpt; revdata(common(v),:)];
        end
        if row>=3 %can only fit a plane to 3 or more points
            %fprintf('\nPoints that can be fitted by a plane')
            %100 for copval , could be percentage of copval's closeness to 0
            numgrids(j,6)=1; %in 6 column, 1=pl 0=npl
            for v=1:row
                plotpts(v,:)=revdata(common(v),:);
            end
            [plane,copval]=method(plotpts);
            ivsq=[numgrids(j,3) numgrids(j,5)]; %2 3 
            numgrids(j,8)=copval; %6
            planefit(plane,ivsq,row,copval,mind,coord);
            plotpts=[];
        end
        for n=1:length(common)
            revdata(common(n),:)=maxdata;
        end
    else
        fitpt=[fitpt; maxdata+1];
    end
    fitpt=[fitpt; maxdata];
end
ppbG=perfplanes;
[orevdata]=GrowRegion(data,maxdata,mind); %find more points that fit the plane

%removing duplicate planes

perfplanes=[perfplanes caxes];


%plot3(data(:,1),data(:,2),data(:,3),'m*')
%reply=input('Please put the right planes from perfplanes into the global variable called revplanes. Type in done  when ready.','s');
%if ~isempty(reply)
% k=0;
% row=size(perfplanes,1);
% %fprintf('Thanks!')
% while ~isequal(row,k)
%     row=size(perfplanes,1);
[perfplanes]=removepl(perfplanes,pl2del);
%     k=size(perfplanes,1);
% end
%end

r=size(perfplanes,1);
figure
hold on
for s=1:r
    if ~isequal(perfplanes(s,1:10),zeros(1,10))
        cminmax=caxes(s,:);
        plane=perfplanes(s,:);
        PlotPlane(plane,cminmax,s,0)
    end
end

% r=size(revplanes,1);
% figure
% hold on
% for s=1:r
%     cminmax=caxes(s,:);
%     plane=revplanes(s,:);
%     PlotPlane(plane,cminmax,s)
% end
end

