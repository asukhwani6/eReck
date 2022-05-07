% % input torque and motor speed
% % output efficiency

% fill = zeros(122-75, 122, 'uint8');
% 
% First = imread('outer_ring.png');
% FirstDown = First(1:8:end,1:8:end,1:3:end); 
% FirstDown(FirstDown == 255)=0;
% FirstDown(FirstDown > 0)=88;
% FirstDown = [FirstDown; fill];
% 
% Second = imread('second_ring.png');
% SecondDown = Second(1:8:end,1:8:end,1:3:end); 
% SecondDown(SecondDown == 255)=0;
% SecondDown(SecondDown >0)=92;
% SecondDown = [SecondDown; fill];
% 
% 
% Third = imread('third_ring.png');
% ThirdDown = Third(1:8:end,1:8:end,1:3:end); 
% ThirdDown(ThirdDown == 255)=0;
% ThirdDown(ThirdDown >0)=94;
% ThirdDown = [ThirdDown; fill];
% 
% 
% Fourth = imread('fourth_ring.png');
% FourthDown = Fourth(1:8:end,1:8:end,1:3:end); 
% FourthDown(FourthDown == 255)=0;
% FourthDown(FourthDown >0)=95;
% FourthDown = [FourthDown; fill];
% 
% 
% Inner = imread('inner_ring.png');
% InnerDown = Inner(1:8:end,1:8:end,1:3:end); 
% InnerDown(InnerDown == 255)=0;
% InnerDown(InnerDown >0)=96;
% InnerDown = [InnerDown; fill];
% 
% Total = InnerDown+SecondDown+ThirdDown+FourthDown+FirstDown;
efficiency = map(5400, 112)
