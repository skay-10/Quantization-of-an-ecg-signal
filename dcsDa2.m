%code for digitizing an ECG signal
clc
clear all
syms x
[ECG, t, freqint] = plotATM('tr03-0092m');%extracting the ecg signal from the .mfile

x=0.005:10/length(ECG):10; %defining the time scale

figure(1);
subplot(3,1,1);
plot(x,ECG,'y'); % plotting sine signal
title('ORIGINAL ECG SIGNAL');
xlabel('time(s)');
ylabel('Biopotential(mV)');
set(gca,'FontSize',7,'FontWeight','bold');


% SAMPLING & QUANTIZATION

n1=10;
L=2^n1;
max=1;%declaring the maximum value of biopotential
min=-2;%declaring the maximum value of biopotential
del=(max-min)/L;
partition=min:del:max; % definition of decision lines
codebook=min-(del/2):del:max+(del/2); % definition of representation levels
[index,qf]=quantiz(ECG,partition,codebook); 

%plotting the quantization levels
subplot(3,1,2);
stem(partition);
title('QUANTIZATION LEVELS');
xlabel('time(s)');
ylabel('Biopotential(mV)');
axis([-1 1010 -2.5 1.5])
set(gca,'FontSize',7,'FontWeight','bold');

%plotting the quantized signal
subplot(3,1,3);
stairs(qf,'r');
title('QUANTIZED SIGNAL');
xlabel('time(s)');
ylabel('Biopotential(mV)');
set(gca,'FontSize',7,'FontWeight','bold');

% Normalization
l1=length(index);      % to convert 1 to n as 0 to n-1 indices
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(qf);
for i=1:l2 			%  to convert the end representation levels within the range.
    if(qf(i)==min-(del/2))
        qf(i)=min+(del/2);
    end
    if(qf(i)==max+(del/2))
        qf(i)=max-(del/2);
    end
end


%  Encoding the qunatized signal
code=de2bi(index,'left-msb') 	% decimal to binanry conversion
k=1;
for i=1:l1                     % to convert column vector to row vector
    for j=1:n1
        ecod(k)=code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end

figure();
subplot(3,1,1);
stairs(ecod);%plotting  digital signal(enecod values)
title('DIGITAL SIGNAL(enecoded)');
xlabel('time(s)');
ylabel('Biopotential(mV)');
set(gca,'FontSize',7,'FontWeight','bold');

%DEMODULATION
code1=reshape(ecod,n1,(length(ecod)/n1));
index1=bi2de(code1,'left-msb');
resignal=del*index+min+(del/2);

% plotting the demodulated signal
subplot(3,1,2);
plot(x,resignal,'g');
title('DEMODULATAED SIGNAL');
xlabel('time(s)');
ylabel('Biopotential(mV)');
set(gca,'FontSize',7,'FontWeight','bold');
