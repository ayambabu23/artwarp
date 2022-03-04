function ARTwarp_Plot_Net2

global NET DATA

disp(DATA)
% Load Menu Options - This can be made into a function to prevent code
% repetition
h0 = findobj('Tag','ARTwarp');
clf
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
    'Enable','on', ...
    'Tag','Runmenu');
h2 = uimenu('Parent',h1, ...
    'Callback','ARTwarp_Plot_Net', ...
    'Accelerator','p', ...
    'Label','Plot Categorisation', ...
    'Enable','on', ...
    'Tag','Plotmenu');

% MATLAB does not have scrollbars making this a lot harder

% Create a tab for every category
% When clicked on one category display contours belonging to that category
% p = uipanel(h0,'Position',[20 20 196 135]);
% tabgp = uitabgroup(h0,'Position',[.01 .01 .98 .98]);

% Make scrolable sub panel for reference contours
% Under the panel for reference contours make another horizontally
% scrollable panel for the data contours

[Xmax x] = size(NET.weight);
Ymax = max(max(NET.weight));
numCols = round(NET.numCategories)-1;
numRows = 1;
numContours = length(DATA);
for category = 1:NET.numCategories
    numRows = max([numRows length(find([DATA.category]==category))]);
end
numRows = numRows+1;
rowHeight = (0.98 - 0.01*numRows)/numRows;
colWidth = (0.98 - 0.01*numCols)/(numCols+1);

referenceContours = []

function updatePanel(hObject, eventData, categoryNumber)
    % Make panel container for holding contours
    contoursPanel = uipanel(h0,...
     'BackgroundColor','white',...
     'ButtonDownFcn', 'disp(''Clicked panel'');',...
     'Position',[.02 .02 .96 .86], ...
     'Tag', 'contoursPanel');

    disp(categoryNumber);
    contours = [];
    r = 0; 
    c = 0;
    
    for i = 1:numContours
        if DATA(i).category == categoryNumber
            disp('cat');
            
            % Plot contours under category 'categoryNumber'
            h1 = axes('Parent',contoursPanel, ...
                'Units','normalized', ...
                'CameraUpVector',[0 1 0], ...
                'CameraUpVectorMode','manual', ...
                'Position',[.20 * (c + 1), .70 - 0.20 * (r), .10, .10], ...
                'Visible', 'on', ...
                'XLim', [0 Xmax], ...
                'YLim', [0 Ymax], ...
                'XTick',[], ...
                'YTick',[]);
            h2 = text('Parent',h1, ...
                'Units','normalized', ...
                'FontSize',9, ...
                'HorizontalAlignment','center', ...
                'Position',[0.5 1], ...
                'String',DATA(i).name, ...
                'VerticalAlignment', 'cap', ...
                'Visible', 'on');   
            h3 = line('Parent', h1, 'Color','k', 'Tag', ['P' num2str(i)], 'XData', 1:length(DATA(i).contour), 'YData', DATA(i).contour);
            contours = [contours h1];
            c = c + 1;
             
            if rem((c + 1), 5) == 0
                c = 0;
                r = r + 1;
            end
        end
    end
%     align(contours,'fixed', 30, 'middle');
end

% Display reference contours
for counter1 = 1:NET.numCategories
%     disp(sprintf('Category %s:',num2str(counter1)));
%     data = find(NET.weight(:,1)>0); 
%     disp(sprintf('%6.1f',NET.weight(data,1)'));


    p = uipanel(h0,...
             'BackgroundColor','white',...
             'Position',[(colWidth+0.01)*(counter1-1) + 0.01 (rowHeight+0.01)*(numRows-1) + 0.01 colWidth rowHeight]);
    set(p, 'ButtonDownFcn', {@updatePanel, counter1});
    h1 = axes('Parent',p, ...
        'HitTest', 'off', ...
        'Units','normalized', ...
        'CameraUpVector',[0 1 0], ...
        'CameraUpVectorMode','manual', ...
        'Position', [0 0 1 1], ...
        'Visible', 'on', ...
        'XLim', [0 Xmax], ...
        'YLim', [0 Ymax], ...
        'XTick',[], ...
        'YTick',[]);
    h2 = text('Parent',h1, ...
        'Units','normalized', ...
        'FontSize',9, ...
        'HorizontalAlignment','center', ...
        'Position',[0.5 1], ...
        'String',['Category ' num2str(counter1)], ...
        'VerticalAlignment', 'cap', ...
        'Visible', 'on');   
    h3 = line('Parent', h1, 'Color','r', 'Tag', ['P' num2str(counter1)], 'XData', 1:NET.numFeatures, 'YData', NET.weight(:,counter1));
end

end