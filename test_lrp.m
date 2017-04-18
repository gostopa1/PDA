addpath('./src')
bufferind=12;
buffersize=2^bufferind;
basefreq=110;
samples=1000;
noharms=5;
nonotes=36;


prefix='training_data/';

dir(prefix)
try
load([prefix 'training_detuned_distorted_drums_data_buffersize_' num2str(buffersize) '_basefreq' num2str(basefreq) '_samples' num2str(samples) '_harmonics' num2str(noharms) '_nonotes' num2str(nonotes) '.mat'])
catch me
    display('Data set not existing!')
    continue
end
data_notecors=data_notecors./repmat(trend,nonotes*samples,1);
display(['Chance level: ' sprintf('%2.2f',100/nonotes)]);
input('Press Enter to continue...')
addpath(genpath('../lrp-toolbox'));
X_train=data_notecors;
Y_train=binarylabels;
s=size(X_train);
nodevec=[nonotes*noharms nonotes];
noinputs=size(X_train,2);
nooutputs=size(Y_train,2);

%nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Tanh(), modules.Linear(nodevec(1),nooutputs),modules.Tanh()});
%nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Rect(),modules.Linear(nodevec(1),nodevec(2)), modules.Rect(), modules.Linear(nodevec(2),nooutputs),modules.SoftMax()});
%nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Rect(),modules.Linear(nodevec(1),nodevec(2)), modules.Rect(), modules.Linear(nodevec(2),nooutputs),modules.Rect()});

%RectSoftMax
nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Rect(), modules.Linear(nodevec(1),nooutputs),modules.SoftMax()});
% TanhTanh
%nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Tanh(), modules.Linear(nodevec(1),nooutputs),modules.Tanh()});
% TanhTanhTanh
%nn = modules.Sequential({modules.Linear(noinputs,nodevec(1)), modules.Tanh(),modules.Linear(nodevec(1),nodevec(2)), modules.Tanh(), modules.Linear(nodevec(2),nooutputs),modules.Tanh()});
%function train(obj, X, Y, Xval, Yval, batchsize, iters, lrate, lrate_decay, lfactor_initial, status, convergence, transform)
load([prefix 'testing_detuned_distorted_drums_data_buffersize_' num2str(buffersize) '_basefreq' num2str(basefreq) '_samples' num2str(samples) '_harmonics' num2str(noharms) '_nonotes' num2str(nonotes) '.mat'])
data_notecors=data_notecors./repmat(trend,nonotes*samples,1);

X_test=data_notecors;
Y_test=binarylabels;
%X_test=X_test/max(X_test(:));
nn.train(X_train,Y_train,X_test,Y_test,10,10000,0.01);
%nn.train(X_train,Y_train,[],[],20);

%%
clear buffer volume
fs=44100;
t=(1:buffersize)/fs;
notecorsfreqs=(1:noharms)'*basefreq*2.^((1:nonotes)/12);
notecorsfreqs=sort(notecorsfreqs(:));
sins=sin(2*pi*t'*notecorsfreqs');
coses=cos(2*pi*t'*notecorsfreqs');

res=dir('sounds\*.wav');
resi=2;
filei=9;
[y,fs]=wavread(['sounds\' res(filei).name]);
%soundsc(y,fs)
%
res(resi).name
y=y(:,1);
y=y(1:(end));
gap=4;
ind=0;
notecorsfreqs=(1:noharms)'*basefreq*2.^((1:nonotes)/12);
notecorsfreqs=notecorsfreqs(:);
t=(1:buffersize)/fs;
test_notecors=[];
for yi=1:floor((buffersize/gap)):(length(y)-buffersize)
    ind=ind+1;
    buffer=y(yi:(yi+buffersize-1));
    volume(ind,:)=ones(nonotes,1)*mean(buffer);
    buffer=buffer/max(buffer);
    %validate_fftabs(ind,:)=abs(fft(buffer));
    
    
    test_notecors(ind,:)=((sqrt([(buffer'*sins).^2 + (buffer'*coses).^2]))/buffersize)./trend;
    %test_notecors(ind,:)=sqrt(abs(sum(repmat(window.*buffer,1,nonotes*noharms)'.*exp(-2*pi*i*notecorsfreqs*t),2)).^2)/buffersize;
end

ypred = nn.forward(test_notecors);
%%
noteindsfirst=[3  7  12 ];

noteinds=[];
for octi=0:5
    noteinds=[noteinds noteindsfirst+(12*octi)]
end

labs=getNoteNames(basefreq,nonotes)
descending=nonotes:-1:1
labs=getNoteNames(basefreq,max(noteinds))
descending(noteinds(find(noteinds<nonotes)))
f=figure(2)
    imagesc(flipud(ypred'))
    colorbar
    
    title(['Buffer Size - ' num2str(buffersize)])
    
        xlabel('Time (seconds)')
    
    secondgap=1;
    seconds=0:secondgap:floor(length(y)/fs);
    
    ticks=(seconds)*(fs/(buffersize/gap));
    set(gca,'Xtick',ticks)
    set(gca,'XTickLabel',seconds)
    
    
    %noteind=nonotes-[noteind noteind+12]
    set(gca,'Ytick',sort(descending(noteinds(find(noteinds<nonotes)))))
    %set(gca,'YtickLabel',labs(descending(noteinds(find(noteinds<nonotes)))))
    set(gca,'YtickLabel',labs(sort(noteinds(find(noteinds<nonotes)),'descend')),'fontsize',7)
    
    set(gca,'Ytick',sort(descending(noteinds(find(noteinds<nonotes)))))
    %set(gca,'YtickLabel',labs(descending(noteinds(find(noteinds<nonotes)))))
    set(gca,'YtickLabel',labs(sort(noteinds(find(noteinds<nonotes)),'descend')),'fontsize',7)

axis tight
%set(f,'units','pixels','Position',[0 0 300 1000])
set(f,'PaperPosition',[0 0 3 1.5])
%set(f,'PaperPositionMode','auto')
%set(f,'units','pixels','PaperPosition',[0 0 1000 200])
%set(gca,'XColor','none','YColor','none')
%print(f,'-dpdf','./ready_figures/zerocross_real.pdf')
print(f,'-dpng','-r300',['./ready_figures/neural_nets_' res(filei).name(4:(end-4)) '_real.png'])

%%


a=zeros(size(ypred,1),1);
%lengthof_avg=gap;
lengthof_avg=gap;
a(1:lengthof_avg)=1/lengthof_avg;
smo=toeplitz(a);
figure(1)
clf
subplot(4,1,1)
imagesc(flipud(ypred'));

smopre=(ypred'*smo)';
smovol=(smo*abs(volume));
smovol=smovol/max(smovol(:))
subplot(4,1,2)
imagesc(flipud(smopre'));
colorbar

subplot(4,1,3)
thr=0.2
%imagesc(flipud(((smopre.*volume))'));
imagesc(flipud(((ypred.*smovol))'));


%plot(smovol)

colorbar
subplot(4,1,4)
thr=0.05
%imagesc(flipud(((smopre)>thr)'));
imagesc(flipud(((ypred.*smovol)>thr)'));

%%

addpath src
dt=(buffersize/fs)/gap;





%song=song/(max(song(:)));
%song=1.0*((ypred.*smovol)>thr);
song=1.0*((smopre.*smovol)>thr);
song=1.0*((smopre)>thr);
%song=1.0*(song>thr)
%smopre(smopre<0.2)=0;
figure(3)
imagesc(flipud(song'))
input('Shall I export it?')
data=song';
%data=ypred;
data=round((data/max(data(:)))*70);
b=pianoRoll2matrix(data,dt,(1:nonotes)+33);
midiout=matrix2midi(b);
writemidi(midiout,'./resultmidis/resultmidi3.mid')