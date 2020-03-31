function varargout = int_gui1(varargin)
% INT_GUI1 MATLAB code for int_gui1.fig
%      INT_GUI1, by itself, creates a new INT_GUI1 or raises the existing
%      singleton*.
%
%      H = INT_GUI1 returns the handle to a new INT_GUI1 or the handle to
%      the existing singleton*.
%
%      INT_GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INT_GUI1.M with the given input arguments.
%
%      INT_GUI1('Property','Value',...) creates a new INT_GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before int_gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to int_gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help int_gui1

% Last Modified by GUIDE v2.5 27-Oct-2015 12:32:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @int_gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @int_gui1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before int_gui1 is made visible.
function int_gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to int_gui1 (see VARARGIN)

% Choose default command line output for int_gui1
handles.output = hObject;

% Konfiguracja GUI
set(hObject,'Units','pixels');
pos1=get(hObject,'Position');

% Ustawienie ikony kursora dla przycisku
iconsize = 24;%wielkosc ikony
im0=imread('cursor-64.png');
im0=single(imresize(im0,[iconsize iconsize]))/255;
im=zeros(size(im0,1),size(im0,2),3);
im(:,:,1)=im0;im(:,:,2)=im0;im(:,:,3)=im0;
im(im==0)=0.94;
set(handles.pushbutton1,'Units','pixels');
set(handles.pushbutton1,'Position',[(pos1(3)/2)-iconsize (pos1(3)/2)-iconsize iconsize iconsize]);
set(handles.pushbutton1,'CData',im);
set(hObject,'Units','normalized');
set(handles.pushbutton1,'Units','normalized');
set(handles.pushbutton1,'String','');
%set(handles.pushbutton1,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes int_gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = int_gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
