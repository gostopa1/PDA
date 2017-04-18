clear
[y,fs]=audioread('a4.wav'); y=y(:,1);
%[y,fs]=audioread('../sounds/ww_sines.wav'); y=y(:,1);
fs=44100
secs=20;
%f1=200
%y=sin(linspace(0,secs,secs*fs)*f1*2*pi)';



buffersize=2^9;
endp=10000
stp=60000
window=hanning(buffersize);
%window=ones(buffersize,1);
sample=y(stp+(1:buffersize));
sample=sample/max(sample(:))
sample2=sample.*hanning(buffersize);
frequency_to_show=430
shsample2=window.*circshift(sample2,round(((1/frequency_to_show)*fs)))
shsample=circshift(sample,round(((1/frequency_to_show)*fs)))

zcr=(sample2.*window).*(shsample2.*window);

%shsample(1)=0;
lhe=0.2;

h=figure(1)
clf
subplot(3,1,1)
hold on
h1=plot(shsample,'r')
h2=plot(sample,'k')
line([(round(((1/ (frequency_to_show))*fs))) (round(((1/ (frequency_to_show))*fs)))],[-1 1],'LineStyle',':','Color','k')
xlabel('Time')
ylabel('Amplitude')
set(gca,'XTick',[])
set(gca,'YTick',[0])
xl=[1 length(sample)];
line([xl], [0 0],'Color','k')
axis([1 length(sample) -1 1])
title('(a) Plain signal and shifted version')
subplot(3,1,2)
hold on

h1=plot(shsample2,'r')
h2=plot(sample2,'k')
%h3=plot(zcr,'--','Color',[0.7 0.7 0.7])
h3=plot(window,'--','Color',[0.7 0.7 0.7])

legend([h1 h2 h3],{'Sample',['Shifted ' num2str(round(((1/ (frequency_to_show))*fs))) ' samples (' num2str(frequency_to_show) 'Hz)'],'Hanning'},'Location','NorthEast')
xlabel('Time')
ylabel('Amplitude')
set(gca,'XTick',[])
set(gca,'YTick',[0])
xl=[1 length(sample)];
axis([1 length(sample) -1 1])
line([xl], [0 0],'Color','k')
title('(b) Windowed signals')
subplot(3,1,3)
hold on
ind=0;
for freqi=1:1:4000
ind=ind+1
    cors1(freqi)=sum(sample.*circshift(sample,round(((1/freqi)*fs))))/buffersize;
    cors1(freqi)=cors1(freqi)/(buffersize)*freqi;
    cors(freqi)=sum((window.*sample).*(window.*circshift(sample,round(((1/freqi)*fs)))))/buffersize;
    cors(freqi)=cors(freqi)/(buffersize)*freqi;
    %cors2(freqi)=sum((sample.*window).*(circshift(sample,round(((1/freqi)*fs))).*window))/buffersize;
    %cors2(freqi)=cors2(freqi)/sum(window);
end

a=zeros(length(cors),1);
lengthof_avg=20;
a(1:lengthof_avg)=1/lengthof_avg;
smo=toeplitz(a);

h1=plot(cors','k')
h2=plot(cors1','r')

%plot((cors*smo),'b')
ylabel('Correlation')
xlabel('Frequency (Hz)')
title('(c) Autocorrelation of each frequency')
set(gca,'YTick',[0])
legend([h1 h2 ],{'No Hanning','Hanning'},'Location','NorthEast')
%%
yli=2.2;
%axis([ xl+1 -yli yli])
%axis off
%xlabel('Time')
%ylabel('Amplitude')
line([0 length(cors)], [0 0],'Color','k')
%set(gca,'XTick',[])
%set(gca,'YTick',[0])
%title(num2str(mean(freqs)))
set(h,'units','pixels','Position',[0 0 1000 600])
print(h,'-dpdf','./ready_figures/autocorrelation.pdf')
print(h,'-dpng','-r300','./ready_figures/autocorrelation.png')
