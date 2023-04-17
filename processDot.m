function result = processDot(im, binary, r)

if ~exist('binary', 'var')
    binary = false;
end

if ~exist('r', 'var')
    r = 1;
end

imSize = size(im);

result = uint16(zeros(imSize));

% Compute the voronoi diagram

v = uint16(zeros(imSize));

for z = 1:imSize(3)
    slice = im(:,:,z);
    
    seeds = find(slice > 0);
    [x, y] = ind2sub(size(slice), seeds);
    
    d = zeros(1, length(seeds));
    for i = 1:imSize(1)
        for j = 1:imSize(2)   
            for k = 1:length(d)    
                d(k) = (i - x(k))^2 + (j - y(k))^2;            
            end

            [~, index] = min(d);
            
            v(i, j, z) = slice(x(index), y(index));
        end
    end
end

% Dilate each dot and mask with voronoi diagram
se = strel('disk', r * 2 + 1);

for z = 1:imSize(3)
    slice = im(:,:,z);
    vSlice = v(:,:,z);
    
    seeds = find(slice > 0);
    
    for k = 1:length(seeds)
        value = slice(seeds(k));

        dil = slice == value;
        dil = imdilate(dil, se);
        
        p = find(dil > 0);
        [x, y] = ind2sub(size(dil), p);

        for m = 1:length(p)
            if vSlice(p(m)) == value
                result(x(m), y(m), z) = value;
            end
        end
    end
end

if binary
    % Remove touching voxels and binarize

    for z = 1:imSize(3)
        slice = result(:,:,z);
        
        for i = 1:imSize(1)
            for j = 1:imSize(2)
                value = slice(i,j);
                for ii = max([1, i - 1]):min(imSize(1), i + 1)
                    for jj = max([1, j - 1]):min(imSize(2), j + 1)
                        if slice(ii,jj) > 0 && slice(ii, jj) ~= value 
                            slice(i,j) = 0;
                        end
                    end
                end           
            end
        end

        result(:,:,z) = slice > 0;
    end
end
