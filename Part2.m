function [imgout] = Part2(image, projection)

  imgin = imread(image);
%   projection = inv(projection);
  sz = size(imgin);
  ydimension = sz(1,1);
  xdimension = sz(1,2);
%   colors = sz(1,3);
  imgout = zeros(sz);
  xmin = 0;
  xmax = 0;
  ymin = 0;
  ymax = 0;
  for i = 1:xdimension
      for j = 1:ydimension
        result = projection*[i; j; 1];
        newx = result(1,1);
        newy = result(2,1);
        if (xmin > newx)
            xmin = newx;
        end
        if (xmax < newx)
            xmax = newx;
        end
        if (ymin > newy)
            ymin = newy;
        end
        if (ymax < newy)
            ymax = newy;
        end
      end
  end
  
  imgout = zeros((ceil(ymax)-floor(ymin)), (ceil(xmax)-floor(xmin)));
  projection = inv(projection);
  indexi = 1;
  indexj = 1;
  for i = floor(xmin):ceil(xmax)
    for j = floor(ymin):ceil(ymax)
      for k = 1:size(imgin,3)
        result = projection*[i; j; 1];
        newx = result(1,1);
        newy = result(2,1);
        newz = result(3,1);
        leftx = floor(newx);
        rightx = ceil(newx);
        bottomy = floor(newy);
        topy = ceil(newy);

        if ~(leftx < 1 || bottomy < 1 || rightx > xdimension || topy > ydimension)
          topleft = imgin(topy, leftx, k);
          bottomleft = imgin(bottomy, leftx, k);
          topright = imgin(topy, rightx, k);
          bottomright = imgin(bottomy, rightx, k);

          if (leftx - newx == 0 && rightx - newx == 0 && topy - newy == 0 && bottomy - newy == 0)
            imgout(indexj, indexi, k) = imgin(newy, newx, k);
          elseif ((leftx - newx == 0 && rightx - newx == 0) && (topy - newy ~= 0 || bottomy - newy ~= 0))
            interpolate = (topy-newy)*(bottomleft)/(topy-bottomy) + (newy-bottomy)*(topleft)/(topy-bottomy);
            imgout(indexj, indexi, k) = interpolate;
          elseif ((leftx - newx ~= 0 && rightx - newx ~= 0) && (topy - newy == 0 || bottomy - newy == 0))
            interpolate = (rightx-newx)*(topleft)/(rightx-leftx) + (newx-leftx)*(topright)/(rightx-leftx);
            imgout(indexj, indexi, k) = interpolate;
          else
            value1 = (rightx-newx)*(topleft)/(rightx-leftx) + (newx-leftx)*(topright)/(rightx-leftx);
            value2 = (rightx-newx)*(bottomleft)/(rightx-leftx) + (newx-leftx)*(bottomright)/(rightx-leftx);
            interpolate = (topy-newy)*(value2)/(topy-bottomy) + (newy-bottomy)*(value1)/(topy-bottomy);
            imgout(indexj, indexi, k) = interpolate;
          end
        end
      end
      indexj = indexj + 1;
    end
    indexi = indexi + 1;
    indexj = 1;
  end
  imgout = uint8(imgout);
end
