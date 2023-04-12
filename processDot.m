function result = processDot(im, r)

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

se = strel('octagon', r * 2 + 1);

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
