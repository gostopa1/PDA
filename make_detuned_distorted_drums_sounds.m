%% This script creates dataset to be used for training the neural networks
clear % Clear the workspace to avoid accidents
for testi=0:1 % We create two data sets. One for training and one for validation
[y2,fs]=wavread(['sounds\pdadrums.wav']); % Load the drums sounds to add them in the generated sounds
 
y2=y2/max(abs(y2)); % Make the drums audio values within the range of (-1,+1)
thr=0.99; % Threshold for clipping, exceeding values are being clipped, introducing distortion
detune=3; % How much to detune each of the harmonics 
playsounds=1; % Put 1 if you want to play every sound produced (dangerous)
sparsity=1; % How sparse should the volumes be? (Not too evenly distributes)

fs=44100; % Sampling frequency
manyharms=50;  % The number of harmonics, from whom the final ones will be chosen
noharms=10; % How many harmonics to choose from the total number
bufferi=12; % Select the power index for the buffer size (power of two)
buffersize=2^bufferi;  % Make the buffer size according to the index just declared
basefreq=[55]; % The lowest note to consider
window=hanning(buffersize) % the window function to use for the sounds
noiters=[1000]; % How many samples to make for each note
nonotes=[60]; % Number of notes to examine (starting from the basefreq)

ind=0; % Index for the samples
t=linspace(0,buffersize/fs,buffersize); % Make the time vector from 0 until the duration of the buffer
notecorsfreqs=((1:noharms)'*basefreq*2.^((1:nonotes)/12))'; % Make a list of  all the frequencies for the notes and their harmonics
notecorsfreqs=sort(notecorsfreqs(:)); % Sort the frequency list to be in an ascending order
sins=sin(2*pi*t'*notecorsfreqs'); % Make the sinewaves for the given frequencies and the time
coses=cos(2*pi*t'*notecorsfreqs'); % Make the cosinewaves for the given frequencies and the time

data_notecors=zeros(noiters*nonotes,noharms*nonotes); % Make an empty matrix where the results will be stored (This is not necessary but speeds up the process)

for notei=1:nonotes % For each of the notes
    notei % Show the number of the not
    notefreq=basefreq*2^(notei/12); %  Find the fundamenetal frequency for the note
    %fmat=notefreq*(1:noharms)+2.^(detune*rand(noharms,1)');
    fmat=notefreq*(1:manyharms)+2.^(detune*rand(manyharms,1)'); % Take all the possible harmonics and also detune them a bit
    fmat(2:noharms)=fmat(randperm(noharms-1)+1); % Choose the fundamental and some (noharms) harmonics out of the many possible ones (manyharms)
    fmat=fmat(1:noharms); %  This is the final set of harmonic frequencies
    amps=rand(noharms,noiters)+0.1; % Generate random amplitude for each sample and its harmonics
    amps=amps.^sparsity; % Make the amplitudes more sparse (so that they are not so smooth, or gaussianly distributed)
    for iteri=1:noiters
                
        phaserand=2*pi*rand(noharms,1); % Generate random phase for each of the harmonic
        %y=amps(:,iteri)'*sin(2*pi*t'*fmat+repmat(phaserand,1,buffersize)')'+0.3*randn(length(t),1)';
        y=amps(:,iteri)'*sin(2*pi*t'*fmat+repmat(phaserand,1,buffersize)')';
        y=y/noharms; % Divide the sound by the number of harmonics
                
        y(y>thr)=thr; % Introduce some distortion (clipping) to introduce a larger variety of sounds
        y(y<-thr)=-thr; % same for negative values
        
        % Add the drums
        StartingPoint=randi(length(y2)-buffersize); % Define a starting point from the drums audio 
        drumspart=10*y2(StartingPoint:(StartingPoint+buffersize-1))'; % Cut the drums part and amplify it
        y=(y+drumspart)/2; % Merge drums part and sound part
                
        if playsounds==1; % Play the sound if asked to do so
            soundsc(y,fs) % Play the sound
            pause % Wait for key press
        end
        ind=ind+1;

        data_notecors(ind,:)=sqrt(abs(sum(repmat(window.*y',1,nonotes*noharms)'.*exp(-2*pi*i*notecorsfreqs*t),2)).^2)/buffersize; %Do the Fourier transofrm for the frequencies corresponding to the notes and their harmonics
        
        binarylabels(ind,notei)=1; % Add label to the corresponding note for this sample
        %binarylabels(ind,notei)=amp;
        
    end
end
trend=mean(data_notecors);

if testi==0
save(['./training_data/' 'training_detuned_distorted_drums_data_buffersize_' num2str(buffersize) '_basefreq' num2str(basefreq) '_samples' num2str(noiters) '_harmonics' num2str(noharms) '_nonotes' num2str(nonotes) '.mat'],'data_notecors','binarylabels','trend')
else
save(['./training_data/' 'testing_detuned_distorted_drums_data_buffersize_' num2str(buffersize) '_basefreq' num2str(basefreq) '_samples' num2str(noiters) '_harmonics' num2str(noharms) '_nonotes' num2str(nonotes) '.mat'],'data_notecors','binarylabels','trend')
end
end

