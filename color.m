function [thecolors] = color(edgelist,K)
  numVertex = numel(unique(edgelist));
  thecolors = zeros(numVertex, 1);
  numVariable = numVertex*K;
  numEdge = size(edgelist, 1);
  numConstraint = numEdge*K;
  numConstraintEq = numVertex;

  A = zeros(numConstraint,numVariable);
  Aeq = zeros(numConstraintEq,numVariable);
  
  % C1: each vertex has exactly one color
  rowIndexEq = 1;
  for i = 1:numVertex
    for j = 1:K
      index = ijToIndex(i,j,K);
      Aeq(rowIndexEq,index) = 1;
    end
    rowIndexEq = rowIndexEq+1; 
  end

  % C2: Adjacent nodes cannot have the same color
  rowIndex = 1;
  for row = 1:numEdge
    for j = 1:K
      vertexA = edgelist(row,1);
      vertexB = edgelist(row,2);
      indexA = ijToIndex(vertexA,j,K);
      indexB = ijToIndex(vertexB,j,K);
      A(rowIndex, indexA) = 1;
      A(rowIndex, indexB) = 1;
      rowIndex = rowIndex+1;
    end
  end

  % Solve Binary Integer Programming
%   f = ones(numVariable,1);
%   intcon = 1:numVariable;
%   b = ones(numConstraint,1);
%   beq = ones(numConstraintEq,1);
%   lb = zeros(numVariable,1);
%   ub = ones(numVariable,1);
%   colors = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
  
  f = ones(numVariable,1);
  b = ones(numConstraint,1);
  beq = ones(numConstraintEq,1);
  model.obj = f;
  model.lb = zeros(numVariable,1);
  model.ub = ones(numVariable,1);
  model.vtype = repmat('B', numVariable,1);
  model.A =[sparse(A);sparse(Aeq)];
  model.rhs = full([b(:);beq(:)]);
  model.sense = [repmat('<',numConstraint,1); repmat('=',numConstraintEq,1)];
  params.outputflag = 0;
  colors = gurobi(model,params);
  
  % Quit if no coloring found
  if colors.status == "INFEASIBLE"
    disp("No feasible solution");
    return;
  end

  % Convert to readable thecolor
  for index = 1:numVariable
    if colors.x(index,1) == 1
      [i,j] = IndexToij(index,K);
      thecolors(i) = j;
    end
  end

end

% Convert i,j into position in numVariable*1 vector
function [index] = ijToIndex(i,j,K)
  index = (i-1)*K + j;
end

% Convert position in numVariable*1 vector into i,j 
function [i,j] = IndexToij(index,K)
  i = fix((index+K-1)/K);
  j = rem((index+K-1),K)+1;
end
