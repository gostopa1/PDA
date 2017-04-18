function a=harmonic_sine_detection(buffer,basefreq,nonotes,fs,noharms)
%harmonic_sine_detection(buffer,basefreq,nonotes,fs,noharms)
%Description: This function performs basic fourier transformation for the
%frequencies corresponding to the notes as well as their harmonics. For
%each note it returns the sum of amplitudes of the frequencies
%corresponding to the note and its harmonics, divided by the number of
%harmonics under examination
%
%Inputs: 
% buffer: the data
% basefreq: the lowest frequency
% nonotes: the number of notes to examine
% noharms: The number of harmonics to examine
%
% Outputs:
% a: the resulting amplitudes for each note

buffersize=length(buffer); % Calculate the size of the buffer
t=linspace(0,buffersize/fs,buffersize); % Make a time vector from zero until the time corresponding to the length of the buffer

window=hann(buffersize)'; % Generate a hanning window
%window=ones(buffersize,1)'; 
for harmi=1:noharms % For each of the harmonics
freqs=harmi*(basefreq*2.^((1:nonotes)/12)); % Find the frequency of the harmonic

atemp(:,harmi)=sqrt(abs(sum(repmat(window.*buffer',nonotes,1).*exp(-2*pi*i*freqs'*t),2)).^2)/buffersize; % Calculate the amplitude for this harmonic index for each note frequency

end
a=sum(atemp,2)/noharms; % Now sum all the amplitudes across the harmonics and divide them by the number of harmonics (Average amplitude)
end