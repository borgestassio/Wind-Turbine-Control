 %It is imperative (for a good estimation) that all universe of data be
 %used to training the network. However, as it's almost impossible to
 %perform such a task, especially if we consider a real-time application,
 %we aim to improve the network 'on the go', i.e. Real-Time, by updating
 %its weights 
 %Note: So far this updating aims to solve the problem of bias deviation,
 %which means, that this won't increase the perform on the non-linear
 %response of the RBF, but will allow the RBF NN to keep a close prediction
 %when the function changes to a new DC level.
 
 %Also, it is important to keep in mind the state transitions are too fast and
 %they occur less frequently then steady states, which means that this RBF
 %won't recognize them and its prediction will be poor, may be because we
 %use k-means, and the transistions are considered 'noise' by this kind of
 %algorithm;
%  
% update = 2000;
% 
% c_train = c;
% w2_train = w2;
% 
% p = k;
% 
% while(p+update <length(xt))
%     
%     c_temp = [];
%     R_temp = [];
%     w_temp = [];
%     a1_temp = [];
%     e_temp = [];
%     e_rt = [];
%     y_rt = [];
%     a1_rt = [];
%     
%     a1_rt = radbas(dist(c',xt(p:p+update))*b);
%     y_rt = w2*a1_rt;
%     e_rt = mse(yt(p:p+update)-y_rt);
%     if(e_rt > 1)
%         for v=1:update
%             
%             [activation,index] = min(a1_rt(:,v));
%             if(activation<0.01)
%                 R_temp = [R_temp x(p+v)];
%                 c_temp = mean(R_temp);
%             end
%             if(sum(ismember(c,c_temp)))
%                 break;
%             end
%         end
%         if(~isnan(c_temp) & ~sum(ismember(c,c_temp)))
%             %         c = [c c_temp];
%             a1_temp = radbas(dist(c_temp',xt(p:p+update))*b);
%             w_temp = (yt(p:p+update)-y_rt)/a1_temp;
%             
%             y_temp = w_temp*a1_temp;
%             e_temp = mse(yt(p:p+update)-y_temp);
%             
%             if (((e_rt - e_temp)/e_rt) >0.5)
%                 c = [c c_temp];
%                 w2 = [w2 w_temp];
%             end
%         elseif (length(c) > length(c_train))
%             c_temp = c(end);
%             a1_temp = radbas(dist(c_temp',xt(p:p+update))*b);
%             w_temp = (yt(p:p+update)-y_rt)/a1_temp;
%             
%             y_temp = w_temp*a1_temp;
%             e_temp = mse(yt(p:p+update)-y_temp);
%             if (((e_rt - e_temp)/e_rt) >0.9)
%                 w2 = w_temp;
%             end
%         end
%     end
%     p = p+update;
%     
% end
%  
% a1_new =  radbas(dist(c',xt(k:t))*b);
% ynn_new = w2*a1_new;
% y_total = [ynn(1:k-1) ynn_new];
% plot(y_total)
%  
%  
%  
 