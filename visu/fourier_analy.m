clear
[y,fs]=audioread('a4.wav'); y=y(:,1);
%fs=44100
secs=20;
f1=440
%y=sin(linspace(0,secs,secs*fs)*f1*2*pi)';



buffersize=2^9;
endp=10000
stp=60000
window=hanning(buffersize);
%window=ones(buffersize,1);
sample=y(stp+(1:buffersize));
sample=sample/max(sample(:))
shsample=circshift(sample,round(((1/440)*fs)))

zcr=(sample.*window).*(shsample.*window);

%shsample(1)=0;
lhe=0.2;

h=figure(1)
clf
subplot(3,1,1)
hold on

h1=plot(sample,'k','LineWidth',2)
cos1=cos(2*pi*f1*((1:buffersize)-1)/fs)
sin1=sin(2*pi*f1*((1:buffersize)-1)/fs)
h2=plot(cos1,'r--')

h3=plot(sin1,'b--')

%h2=plot(sample,'k')

%h3=plot(zcr,'--','Color',[0.7 0.7 0.7])

legend([h1 h2 h3],{'Sample',['Cosine of ' num2str(round((f1)))],['Sine of ' num2str(round((f1)))]})
xlabel('Time')
ylabel('Amplitude')
set(gca,'XTick',[])
set(gca,'YTick',[0])
xl=[1 length(sample)];
line([xl], [0 0],'Color','k')
axis([ xl+1 -1.2 1.2])
title('(a)')
ind=0;

t=linspace(0,buffersize/fs,buffersize);

for freqi=1:1:5000
    ind=ind+1
    %ft(freqi)=norm(sample'.*exp(-2*pi*i*freqi*((1:buffersize)-1)/fs));
    %ftwin(freqi)=sum((window.*sample)'.*exp(-2*pi*i*freqi*(((1:buffersize)-1)/fs)));
    ftwin(freqi)=sqrt(abs(sum((window.*sample)'.*exp(-2*pi*i*freqi*t))).^2);
    ft(freqi)=sqrt(abs(sum((sample)'.*exp(-2*pi*i*freqi*t))).^2);
    
    cos1=cos(2*pi*freqi*t);
    sin1=sin(2*pi*freqi*t);
    ftreim(freqi,1)=sum(sample'.*cos1);
    ftreim(freqi,2)=sum(sample'.*sin1);
    %cors(freqi)=sum(sample.*circshift(sample,round(((1/freqi)*fs))))/buffersize;
    %cors(freqi)=cors(freqi)/sum(buffersize);

end

subplot(3,1,2)
hold on
h2=semilogy(ftreim(:,1),'r')
h1=semilogy(ftreim(:,2),'b')
legend([h2 h1],{'Signal-cosine product','Signal-sine product'})
xlabel('Frequency (Hz)')
ylabel('Power')
set(gca,'YTick',[0])
% 
% a=zeros(length(cors),1);
% lengthof_avg=20;
% a(1:lengthof_avg)=1/lengthof_avg;
% smo=toeplitz(a);
title('(b)')
subplot(3,1,3)
hold on
%plot(real(ft),'k')
%plot(imag(ft),'b')
h1=semilogy(abs(ft),'r')
%semilogy(real(ft),'b--')
%semilogy(imag(ft),'r--')
h2=semilogy(abs(ftwin),'b')
legend([h1 h2],{'Power spectrum','Power spectrum with hanning window'})
%plot(ft,'k')
%plot(cors2','k')

%plot((cors*smo),'b')
ylabel('Power')
xlabel('Frequency (Hz)')
title('(c)')



yli=2.2;

%axis off
%xlabel('Time')
ylabel('Amplitude')
%set(gca,'XTick',[])
set(gca,'YTick',[0])
%title(num2str(mean(freqs)))
set(h,'units','pixels','Position',[0 0 800 600])

print(h,'-dpng','-r500','./ready_figures/fourier.png')
print(h,'-dpdf','./ready_figures/fourier.pdf')
