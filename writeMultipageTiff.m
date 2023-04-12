function writeTiff(im, filename)

% Save the image stack as a TIFF using imwrite
for i = 1:size(im, 3)
    if i == 1
        % For the first image, use the 'overwrite' mode
        imwrite(im(:, :, i), filename, 'tif', 'Compression', 'none', 'WriteMode', 'overwrite');
    else
        % For subsequent images, use the 'append' mode
        imwrite(im(:, :, i), filename, 'tif', 'Compression', 'none', 'WriteMode', 'append');
    end
end
