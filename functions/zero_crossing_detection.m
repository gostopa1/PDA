function a=zero_crossing_detection(buffer,basefreq,nonotes,fs)
%soundsc(buffer,fs)
freqs=basefreq*2.^((1:nonotes)/12);

shifted_buffer=circshift(buffer,-1);
sig=buffer.*shifted_buffer;
temp=find(sig<0);
temp2=circshift(temp,-1)-temp;
freqsfound=(1./(temp2/fs)/2);
%freqsfound=freqsfound(freqsfound>basefreq);


a=histc(freqsfound,freqs);
end
%%