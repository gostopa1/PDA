basefreq=110
fs=44100


duration=0.33;
t=0:1/fs:duration;
snd=[]
notemat=[3 5 7 8 10 12 14 15]
notemat=notemat(end:-1:1)
vol=0.2;
for notei=notemat
freq=basefreq*2^(notei/12);
snd=[snd vol*sin(freq*2*pi*t)];
end

soundsc(snd,fs)
wavwrite(snd,fs,16,'sounds/ww_sines.wav')