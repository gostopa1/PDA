function a=multiple_autocorrelation_detection(buffer,basefreq,nonotes,fs)

freqs=basefreq*2.^((1:nonotes)/12); % Fundamental frequency of each note
times=1./freqs; % Find period of each frequency
nosamples=round(times.*fs); % Number of samples corresponding to each period;
buffersize=length(buffer);
window=hann(buffersize);
for notei=1:nonotes
%a(notei)=corr(buffer,circshift(buffer,nosamples(notei)));
for mi=1:5 % For how many circular shifts to test for autocorrelation (5 is abstract here)
a(notei,mi)=corr(window.*buffer,window.*circshift(buffer,mi*nosamples(notei)));  % Check the autocorrelation of the signal and its shifted version
end

end
a=mean(a,2);
end