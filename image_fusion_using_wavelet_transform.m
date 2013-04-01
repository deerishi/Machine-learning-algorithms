
function varargout = fusion(varargin)
% FUSION M-file for fusion.fig
%      FUSION, by itself, creates a new FUSION or raises the existing
%      singleton*.
%
%      H = FUSION returns the handle to a new FUSION or the handle to
%      the existing singleton*.
%
%      FUSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUSION.M with the given input arguments.
%
%      FUSION('Property','Value',...) creates a new FUSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fusion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fusion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fusion

% Last Modified by GUIDE v2.5 23-Jul-2012 14:41:36

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fusion_OpeningFcn, ...
                   'gui_OutputFcn',  @fusion_OutputFcn, ...
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


% --- Executes just before fusion is made visible.
function fusion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fusion (see VARARGIN)
% Choose default command line output for fusion
handles.output = hObject;
%set([f,pushbutton1,pushbutton2,pushbutton3,axes1,axes2,axes3],'Units','normalized');
%set(f,'Name','Image fusion Using Wavelet Transform');
handles.val=1;
handles.slider=3;
i=imread('logo.jpg');
j=imread('logo2.jpg');
k=imread('im.jpg');
m=imread('logo3.jpg');
imshow(m,'Parent',handles.axes13);
axis(handles.axes13,'off');
imshow(k,'Parent',handles.axes12);
axis(handles.axes12,'off');
imshow(i,'Parent',handles.axes10);
axis(handles.axes10,'off');
imshow(j,'Parent',handles.axes11);
axis(handles.axes11,'off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fusion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fusion_OutputFcn(hObject, eventdata, handles) 
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
pan=uigetfile();
l1=length(pan);
if(pan(l1)=='f' | pan(l1)=='F')
    j=geotiffread(pan);
    [m n p]=size(j);
    if(p==1)
    handles.x=j;
    imshow(handles.x,'Parent',handles.axes1);
    title(handles.axes1,'panchromatic image');
    else
        errordlg('Please load a single band image.','Wrong Input','modal');
        uicontrol(hObject);
        return
    end
else
    j=imread(pan);
    [m n p]=size(j);
    if(p==1)
    handles.x=j;
    imshow(handles.x,'Parent',handles.axes1);
    title(handles.axes1,'panchromatic image');
    else
        errordlg('Please load a single band image.','Wrong Input','modal');
        uicontrol(hObject);
        return
    end
    handles.x=j;
    imshow(j,'Parent',handles.axes1);
        title(handles.axes1,'panchromatic image');

end
guidata(hObject, handles);


           
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mul=uigetfile();
l1=length(mul);
if(mul(l1)=='f' | mul(l1)=='F')
    i=geotiffread(mul);
    handles.yy=i;
    [m n p]=size(i);
    if(p==3)
    imshow(i,'Parent',handles.axes2);
        title(handles.axes2,'Multi-sprectral image');
    else
        errordlg('Please load a 3 band image.','Wrong Input','modal');
        uicontrol(hObject);
        return
    end
else
    i=imread(mul);
    [m n p]=size(i);
    if(p==3)
    handles.yy=i;
    imshow(i,'Parent',handles.axes2);
    title(handles.axes2,'Multi-sprectral image');
    else
        errordlg('Please load a 3 band image.','Wrong Input','modal');
        uicontrol(hObject);
        return
    end

end
guidata(hObject, handles);
  


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isnan(handles.val)==0)
    o=handles.val;
    o
else
    o=1
end
x=handles.x;
yy=handles.yy;

[m,n]=size(x);
slider_value=handles.slider;
%sharpening filter
u=fspecial('laplacian',0);
u=u*(-1);
g=imfilter(x,u,'replicate');
x=x+g;
[mm nn]=size(x);

yy3=yy;
yy3(:,:,1)=yy(:,:,3);
yy3(:,:,3)=yy(:,:,1);

j1=yy(:,:,1);
j1=imresize(j1,[mm nn]);

j2=yy(:,:,2);
j2=imresize(j2,[mm nn]);

j3=yy(:,:,3);
j3=imresize(j3,[mm nn]);
handles.j1=j1;
handles.j2=j2;
handles.j3=j3;
y2=yy  ;

y2=rgb2hsv(y2);
yy34=y2;
y2(:,:,1)=yy34(:,:,3);
y2(:,:,3)=yy34(:,:,1);

sy2=size(y2)
y=y2(:,:,3);
[m n]=size(x);
y=imresize(y,[m n]);
[m,n]=size(y);

s = sin(20.*linspace(0,pi,1000)) + 0.5.*rand(1,1000);
%db4 is the name of the wavelet used for decomposition of images
[cA,cD] = dwt(s,'db4');
for i=1:o
    
        %decomposition of the image x
        [ca_x,ch_x,cv_x,cd_x]=dwt2(x,'db4'); 
        %decomposition of the image y
        [ca_y,ch_y,cv_y,cd_y]=dwt2(y,'db4');
        if(i~=o)
        x=ca_x;
        y=ca_y;
        end
        
end;   

%now we calculate the gradients of the image x
[fx_ch_x,fy_ch_x]= gradient(ch_x);
[fx_cv_x,fy_cv_x]= gradient(cv_x);
[fx_cd_x,fy_cd_x]= gradient(cd_x);

%now we calculate the gradients of the image y
[fx_ch_y,fy_ch_y]= gradient(ch_y);
[fx_cv_y,fy_cv_y]= gradient(cv_y);
[fx_cd_y,fy_cd_y]= gradient(cd_y);
[m,n]=size(ch_y);% since all ch,cd,cv ,ca have the same sizes
%the magnitude of the gradient of image y
[m,n]=size(fx_ch_y);
for i=1:m
    for j=1:n
        
            grad_ch_y(i,j)=sqrt((fx_ch_y(i,j).^2)+(fy_ch_y(i,j).^2));
            grad_cv_y(i,j)=sqrt((fx_cv_y(i,j).^2)+(fy_cv_y(i,j).^2));
            grad_cd_y(i,j)=sqrt((fx_cd_y(i,j).^2)+(+fy_cd_y(i,j).^2));
    end
end;
%the magnitude of the gradient of image x
[m,n]=size(fx_ch_x);
for i=1:m
    for j=1:n
            grad_ch_x(i,j)=sqrt((fx_ch_x(i,j).^2)+(fy_ch_x(i,j).^2));
            grad_cv_x(i,j)=sqrt((fx_cv_x(i,j).^2)+(fy_cv_x(i,j).^2));
            grad_cd_x(i,j)=sqrt((fx_cd_x(i,j).^2)+(fy_cd_x(i,j).^2));
    end
end;
max_gx=min(min(grad_ch_x));
max_gy=max(min(grad_ch_y));
%fusion of high frequency or detail coefficients
[m,n]=size(grad_ch_y);

%code for fusion of images
for i=1:m
      for j=1:n
            if(grad_ch_x(i,j)>grad_ch_y(i,j))
                fus_ch(i,j)=ch_x(i,j);
                
              %  sprintf('grad_ch_x(%d,%d)=%f and grad_ch_y(%d,%d)=%f\n',i,j,grad_ch_x(i,j),i,j,grad_ch_y(i,j));
            else
                fus_ch(i,j)=ch_y(i,j);
                
            end
               if(grad_cv_x(i,j)>grad_cv_y(i,j))
                fus_cv(i,j)=cv_x(i,j);
                
            else
                fus_cv(i,j)=cv_y(i,j);
              
            end
            if(grad_cd_x(i,j)>grad_cd_y(i,j))
                fus_cd(i,j)=cd_x(i,j);
              
            else
                fus_cd(i,j)=cd_y(i,j);
               
            end
            %fusion of low frequency or detail coefficients
            fus_ca(i,j)=8.*(ca_y(i,j)) + (slider_value).*(ca_x(i,j));
      end
end;


%now taking the inverse 2 dimensional discrete wavelet transform
fused_image=idwt2(fus_ca,fus_ch,fus_cv,fus_cd,'db4');
maxfus=max(max(fused_image));
%size_y2=size(y2(:,:,3))
size_fused_image=size(fused_image);
fused_image=(fused_image/maxfus);
%figure,imshow(fused_image,[]);
%title('fused_image');

fused_image=imresize(fused_image,[mm nn]);
g=fspecial('average',10);
h=imfilter(fused_image,g,'replicate');
l=fused_image-h;
fused_image=fused_image+l;
fused_image=imadjust(fused_image,[0 1],[0 1]);
y3=y2(:,:,1);
std_just_fused=std2(fused_image)
y3=fused_image;
y3=imresize(y3,[mm nn]);
y4=y2(:,:,2);
y4=imresize(y4,[mm nn]);
%y4=imadjust(y4);
y5=y2(:,:,3);

y5=imresize(y5,[mm nn]);
%y5=imadjust(y5);
f(:,:,1)=y5;
f(:,:,2)=y4;
f(:,:,3)=y3;
f=imresize(f,[mm nn]);
%figure,imshow(f,[]);
%title('final fused image in HSV');
f=hsv2rgb(f);
f2=f;
f(:,:,1)=f2(:,:,3);
f(:,:,3)=f2(:,:,1);

f2(:,:,1)=f(:,:,3);
f2(:,:,3)=f(:,:,1);
handles.final=f2;
imshow(f2,[],'Parent',handles.axes3);
title(handles.axes3,'final fused image in RGB');
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
user_entry = str2double(get(hObject,'string'));
if (isnan(user_entry) | user_entry<=0)
errordlg('You must enter a numeric value greater than 0.Any decimal value enetred will converted to the smallest following integer.','Bad Input','modal')
uicontrol(hObject)
return
end
user_entry=ceil(user_entry);
handles.val=user_entry;
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject);
imshow('im.jpg');
% Hint: place code in OpeningFcn to populate axes5


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Min')
    imshow(handles.yy,'Parent',handles.axes2);
else
    i=handles.yy;
    
    i(:,:,1)=handles.yy(:,:,3);
    i(:,:,3)=handles.yy(:,:,1);
    imshow(i,'Parent',handles.axes2);
end
    
% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Min')
    imshow(handles.final,'Parent',handles.axes3);
else
    i=handles.final;
  
    i(:,:,1)=handles.final(:,:,3);
    i(:,:,3)=handles.final(:,:,1);
    imshow(i,'Parent',handles.axes3);
end
% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function new_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uigetfile();


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.slider = get(hObject,'Value');
slider=handles.slider
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=handles.x;
f2=handles.final;
yy=handles.yy;
index_selected = get(hObject,'Value');
list = get(hObject,'String');
item_selected = list{index_selected}; % Convert from cell array to string
switch (item_selected)
    case 'Correlation coefficents matrix'
        f2=handles.final;
j1=handles.j1;
j2=handles.j2;
j3=handles.j3;

r_r=corr2(double(f2(:,:,1)),double(j1))
%correlation coefficient of g_g
g_g=corr2(double(f2(:,:,2)),double(j2))
%correlation coefficient of b_r
b_r=corr2(double(f2(:,:,3)),double(j1))
%correlation coefficient of b_g
b_g=corr2(double(f2(:,:,3)),double(j2))
%correlation coefficient of r_g
r_b=corr2(double(f2(:,:,1)),double(j3))
%correlation coefficient of g_b
g_b=corr2(double(f2(:,:,2)),double(j3))
%correlation coefficient of r_b
r_g=corr2(double(f2(:,:,1)),double(j2))
%correlation coefficient of g_b
g_r=corr2(double(f2(:,:,2)),double(j1))
%correlation coefficient of b_b
b_b=corr2(double(f2(:,:,3)),double(j3))
dat=[r_r,r_g,r_b;g_r,g_g,g_b;b_r,b_g,b_b];
f = figure('Position',[200 200 400 150]);
cnames = {'R','G','B'};
rnames = {'R','G','B'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 360 100]);
        set(f,'Units','normalized');
        set(f,'Name','Correlation coefficients matrix');
        % Move the table to the center of the screen.
        
    case 'Entropy'
        h1=entropy(handles.x);
        r1=entropy(handles.yy(:,:,1));
        r2=entropy(handles.yy(:,:,2));
        r3=entropy(handles.yy(:,:,3));
        f2=handles.final;
        e1=entropy(f2(:,:,1));
        e2=entropy(f2(:,:,2));
        e3=entropy(f2(:,:,3));
        dat=[h1;;r1;r2;r3;;e1;e2;e3];
        f = figure('Position',[200 200 400 150]);
cnames = {'Entropy values'};
rnames = {'Pan',' ','Multi-sprectral',' ',' Final fused'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 360 100]);
        set(f,'Units','normalized');
        set(f,'Name','Entropy values');
        % Move the table to the center of the screen.
    
    case 'Standard deviation'
        std_pan=std2(x/255);
        stdms1=std2(yy(:,:,1)/255);
        stdms2=std2(yy(:,:,2)/255);
        stdms3=std2(yy(:,:,3)/255);
        stdfus1=std2(f2(:,:,1));
        stdfus2=std2(f2(:,:,2));
        stdfus3=std2(f2(:,:,3));
        dat=[std_pan;stdms1;stdms2;stdms3;stdfus1;stdfus2;stdfus3];
          f = figure('Position',[200 200 400 150]);
cnames = {'Standard deviation values'};
rnames = {'Pan',' ','Multi-sprectral',' ',' Final fused'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 360 100]);
        set(f,'Units','normalized');
        set(f,'Name','Entropy values');
        % Move the table to the center of the screen.
      
    case 'Mean'
        mm1=mean2(f2(:,:,1));
        mm2=mean2(f2(:,:,2));
        mm3=mean2(f2(:,:,3));
        mean_pan=mean2(x/255);
        m1=mean2(yy(:,:,1)/255);
        m2=mean2(yy(:,:,2)/255);
        m3=mean2(yy(:,:,3)/255);
        dat=[mean_pan;m1;m2;m3;mm1;mm2;mm3];
        f = figure('Position',[200 200 400 150]);
cnames = {'Mean values'};
rnames = {'Pan',' ','Multi-sprectral',' ',' Final fused'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 360 100]);
        set(f,'Units','normalized');
        set(f,'Name','Mean values');
        % Move the table to the center of the screen.
      
    case 'Average gradient'
        [m,n]=size(x);
        y2=rgb2hsv(yy);
        y=y2(:,:,3);
        y=imresize(y,[m,n]);
        f3=rgb2hsv(f2);
        y4=f3(:,:,3);
        %calculating the gradient
        [gx,gy]=gradient(double(x));
        [gx2,gy2]=gradient(y);
        [gx3,gy3]=gradient(y4);
         g=0;
         g2=0;
         g3=0;
        %for calculating the average gradient of the images
        for i=1:m-1
            for j=1:n-1
               g=g+sqrt((gx(i,j).^2)+(gy(i,j).^2));
               g2=g2+sqrt((gx2(i,j).^2)+(gy2(i,j).^2));
               g3=g3+sqrt((gx3(i,j).^2)+(gy3(i,j).^2));
            end
        end;
        y_gradient=g2/((m-1)*(n-1));
        x_gradient=g/((m-1)*(n-1));
        final_gradient=g/((m-1)*(n-1));
        dat=[x_gradient;y_gradient;final_gradient];
           f = figure('Position',[500 200 400 150]);
cnames = {'Average gradient'};
rnames = {'Pan','Multi-sprectral',' Final fused'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 360 100]);
        set(f,'Units','normalized');
        set(f,'Name','Average gradient');
        % Move the table to the center of the screen.
        
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes1,'reset');
set(handles.axes1,'Visible','off');
cla(handles.axes2,'reset');
set(handles.axes2,'Visible','off');
cla(handles.axes3,'reset');
set(handles.axes3,'Visible','off');
set(findobj('style','edit'), 'String', {''});
set(findobj('style','listbox'), 'Min', 0, 'Max', 2 ,'Value', [], 'ListBoxTop',1);
guidata(hObject, handles);
