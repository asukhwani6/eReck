function [x,y]=crackgTest(bs,s)
%CRACKG Gives geometry data for the crackg PDE model
%
%   NE=CRACKG gives the number of boundary segment
%
%   D=CRACKG(BS) gives a matrix with one column for each boundary segment
%   specified in BS.
%   Row 1 contains the start parameter value.
%   Row 2 contains the end parameter value.
%   Row 3 contains the number of the left hand region.
%   Row 4 contains the number of the right hand region.
%
%   [X,Y]=CRACKG(BS,S) gives coordinates of boundary points. BS specifies the
%   boundary segments and S the corresponding parameter values. BS may be
%   a scalar.

% Copyright 1994-2017 The MathWorks, Inc.

coverThickness = 0.001;
coverWidth = 0.38/2; % Half Symmetry
channelWidth = 0.01;
channelHeight = 0.01;
channelMaterialThickness = 0.003;

nbs=10;
x1 = 0;
x5 = coverWidth;
x4 = x5 - channelMaterialThickness;
x3 = x4 - channelWidth;
x2 = x3 - channelMaterialThickness;

y1 = 0;
y2 = y1 + coverThickness;
y3 = y2 + channelHeight;
y4 = y3 + channelMaterialThickness;

if nargin==0
  x=nbs; % number of boundary segments
  return
end

d=[
  0 0 0 0 0 0 0 0 0 0 % start parameter value
  1 1 1 1 1 1 1 1 1 1 % end parameter value
  0 0 1 1 1 0 0 1 0 0 % left hand region
  1 1 0 0 0 1 1 0 1 1 % right hand region
];

bs1=bs(:)';

if find(bs1<1 | bs1>nbs)
  error(message('pde:crackg:InvalidBs'))
end

if nargin==1
  x=d(:,bs1);
  return
end

x=zeros(size(s));
y=zeros(size(s));
[m,n]=size(bs);
if m==1 && n==1
  bs=bs*ones(size(s)); % expand bs
elseif m~=size(s,1) || n~=size(s,2)
  error(message('pde:crackg:SizeBs'));
end

if ~isempty(s)

% boundary segment 1
ii=find(bs==1);
if ~isempty(ii)
x(ii)=interp1([d(1,1),d(2,1)],[x5 x5],s(ii),'linear','extrap');
y(ii)=interp1([d(1,1),d(2,1)],[y4 y1],s(ii),'linear','extrap');
end

% boundary segment 2
ii=find(bs==2);
if ~isempty(ii)
x(ii)=interp1([d(1,2),d(2,2)],[x5 x1],s(ii),'linear','extrap');
y(ii)=interp1([d(1,2),d(2,2)],[y1 y1],s(ii),'linear','extrap');
end

% boundary segment 3
ii=find(bs==3);
if ~isempty(ii)
x(ii)=interp1([d(1,3),d(2,3)],[x4 x4],s(ii),'linear','extrap');
y(ii)=interp1([d(1,3),d(2,3)],[y3 y2],s(ii),'linear','extrap');
end

% boundary segment 4
ii=find(bs==4);
if ~isempty(ii)
x(ii)=interp1([d(1,4),d(2,4)],[x4 x3],s(ii),'linear','extrap');
y(ii)=interp1([d(1,4),d(2,4)],[y2 y2],s(ii),'linear','extrap');
end

% boundary segment 5
ii=find(bs==5);
if ~isempty(ii)
x(ii)=interp1([d(1,5),d(2,5)],[x3 x4],s(ii),'linear','extrap');
y(ii)=interp1([d(1,5),d(2,5)],[y3 y3],s(ii),'linear','extrap');
end

% boundary segment 6
ii=find(bs==6);
if ~isempty(ii)
x(ii)=interp1([d(1,6),d(2,6)],[x1 x1],s(ii),'linear','extrap');
y(ii)=interp1([d(1,6),d(2,6)],[y1 y2],s(ii),'linear','extrap');
end

% boundary segment 7
ii=find(bs==7);
if ~isempty(ii)
x(ii)=interp1([d(1,7),d(2,7)],[x2 x5],s(ii),'linear','extrap');
y(ii)=interp1([d(1,7),d(2,7)],[y4 y4],s(ii),'linear','extrap');
end

% boundary segment 8
ii=find(bs==8);
if ~isempty(ii)
x(ii)=interp1([d(1,8),d(2,8)],[x3 x3],s(ii),'linear','extrap');
y(ii)=interp1([d(1,8),d(2,8)],[y2 y3],s(ii),'linear','extrap');
end

% boundary segment 9
ii=find(bs==9);
if ~isempty(ii)
x(ii)=interp1([d(1,8),d(2,8)],[x2 x2],s(ii),'linear','extrap');
y(ii)=interp1([d(1,8),d(2,8)],[y2 y4],s(ii),'linear','extrap');
end

% boundary segment 10
ii=find(bs==10);
if ~isempty(ii)
x(ii)=interp1([d(1,8),d(2,8)],[x1 x2],s(ii),'linear','extrap');
y(ii)=interp1([d(1,8),d(2,8)],[y2 y2],s(ii),'linear','extrap');
end

end

% LocalWords:  Bs
