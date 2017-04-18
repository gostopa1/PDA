function a=autocorrelation_detection(buffer,basefreq,nonotes,fs)

freqs=basefreq*2.^((1:nonotes)/12); % Fundamental frequency of each note
times=1./freqs; % Find period of each frequency
nosamples=round(times.*fs); % Number of samples corresponding to each period;
buffersize=length(buffer);
window=hann(buffersize);
for notei=1:nonotes
%a(notei)=corr(buffer,circshift(buffer,nosamples(notei)));
for mi=1:5
a(notei,mi)=corr(window.*buffer,window.*circshift(buffer,mi*nosamples(notei)));
end

end
a=mean(a,2);
end