function a=autocorrelation_detection(buffer,basefreq,nonotes,fs)
%AUTOCORRELATION_DETECTION(buffer,basefreq,nonotes,fs)
% Inputs: buffer: the data
% Basefreq: the lowest frequency
% nonotes: the number of notes starting from the lowest frequency
% fs: sampling frequencye
%
% Outputs: The autocorrelation values for each note for the given buffer

freqs=basefreq*2.^((1:nonotes)/12); % Fundamental frequency of each note
times=1./freqs; % Find period of each frequency
nosamples=round(times.*fs); % Number of samples corresponding to each period;
buffersize=length(buffer); % Buffer size
window=hann(buffersize); % Make the hanning window
for notei=1:nonotes % For each of the notes ... 

a(notei)=corr(window.*buffer,window.*circshift(buffer,nosamples(notei))); % find the product of the buffer and its shifted version by a number of samples that corresponds to its period (autocorrelation)
end
end