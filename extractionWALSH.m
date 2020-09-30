vid2=VideoReader('C:\Users\aayua\Documents\MATLAB\shuttle_out2.avi');
  numFrames = vid2.NumberOfFrames;
  n=numFrames;
for io=1:covneed
img2=read(vid2,rInteger(io));
[roww, coll, plane]=size(img2);
    
D = walsh(d);
crp2=imcrop(img2,[0,0,d,d]);

if(plane==3)
    dctv25(:,:,1)=D*im2double(crp2(:,:,1))*D';
    dctv25(:,:,2)=D*im2double(crp2(:,:,2))*D';
    dctv25(:,:,3)=D*im2double(crp2(:,:,3))*D';
else
    dctv25=D*crp2*D';
end

for i=(d-s+1):d
    for j=(d-s+1):d
        if(plane==3)
            sec2(i-(d-s),j-(d-s),1)=dctv25(i,j,1);
            sec2(i-(d-s),j-(d-s),2)=dctv25(i,j,2);
            sec2(i-(d-s),j-(d-s),3)=dctv25(i,j,3);
        else
            sec2(i-(d-s),j-(d-s))=dctv25(i,j);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
[x1 y1 z1] = size(sec2);
redChannel = sec2(:, :, 1);
greenChannel = sec2(:, :, 2);
blueChannel = sec2(:, :, 3);

recoverOrder = zeros([x1*y1], 2);
recoverOrder(:, 1) = 1 : (x1*y1);
recoverOrder(:, 2) = scrambleOrder;
% Sort this to find out where each scrambled location needs to be sent to.
newOrder = sortrows(recoverOrder, 2);
% Extract just column 1, which is the order we need.
newOrder = newOrder(:,1);
% Unscramble according to the recoverOrder order.
redChannel = redChannel(newOrder);
greenChannel = greenChannel(newOrder);
blueChannel = blueChannel(newOrder);
% Reshape into a 2D image
redChannel = reshape(redChannel, [x1, y1]);
greenChannel = reshape(greenChannel, [x1, y1]);
blueChannel = reshape(blueChannel, [x1, y1]);

% Recombine separate color channels into a single, true color RGB image.
sec2 = cat(3, redChannel, greenChannel, blueChannel);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmsg{io}=sec2*255;

end


At = cat(1,rmsg{1},rmsg{2});
At = cat(1,At,rmsg{3});
At = cat(1,At,rmsg{4});
Bt = cat(1,rmsg{5},rmsg{6});
Bt = cat(1,Bt,rmsg{7});
Bt = cat(1,Bt,rmsg{8});
Ct = cat(1,rmsg{9},rmsg{10});
Ct = cat(1,Ct,rmsg{11});
Ct = cat(1,Ct,rmsg{12});
Dt = cat(1,rmsg{13},rmsg{14});
Dt = cat(1,Dt,rmsg{15});
Dt = cat(1,Dt,rmsg{16});
Et = cat(1,rmsg{17},rmsg{18});
Et = cat(1,Et,rmsg{19});
Et = cat(1,Et,rmsg{20});
Ft = cat(1,rmsg{21},rmsg{22});
Ft = cat(1,Ft,rmsg{23});
Ft = cat(1,Ft,rmsg{24});

catmsg=cat(2,At,Bt);
catmsg=cat(2,catmsg,Ct);
catmsg=cat(2,catmsg,Dt);
catmsg=cat(2,catmsg,Et);
catmsg=cat(2,catmsg,Ft);

imwrite(catmsg,fullfile(['C:\Users\aayua\Documents\MATLAB\extractedmessage1WALSH.jpg']));
% imwrite(catmsg,fullfile(['C:\Users\aayua\Documents\MATLAB\extractedmessage2.png']));
