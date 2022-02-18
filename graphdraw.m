function [Adjacency,Incidence,edgelist]=graphdraw()

% [Adjacency,Incidence,Adjlist] = graphdraw opens a plotting window to make a graph
% left click for vertices, right click for each edge endpoint, 
% middle click to exit with adjacency matrix, incidence matrix, edgelist  
%
% simple graphs, pre alpha jan31 2021

close; hold on; axis([0 100 0 80])
go=1; vertices=[]; A=[]; sizeA=0; Incidence=[];ned=0;

while go==1
   [x,y,button]=ginput(1);
   if button==2
       go=0;
   elseif button==1
       vertices=[vertices; x y];
       plot(x,y,'ro')
       A=[A zeros(sizeA,1); zeros(1,sizeA+1)];
       sizeA=sizeA+1;
   elseif button==3
       [z,w]=ginput(1);
       [~,e1]=min(abs(vertices(:,1)+vertices(:,2)*1i-(x+y*1i)));
       [~,e2]=min(abs(vertices(:,1)+vertices(:,2)*1i-(z+w*1i)));
       A(e1,e2)=1;
       plot([vertices(e1,1),vertices(e2,1)],[vertices(e1,2),vertices(e2,2)],'b')
       ned=ned+1;
       Incidence(e1,ned)=1;
       Incidence(e2,ned)=1;
   end
end
Adjacency=A+A';
edgelist=[];
%numedges=sum(sum(A));
%Incidence=zeros(sizeA,numedges);
%nee=0;
for j=1:sizeA
    for k=(j+1):sizeA
        if Adjacency(j,k)==1
            edgelist=[edgelist; j k];
            %nee=nee+1;
            %Incidence(j,nee)=1;
            %Incidence(k,nee)=1;
        end
    end
end
            


