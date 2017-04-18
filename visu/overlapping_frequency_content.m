a=[261.63; 349.23]
%a=[261.63; 261.63*2]
noharms=100
aa=a*(1:noharms)

semilogx(aa')

imagesc(dist(log(aa)))
mat=sort(aa(:));


figure(1)
clf
hold on

ms=20
h1=semilogx(aa(1,:),ones(noharms,1),'k.')
h2=semilogx(aa(2,:),ones(noharms,1),'r.')
set(h1,'MarkerSize',ms)
set(h2,'MarkerSize',ms)

a1=110*2.^((0:500)/12)
set(gca,'XTick',a1)
