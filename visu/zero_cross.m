[y,fs]=audioread('a4.wav'); y=y(:,1);
%y=sin(linspace(0,secs,secs*fs)*440*2*pi)';
secs=2;


buffersize=2^8;
endp=10000
stp=60000

sample=y(stp+(1:buffersize));
sample=sample/max(sample(:))
shsample=circshift(sample,1)

zcr=sample.*shsample;
%shsample(1)=0;
lhe=0.2;

h=figure(1)
clf
hold on

h1=plot(shsample,'r')
h2=plot(sample,'k')
h3=plot(zcr,'--','Color',[0.7 0.7 0.7])
%legend([h1 h2 h3],{'Sample','Shifted Sample','Product'},'Location','SouthOutside')
legend([h1 h2 h3],{'Sample','Shifted Sample','Product'},'Location','SouthOutside')
%legend([h1 h3],{'Sample','Product'})
xl=[1 length(sample)];
line([xl], [0 0],'Color','k')
a=find(zcr<0);
a=a(2:end)
for i=1:length(a)
    line([a(i) a(i)], [-lhe lhe],'Color','k')
    
end

clear freqs
linedist=6;
for i=1:(length(a)-1)
    
    line([a(i)+1 a(i+1)-1], [-linedist*lhe -linedist*lhe],'Color',[0.7 0.7 0.7])
    smp=(a(i+1)-a(i));
    dist=-7;
    text([(a(i+1)+a(i))/2], [dist*lhe],[num2str(smp) 'smp=' sprintf('%2.2f',smp/fs*1000) 'ms=' sprintf('%2.1fHz',(1/(2*(smp/fs)))) ],'HorizontalAlignment','center','FontSize',7)
    freqs(i)=(1/(smp/fs));
end

yli=2.2;
axis([ xl+1 -yli yli])
%axis off
xlabel('Time')
ylabel('Amplitude')
set(gca,'XTick',[])
set(gca,'YTick',[0])
set(gca,'LooseInset',get(gca,'TightInset'))
%title(num2str(mean(freqs)))


set(h,'units','pixels','Position',[0 0 600 200])
set(h,'PaperPositionMode','auto')
%set(f,'PaperPosition',[0 0 0. 2])
%set(h,'units','pixels','PaperPosition',[0 0 1000 200])
%set(gca,'XColor','none','YColor','none')
%print(h,'-dpdf','./ready_figures/zerocross.pdf')
print(h,'-dpng','-r300','./ready_figures/zerocross.png')

