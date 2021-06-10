
net_pitch = newrb(xt,yt);
 
b1 = ones(length(c),1).*b;
w1 = c';
b2 = 0;


% c_sim = [c(1) c];
% b_square = b^2;

net_pitch.layers{1}.size = length(b1);
net_pitch.b{1} = b1;
net_pitch.iw{1,1} = w1;
net_pitch.b{2} = b2;
net_pitch.lw{2,1} = w2;

% y01 = net_pitch(xt);
DT = 0.00125;

gensim(net_pitch,DT);