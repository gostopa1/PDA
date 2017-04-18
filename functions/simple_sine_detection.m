function a=simple_sine_detection(buffer,basefreq,nonotes,fs)

buffersize=length(buffer);
window=hann(buffersize)';
window=ones(buffersize,1)';
freqs=basefreq*2.^((1:nonotes)/12);
t=linspace(0,buffersize/fs,buffersize);


a=sqrt(abs(sum(repmat(window.*buffer',nonotes,1).*exp(-2*pi*i*freqs'*t),2)).^2)/buffersize;


%a=sqrt(sum(abs((repmat(window'.*buffer,1,nonotes).*exp(-2*pi*i*freqs'*t)')).^2))/buffersize;
end


