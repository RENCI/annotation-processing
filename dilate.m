function result = dilate(im, r)

result = imbinarize(im, 1 / 65535);

% Define the structuring element
se = strel('octagon', r * 2 + 1);

% Dilate the image using the structuring element
result = imdilate(result, se);

% Perform connected component analysis and obtain labels
[result, numLabels] = bwlabeln(result);

% Create a label matrix where each voxel is assigned the label of its corresponding connected component
result = labelmatrix(result);

result = uint16(result);