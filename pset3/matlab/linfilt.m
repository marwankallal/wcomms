function [y, ty ] = linfilt(h, th, x, tx );

Dtx = tx(2) - tx(1);
Dth = th(2) - th(1);

if abs(Dtx- Dth) > 1e-10;
    error('ERROR: Time spacings are not equal! \n')
else
    ly = length(x) + length(h) - 1;
    tx0 = tx(1);
    th0 = th(1);
    ty0 = tx0+th0;
    Dty = Dtx;
    ty = [ty0:Dty:ty0+Dty*(ly-1)];
    y = conv(h,x); 
end
