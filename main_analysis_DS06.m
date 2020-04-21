clc
clear

addpath 'C:\Users\Sandro\Downloads\eeglab2019_1\plugins\Biosig3.3.0\biosig'
inDir='C:\Users\Sandro\Desktop\CHIARA\DATASET\DS_06\Giga DB dataset REST';

%Declarations
lf=8;
hf=13;
n_eps=6;
ep_l=10;
n_chans=55;
fs=160;
originalFs = 512;
desiredFs = 160;

fil_sbjs='s*.mat';
sbjs=dir(fullfile(inDir,fil_sbjs));
my_conn=zeros(length(sbjs),n_eps,n_chans,n_chans);
n_sbjs=length(sbjs);

for i=1:length(sbjs)
    eeg=dir(fullfile(strcat(inDir,'\',sbjs(i).name)));
    load(strcat(eeg.folder,'\',eeg.name));
    ind=[34;40;42;50;58;52;60;64;1;5;7;13;21;15;23;25;38;48;31;45;55;43;53;3;10;18;8;16;9;11;46;44;14;12;49;51;17;19;56;54;36;6;4;39;41;22;20;57;59;25;26;30;63;62;29];
    
    [p,q] = rat(desiredFs / originalFs);
    tmp_data=eeg.rest(:,1:60*fs+1); 
    tmp_data=tmp_data(ind,:);
    tmp_data = double(tmp_data);
    EEG_raw=resample(tmp_data,p,q);
    tmp_data=tmp_data';
    tmp_data=reref(tmp_data);
    filt_EEG=eegfilt(tmp_data',fs,lf,hf,0,[],0,'fir1',0);
    tmp_data=tmp_data';
    
    for j=1:n_eps
        en=j*ep_l;               
        in=en-ep_l;       
        my_data=filt_EEG(:,in*fs+1:en*fs);                               
        my_data=my_data(1:n_chans,1:n_chans);
        my_conn(i,j,:,:)=phase_lag_index(my_data');
    end
end
