function noteNames=getNoteNames(basefreq,nonotes)
%noteNames=getNoteNames(basefreq,nonotes)
%Descriptiong: This function gives the name of all the notes starting from
%the BASEFREQ frequency and for a number of notes equal to NONOTES
%
% Inputes: 
% basefreq: the lowest frequency to examine
% nonotes: how many notes to examine starting from the lowest frequency
% 
% Outputs:
% noteNames: the names of the notes as strings

A0freq=27.5; % The lowest note of the piano
labs={'A' 'A#' 'B' 'C' 'C#' 'D' 'D#' 'E' 'F' 'F#' 'G' 'G#' };
alllabs=repmat(labs,1,60); % repeat the notes for a large number of times (number 60 is arbitrary)


octind=log2(basefreq/A0freq)-1;
for notei=2:(nonotes+1)

    if strcmp(alllabs{notei},'C')
        
        octind=octind+1;
    end
    noteNames{notei-1}=strcat(alllabs{notei},num2str(octind));
end

end
