function [ corners ] = track_corners(images, img_pts_init)
%TRACK_CORNERS 
% This function tracks the corners in the image sequence and visualizes a
% virtual box projected into the image
% Inputs:
%     images - size (N x 1) cell containing the sequence of images to track
%     img_pts_init - size (4 x 2) matrix containing points to initialize
%       the tracker
% Outputs:
%     corners - size (4 x 2 x N) array of where the corners are tracked to

corners = zeros(4,2,size(images,1));

%%%% INITIALIZATION CODE FOR TRACKER HERE %%%%

img_pts = img_pts_init; % img_pts is where you will store the tracked points
corners(:,:,1) = img_pts;

pointTracker = vision.PointTracker;
initialize(pointTracker,img_pts_init,images{1});
% Iterate through the rest of the images
for i = 2:size(images,1)
    %%%% CODE FOR TRACKING HERE %%%%
    [img_pts,~] = pointTracker(images{i});
    %setPoints(pointTracker,img_pts_init);
    %{
    this_img = images{i};
    prev_img = images{i-1};
    this_img = rgb2gray(this_img);
    prev_img = rgb2gray(prev_img);
    v = [0 0; 0 0; 0 0; 0 0];
    for num = 1:4
        ori_area = img_pts(num,:);
        area = round(ori_area);
        len = 10;
        lines = area(1)-len:area(1)+len;
        cols = area(2)-len:area(2)+len;
        ori = prev_img(lines,cols);
        deltax = 1;
        deltay = 1;
        Ix = 0;
        Iy = 0;
        while (Ix == 0)
            Ix = mean(mean(prev_img(lines,cols+deltax) - prev_img(lines,cols)))/deltax;
            deltax = deltax+1;
        end
        while (Iy == 0)
            Iy = mean(mean(prev_img(lines+deltay,cols) - prev_img(lines,cols)))/deltay;
            deltay = deltay+1;
        end        
        for n = 1:5
            area = round(area);
            lines = area(1)-len:area(1)+len;
            cols = area(2)-len:area(2)+len;
            It = mean(mean(this_img(lines,cols) - ori));
            v(num,:) = v(num,:) - [It/Ix It/Iy];
            area = ori_area + v(num,:);
        end
    end
    img_pts = img_pts+v;
    %}
    % Store corners and visualize results (if desired)
    corners(:,:,i) = img_pts;
end

end

