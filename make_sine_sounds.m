% This script makes a simple melody with sinusoids to test later with the
% different algorithms. 
% Starting from C4 going down to C3 in a major scale, with a duration of 0.33 seconds which
% corresponds to quarters in 180BPM

basefreq=110 % Choose the lowest frequency
fs=44100 % Choose sample rate

duration=0.33; % The duration of each note
t=0:1/fs:duration; % Make the time vector for that duration
snd=[] % The sound is empty at first and we add each sound of the scale
notemat=[3 5 7 8 10 12 14 15] % The notes that we want to play
notemat=notemat(end:-1:1) % Going downwards
vol=0.2; % The volume for each sound
for notei=notemat % For each note
freq=basefreq*2^(notei/12); % Find its frequency 
snd=[snd vol*sin(freq*2*pi*t)]; % Make the sound and concatenate to the total sound
end

soundsc(snd,fs) % Play the sound 
wavwrite(snd,fs,16,'sounds/ww_sines.wav') % Save the sound