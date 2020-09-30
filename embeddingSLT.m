clc;
clear all;
close all;
tic;
vid=VideoReader('C:\Users\aayua\Documents\MATLAB\pexels3.mp4');
  numFrames = vid.NumberOfFrames;
  n=numFrames;
for i = 1:1:n
  frames = read(vid,i);
  viddup{i}=frames;
end 
covs=viddup{1};
[x,y,z] = size(covs);
p=2;


while 2.^p<x
p=p+1;
end
p=p-1;

d=2.^p;
s=d/3;
s=s*2;
s=round(s);
m2=imread('C:\Users\aayua\Documents\MATLAB\messsage1.jpg');
[a,b,c] = size(m2);

f=0;
while f*s < b
    f=f+1; 
end
g=(f*s)-b;
Padd = padarray(m2,[0 g],'post');

e=0;
while e*s < a
    e=e+1; 
end
w=(e*s)-a;

Padd = padarray(Padd,[w 0],'post');
[rows, columns, numberOfColorBands] = size(Padd);
wholeBlockRows = floor(rows / s);
blockVectorR = [s * ones(1, wholeBlockRows), rem(rows, s)];
wholeBlockCols = floor(columns / s);
blockVectorC = [s * ones(1, wholeBlockCols), rem(columns, s)];
if numberOfColorBands > 1
  ca = mat2cell(Padd, blockVectorR, blockVectorC, numberOfColorBands);
else
  ca = mat2cell(Padd, blockVectorR, blockVectorC);
end
ca(e+1,:)=[];
ca(:,f+1)=[];
covneed=e*f;

rInteger = randperm(numFrames,covneed);
[x1,y1,z1] = size(ca{1});
scrambleOrder = randperm(x1*y1);


for ij=1:covneed
img=viddup{rInteger(ij)};
[roww, coll, plane]=size(img);

D = sltmtx(p);
crp=imcrop(img,[0,0,d,d]);

if(plane==3)
    dctv2(:,:,1)=D*double(crp(:,:,1))*D';
    dctv2(:,:,2)=D*double(crp(:,:,2))*D';
    dctv2(:,:,3)=D*double(crp(:,:,3))*D';
else
    dctv2=D*crp*D';
end

sec=double(ca{ij});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


redChannel = sec(:, :, 1);
greenChannel = sec(:, :, 2);
blueChannel = sec(:, :, 3);

redChannel = redChannel(scrambleOrder);
greenChannel = greenChannel(scrambleOrder);
blueChannel = blueChannel(scrambleOrder);

redChannel = reshape(redChannel, [x1, y1]);
greenChannel = reshape(greenChannel, [x1, y1]);
blueChannel = reshape(blueChannel, [x1, y1]);

randomized_image1 = cat(3, redChannel, greenChannel, blueChannel);
sec=randomized_image1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sec=sec/255;
for i=(d-s+1):d
    for j=(d-s+1):d
        if(plane==3)
            dctv2(i,j,1)=sec(i-(d-s),j-(d-s),1);
            dctv2(i,j,2)=sec(i-(d-s),j-(d-s),2);
            dctv2(i,j,3)=sec(i-(d-s),j-(d-s),3);
        else
            dctv2(i,j)=sec(i-(d-s),j-(d-s));
        end
        
    end
end
if(plane==3)
        dctv3(:,:,1)=(D')*double(dctv2(:,:,1))*(D);
        dctv3(:,:,2)=(D')*double(dctv2(:,:,2))*(D);
        dctv3(:,:,3)=(D')*double(dctv2(:,:,3))*(D);
else
        dctv3=D*dctv2*D';
end
temp=viddup{rInteger(ij)};
temp=double(temp);
clear i;
clear j;
for i=1:d
    for j=1:d
                temp(i,j,1)=dctv3(i,j,1);
                temp(i,j,2)=dctv3(i,j,2);
                temp(i,j,3)=dctv3(i,j,3);
    end
end
viddup{rInteger(ij)}=uint8(temp);
end

workingDir = 'C:\Users\aayua\Documents\MATLAB\';
outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out2'),'Uncompressed AVI');
outputVideo.FrameRate = 25;
% outputVideo.LosslessCompression=true;

open(outputVideo)
for ii = 1:length(viddup)
   imgi=viddup{ii};
   writeVideo(outputVideo,imgi)
end
close(outputVideo)
disp("done");
