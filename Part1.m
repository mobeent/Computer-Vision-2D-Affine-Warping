function [imgout] = Part1(image, projection)

  imgin = imread(image);
  projection = inv(projection);
  sz = size(imgin);
  ydimension = sz(1,1);
  xdimension = sz(1,2);
%   colors = sz(1,3);
  imgout = zeros(sz);

  for i = 1:xdimension
    for j = 1:ydimension
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
            imgout(j, i, k) = imgin(newy, newx, k);
          elseif ((leftx - newx == 0 && rightx - newx == 0) && (topy - newy ~= 0 || bottomy - newy ~= 0))
            interpolate = (topy-newy)*(bottomleft)/(topy-bottomy) + (newy-bottomy)*(topleft)/(topy-bottomy);
            imgout(j,i,k) = interpolate;
          elseif ((leftx - newx ~= 0 && rightx - newx ~= 0) && (topy - newy == 0 || bottomy - newy == 0))
            interpolate = (rightx-newx)*(topleft)/(rightx-leftx) + (newx-leftx)*(topright)/(rightx-leftx);
            imgout(j,i,k) = interpolate;
          else
            value1 = (rightx-newx)*(topleft)/(rightx-leftx) + (newx-leftx)*(topright)/(rightx-leftx);
            value2 = (rightx-newx)*(bottomleft)/(rightx-leftx) + (newx-leftx)*(bottomright)/(rightx-leftx);
            interpolate = (topy-newy)*(value2)/(topy-bottomy) + (newy-bottomy)*(value1)/(topy-bottomy);
            imgout(j,i,k) = interpolate;
          end
        end
      end
    end
  end
  imgout = uint8(imgout);
end
