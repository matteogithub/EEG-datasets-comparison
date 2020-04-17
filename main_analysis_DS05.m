clc
clear

addpath 'C:\Users\Sandro\Downloads\eeglab2019_1\plugins\Biosig3.3.0\biosig'
inDir='C:\Users\Sandro\Desktop\CHIARA\mTBI\Data';

%Declarations
lf=8;
hf=13;
n_eps=6;
ep_l=10;
n_chans=55;
fs=160;

fil_sbjs='*_1_Rest.mat';
sbjs=dir(fullfile(inDir,fil_sbjs));
my_conn=zeros(length(sbjs),n_eps,n_chans,n_chans);
n_sbjs=length(sbjs);

for i=1:length(sbjs)
    eeg=dir(fullfile(strcat(inDir,'\',sbjs(i).name)));
    load(strcat(eeg.folder,'\',eeg.name));
    ind=[28;26;27;22;17;23;18;16;1;3;4;7;12;8;13;14;2;21;11;54;50;55;51;30;35;40;34;39;5;6;25;24;38;37;53;52;9;10;20;19;58;33;32;57;56;42;41;49;48;43;44;45;46;47;15];
    EEG.data=EEG.data(ind,:);
    EEG.nbchan=n_chans;
    EEG_raw=pop_resample(EEG,fs);
    tmp_data=EEG_raw.data(:,1:60*fs+1);  
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
