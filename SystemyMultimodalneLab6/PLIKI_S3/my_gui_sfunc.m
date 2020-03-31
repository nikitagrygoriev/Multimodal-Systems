function [sys,x0,str,ts] = my_gui_sfunc(t,x,u,flag)
%
% Obsluga GUI (MATLAB Level 1 s-function)
% DEPENDENCIES:
% > int_gui1.m, int_gui1.fig, cursor-64.png
% CREATED: Jaromir Przybylo, R2015a, 27.10.2015
%

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts] = mdlInitializeSizes();

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,                                                
    sys = mdlUpdate(t,x,u); 

  %%%%%%%%%%
  % Output %
  %%%%%%%%%%
  case 3,                                                
    sys = mdlOutputs(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,                                                
    sys = []; % do nothing

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

%end dsfunc

%
%=======================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=======================================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes()

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;%size(A,1);
sizes.NumOutputs     = 0;%size(D,1);
sizes.NumInputs      = 2;%size(D,2);
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

x0  = ones(sizes.NumDiscStates,1);
str = [];
ts  = [-1 0]; 

% Create/open GUI
int_gui1();

% end mdlInitializeSizes

%
%=======================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=======================================================================
%
function sys = mdlUpdate(t,x,u)

sys = [];

% Obsluga GUI
fig = gcf;
if ishandle(fig)
    if (strcmp(get(fig,'Visible'),'on')&&strcmp(get(fig,'Name'),'int_gui1'))
        % {
        chnd = findobj(fig,'Tag','pushbutton1');
        %x = (u(1)+1)/2;y = (u(2)+1)/2;
        x = u(1);y = u(2);
        if x>1, x=1;end
        if x<0, x=0;end
        if y>1, y=1;end
        if y<0, y=0;end
        pos1=get(chnd,'Position');
        pos1(1)=x;pos1(2)=y;
        set(chnd, 'Position', pos1) ;
        % }
        
        %str = floor(u(1)); 
        %if num2str(str)
        %   set(chnd, 'String', str) ;
        %else
        %    set(chnd,'String','NA') ;
        %end
    end
end

%end mdlUpdate

%
%=======================================================================
% mdlOutputs
% Return the output vector for the S-function
%=======================================================================
%
function sys = mdlOutputs(t,x,u,A,C,D)

sys = [];

%end mdlOutputs

