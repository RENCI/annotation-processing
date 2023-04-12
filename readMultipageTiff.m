function result = multipageTiff(filename)

% Get the total number of images in the file
info = imfinfo(filename);
num_images = numel(info);

% Preallocate the 3D matrix to store all images
height = info(1).Height;
width = info(1).Width;
result = zeros(height, width, num_images, 'uint16');

% Loop through each image in the file and store it in the 3D matrix
for i = 1:num_images
    result(:,:,i) = imread(filename, i);
end

