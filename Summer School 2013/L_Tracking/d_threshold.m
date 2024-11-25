% Threshold
function [IT]=d_threshold(I,T1,T2)

IT=and(I>T1,I<T2);

% [Y X]=size(I);
% IT=uint8(zeros(Y,X));
% for y=1:Y
%     for x=1:X
%         if and( I(y,x)>T1, I(y,x)<T2 )
%             IT(y,x)=1;
%         end
%     end
% end