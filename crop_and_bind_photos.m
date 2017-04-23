%% This script only loads images from the results and binds them together. It looks more neat than generating them directly in MATLAB because subplot management in MATLAB is a mess

prefix='ready_figures\'

res=dir([prefix '*.png'])

%for resi=1:2:length(res)
for resi=7 
b=imread([prefix res(resi).name]);
a=imread([prefix res(resi+1).name]);

sa=size(a);
thry=0.01;
thrx=0.02
img=[a(round(sa(1)*thry):round(sa(1)*(1-thry)),round(sa(2)*thrx):round(sa(2)*(1-thrx)),:) b(round(sa(1)*thry):round(sa(1)*(1-thry)),round(sa(2)*thrx):round(sa(2)*(1-thrx)),:)];
image(img)
axis image
filename=res(resi).name((res(resi).name==res(resi+1).name));
imwrite(img,[prefix '/newones/' filename])
end