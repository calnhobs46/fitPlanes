function [] = FinalRemovePlane(data)
%FinalRemovePlane Looks at two planes and decides if they are similar if
%plane 1 fits plane 2's points
%   Detailed explanation goes here

global allplanes

k=size(allplanes,1);
allplanes=sortrows(allplanes, [5 6 7 8 11 12]); %axis restictions--> sort by 10
%m=0;
it=1;
while ~isequal(it,k) %~isequal(m,size(find(allplanes(:,9)),1)) ||
    fprintf('\n iteration:'); disp(it);
    fprintf('\nplanes left:'); disp(k); %size(find(allplanes(:,9)),1));
    it=size(allplanes,1);
    z=2;
    allplanes=sortrows(allplanes, [5 6 7 8 11 12]);
    while z<k
        %if isequal(allplanes(1,10),allplanes(z,10)) %see if removing this makes a difference
%         if isequal(allplanes(z,10),12)
%             a=1; b=2; c=3;
%         elseif isequal(allplanes(z,10),23)
%             a=2; b=3; c=1;
%         elseif isequal(allplanes(z,10),13)
%             a=1; b=3; c=2;
%         end
        if ~isequal(allplanes(1,9),0)
            if ~isequal(allplanes(z,9),0)
                pl1bnd=allplanes(1,5:12);
                pl2bnd=allplanes(z,5:12); %matrix=[a 1 2; b 3 4; c 7 8]; %circulate through all of the planes to see if any of them fit pl1
                %points within bounds of plane 1
                [r co]=find(data(:,1)>=pl1bnd(1)); ptpl1=data(r,:); [r co]=find(ptpl1(:,1)<=pl1bnd(2)); ptpl1=ptpl1(r,:);
                [r co]=find(ptpl1(:,2)>=pl1bnd(3)); ptpl1=ptpl1(r,:); [r co]=find(ptpl1(:,2)<=pl1bnd(4)); ptpl1=ptpl1(r,:);
                [r co]=find(ptpl1(:,3)>=pl1bnd(7)); ptpl1=ptpl1(r,:); [r co]=find(ptpl1(:,3)<=pl1bnd(8)); ptpl1=ptpl1(r,:);
                %points within bounds of plane 2
                [r co]=find(data(:,1)>=pl2bnd(1)); ptpl2=data(r,:); [r co]=find(ptpl2(:,1)<=pl2bnd(2)); ptpl2=ptpl2(r,:); %1,2,3 --> a,b,c
                [r co]=find(ptpl2(:,2)>=pl2bnd(3)); ptpl2=ptpl2(r,:); [r co]=find(ptpl2(:,2)<=pl2bnd(4)); ptpl2=ptpl2(r,:);
                [r co]=find(ptpl2(:,3)>=pl2bnd(7)); ptpl2=ptpl2(r,:); [r co]=find(ptpl2(:,3)<=pl2bnd(8)); ptpl2=ptpl2(r,:);
                %finding if the points of pl2 fit pl1
                fits=PointsfitPlane(ptpl2,allplanes(1,:),.01);
                fps=find(fits);
                if ~isempty(fps)
                    pl12pts=ptpl2(fps,:); pl12pts=[pl12pts; ptpl1];
                    mina=floor(min(pl12pts(:,1))); maxa=ceil(max(pl12pts(:,1))); %mina=min([pl1bnd(1) pl1bnd(2) pl2bnd(1) pl2bnd(2)]); maxa=max([pl1bnd(1) pl1bnd(2) pl2bnd(1) pl2bnd(2)]);
                    minb=floor(min(pl12pts(:,2))); maxb=ceil(max(pl12pts(:,2)));%minb=min([pl1bnd(3) pl1bnd(4) pl2bnd(3) pl2bnd(4)]); maxb=max([pl1bnd(3) pl1bnd(4) pl2bnd(3) pl2bnd(4)]);
                    minc=floor(min(pl12pts(:,3))); maxc=ceil(max(pl12pts(:,3))); %minc=min([pl1bnd(7) pl1bnd(8) pl2bnd(7) pl2bnd(8)]); maxc=max([pl1bnd(7) pl1bnd(8) pl2bnd(7) pl2bnd(8)]);
                end
                    %pl1bnd(matrix(a/b/c,2/3))
%just trying this out if isequal(fits,ones(size(fits))) %all points fit pl1 --> pl1 and pl2 are the same
%                     %change bounds of pl1, delete pl2
%                     allplanes(1,5)=mina; allplanes(1,6)=maxa; allplanes(1,7)=minb; allplanes(1,8)=maxb; allplanes(1,11)=minc; allplanes(1,12)=maxc;
%                     allplanes(z,1:4)=zeros(1,4); allplanes(z,9)=0;
                if ~isempty(fps) %there are some points that fit pl1
                    %change pl1's bounds, put pl1 at end
                    allplanes(1,5)=mina; allplanes(1,6)=maxa; allplanes(1,7)=minb; allplanes(1,8)=maxb; allplanes(1,11)=minc; allplanes(1,12)=maxc;
                    allplanes(z,1:4)=zeros(1,4); allplanes(z,9)=0;
                else
                    allplanes=[allplanes(2:k,:); allplanes(1,:)];
                end
            end
        else
            allplanes=[allplanes(2:k,:); allplanes(1,:)];
        end
        z=z+1;
        %else
        %z=z+1;
        %end
    end
    %it=it+1;
    if isequal(z,k)
        allplanes=[allplanes(2:k,:); allplanes(1,:)];
    end
    d=find(allplanes(:,9));
    allplanes=allplanes(d,:);
    k=size(allplanes,1);
end

end



