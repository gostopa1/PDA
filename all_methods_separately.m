clear
res=dir('sounds\*.wav'); % Find the sounds located in the sounds directory
res.name %

filei=8; % Take the eighth sound
[y,fs]=wavread(['sounds\' res(filei).name]); % Load the sound as vector 
y=y(:,1); % Take only once channel of the audio in case of stereo
%% Show spectrograms

y=y(1:(end)); % Take the whole sound (somnetimes it might be better to take smaller parts of the sound)
basefreq=55; % Examine pitches starting from 55Hz A1
nonotes=60; % How many notes to examine
noharms=5; % How many harmonics to consider (for algorithms that take harmonics into account)
gap=2; 

y=y/max(y); % Normalize the signal to be in the range of [-1,+1]

addpath functions % Add the functions folder to use functions implemented there
buffersize=2^9; % Choose the buffer size
noteindsfirst=[3  7  12 ]; % Choose which notes to show in the labels of the figures (Now it is C G A)
noteinds=[];
for octi=0:5
    noteinds=[noteinds noteindsfirst+(12*octi)]
end
%% Preprocess sound
%y=abs(y);

windof=hann(buffersize);
%windof=ones(buffersize,1);
cutoff_frequency=20;
% cutoff_frequency=basefreq;
cutoff_frequency2=4000;
% cutoff_frequency2=basefreq*2^(nonotes/12)*noharms;
order = 4; %order filter, high pass
%[b14 a14]=butter(order,(cutoff_frequency/(fs/2)),'high');

[b14 a14]=butter(order,[(cutoff_frequency/(fs/2)) (cutoff_frequency2/(fs/2))]);

%y=filtfilt(b14,a14,y);

%% Zero crossing

labs=getNoteNames(basefreq,nonotes)
descending=nonotes:-1:1
labs=getNoteNames(basefreq,max(noteinds))
descending(noteinds(find(noteinds<nonotes)))
f=figure(filei)
clf
nobufs=4
method='zc'
method='autocore'
%method='mautocore'
%method='sine'
%method='hsine'
%for meo={'zc','autocore','mautocore','sine','hsine'}
for meo={'autocore'}
    method=meo{1}
for bufferind=1:nobufs
%for bufferind=nobufs
    bufferind
    clear data
    ind=0;
    buffersize=2^(6+2*bufferind);
    windof=hann(buffersize);
    gap=2;
    for yi=1:floor(buffersize/gap):(length(y)-buffersize)
        
        ind=ind+1;
        buffer=y(yi:(yi+buffersize-1));
        %buffer=buffer/max(buffer);
        buffer=zscore(buffer);
        buffer=buffer.*windof;
        
        switch method
            case {'zc'}
                data(ind,:)=zero_crossing_detection(buffer,basefreq,nonotes,fs);
                
            case {'autocore'}
                data(ind,:)=autocorrelation_detection(buffer,basefreq,nonotes,fs);
            case {'mautocore'}
                data(ind,:)=multiple_autocorrelation_detection(buffer,basefreq,nonotes,fs);
            case {'sine'}
                %display('maleys')
                data(ind,:)=simple_sine_detection(buffer,basefreq,nonotes,fs);
            case {'hsine'}
                data(ind,:)=harmonic_sine_detection(buffer,basefreq,nonotes,fs,noharms);
            otherwise
        end
        
        
        %data(ind,:)=multiple_autocorrelation_detection(buffer,basefreq,nonotes,fs);
        %data(ind,:)=autocorrelation_detection(buffer,basefreq,nonotes,fs);
        %data(ind,:)=harmonic_sine_detection(buffer,basefreq,nonotes,fs,noharms);
        %data(ind,:)=simple_sine_detection(buffer,basefreq,nonotes,fs);
        time(ind)=yi/fs;
    end
    subplot(nobufs,1,bufferind)
    
    imagesc(flipud(data'))
    colorbar
    %imagesc((data'))
    title(['Buffer Size - ' num2str(buffersize)])
    if bufferind==nobufs
        xlabel('Time (seconds)')
    end
    secondgap=1;
    seconds=0:secondgap:floor(length(y)/fs);
    
    ticks=(seconds)*(fs/(buffersize/gap));
    set(gca,'Xtick',ticks)
    set(gca,'XTickLabel',seconds)
    
    
    %noteind=nonotes-[noteind noteind+12]
    set(gca,'Ytick',sort(descending(noteinds(find(noteinds<nonotes)))))
    %set(gca,'YtickLabel',labs(descending(noteinds(find(noteinds<nonotes)))))
    set(gca,'YtickLabel',labs(sort(noteinds(find(noteinds<nonotes)),'descend')),'fontsize',7)
end
axis tight
%set(f,'units','pixels','Position',[0 0 300 1000])
set(f,'PaperPosition',[0 0 3 6])
%set(f,'PaperPositionMode','auto')
%set(f,'units','pixels','PaperPosition',[0 0 1000 200])
%set(gca,'XColor','none','YColor','none')
%print(f,'-dpdf','./ready_figures/zerocross_real.pdf')
print(f,'-dpng','-r300',['./ready_figures/' method '_' res(filei).name(4:(end-4)) '_real.png'])


end





