function [fitting] = PointsfitPlane(data,plane,mind)
%PointsfitPlane Returns 0 if the point doesn't fit the plane and 1 if it
%does

a=plane(1); b=plane(2); c=plane(3); d=plane(4);
fitting=[];
r=size(data,1);

if b==0 && c==0 %x equation
    for n=1:r
        x=data(n,1); y=data(n,2); za=data(n,3);
        if x==d
            fitting=[fitting; 1];
        else
            fitting=[fitting; 0];
        end
    end
elseif a==0 && c==0 %y equation
    for n=1:r
        x=data(n,1); y=data(n,2); za=data(n,3);
        if y==d
            fitting=[fitting; 1];
        else
            fitting=[fitting; 0];
        end
    end
else
    for n=1:r
        x=data(n,1); y=data(n,2); za=data(n,3);
        zp=((a/-c)*x)+((b/-c)*y)+(d/-c);
        if abs(zp-za)<=mind
            fitting=[fitting; 1];
        else
            fitting=[fitting; 0];
        end
    end

end

