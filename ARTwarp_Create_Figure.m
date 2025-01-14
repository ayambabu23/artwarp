function ARTwarp_Create_Figure

global NET DATA

h0 = findobj('Tag','ARTwarp'); %activate the ARTwarp window and clear the figure (clf)
clf 
numCols = round(NET.maxNumCategories^0.5);
numRows = numCols+1;

rowHeight = (0.98 - 0.01*numRows)/numRows;
colWidth = (0.98 - 0.01*numCols)/(numCols+1);
%generate the same menu items as in ARTwarp.m
h1 = uimenu('Parent',h0, ...
    'Label','File', ...
    'Tag','uimenu1');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Load_Data', ...
    'Accelerator','o', ...
    'Label','Load Frequency Contours', ...
    'Tag','Fileuimenu1');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Load_Net', ...
    'Accelerator','n', ...
    'Label','Load Categorisation', ...
    'Tag','Fileuimenu2');
h1 = uimenu('Parent',h0, ...
    'Label','Analyse', ...
    'Tag','uimenu1');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Get_Parameters', ...
    'Accelerator','r', ...
    'Label','Run Categorisation', ...
    'Enable','off', ...
    'Tag','Runmenu');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Plot_Net', ...
    'Accelerator','p', ...
    'Label','Plot Categorisation', ...
    'Enable','off', ...
    'Tag','Plotmenu');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Plot_Net2', ...
    'Accelerator','p', ...
    'Label','Plot Categorisation 2', ...
    'Enable','off', ...
    'Tag','Plot2menu');
%draw the contour and text in the top row of the figure
    %'Parent' is within which figure the axes belong (h0 = ARTwarp figure)
    %'Units' 'normalized' to the containing figure where 0,0 is bottom left
    %corner and 1,1 is upper right corner
    %'CameraUpVector' assigns which way is up in terms of x y z (y = 1 and
    %so is "up"
    %'CameraUpVectorMode' automatically set to 'manual' if CameraUpVector
    %is specified to override default values
    %'Position' position of axes specified by coordinates of [Left Bottom
    %Width Height] (Left = 0.01 or far left, Bottom = (rowHeight plus a
    %buffer of 0.01) * (numRows-1) or at the bottom of the top row)
    %'Tag' is the graph's name so it can be referred to by commands such as
    %'findobj'
    %'XTick' are tick mark locations on the x-axis (empty set means remove
    %tick marks)
    %'YTick' are tick mark locations on the y-axis
h1 = axes('Parent',h0, ...
    'Units','normalized', ...
    'CameraUpVector',[0 1 0], ...
    'CameraUpVectorMode','manual', ...
    'Position',[0.01 (rowHeight+0.01)*(numRows-1) + 0.01 colWidth rowHeight ], ...
    'Tag', '0', ...
    'XTick',[], ...
    'YTick',[]);
h2 = text('Parent',h1, ...
    'Units','normalized', ...
    'FontSize',9, ...
    'HorizontalAlignment','center', ...
    'Position',[0.5 1], ...
    'String',' ', ...
    'Tag','T0', ...
    'VerticalAlignment', 'cap'); %spacer? 
h1 = axes('Parent',h0, ...
    'Units','normalized', ...
    'CameraUpVector',[0 1 0], ...
    'CameraUpVectorMode','manual', ...
    'Position',[(colWidth) + 0.02 (rowHeight+0.01)*(numRows-1) + 0.01 colWidth rowHeight], ...
    'Tag', 'X', ...
    'Visible', 'off', ...
    'XTick',[], ...
    'YTick',[]); %spacer since visible = 'off'?
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 1], ...
    'String','Match:',...
    'VerticalAlignment', 'cap'); %text label for "Match: "
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0.66], ...
    'String','Iteration:',...
    'VerticalAlignment', 'middle'); %text label for "Iteration: "
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0.33], ...
    'String','Input:',...
    'VerticalAlignment', 'middle'); %text label for "Input: "
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0], ...
    'String','Reclassified:',...
    'VerticalAlignment', 'bottom'); %text label for "Reclassified: "
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 1], ...
    'String',' ',...
    'Tag','Match',...
    'VerticalAlignment', 'cap'); %will this return the value of Match since the string is ' '?
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0.66], ...
    'String',' ',...
    'Tag','Iteration',...
    'VerticalAlignment', 'middle'); %value of Iteration?
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0.33], ...
    'String',' ',...
    'Tag','Input',...
    'VerticalAlignment', 'middle'); %Value of the contour name?
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0], ...
    'String',' ',...
    'Tag','Reclassifications',...
    'VerticalAlignment', 'bottom'); %value of the number of reclassifications?

% drawing the axes for all potential reference categories
number = 1;
for counter2 = 0:1:numCols
    for counter1 = numRows-2:-1:0
        h1 = axes('Parent',h0, ...
            'Units','normalized', ...
            'CameraUpVector',[0 1 0], ...
            'CameraUpVectorMode','manual', ...
            'Position',[(colWidth+0.01)*counter2 + 0.01 (rowHeight+0.01)*counter1 + 0.01 colWidth rowHeight], ...
            'Tag', num2str(number), ...
            'Visible', 'on', ...
            'XTick',[], ...
            'YTick',[]); %axes placeholder named with the current value of 'number' (which will increment)
        h2 = text('Parent',h1, ...
            'Units','normalized', ...
            'FontSize',9, ...
            'HorizontalAlignment','center', ...
            'Position',[0.5 1], ...
            'String',['Neuron ' num2str(number)], ...
            'Tag',['T' num2str(number)], ...
            'VerticalAlignment', 'cap', ...
            'Visible', 'on'); %text placeholder named T[current value of 'number']
        number = number+1; %once the axes and its label have been created, increment 'number' and repeat for the next set
    end
end





