% read data
% s = what();
% fullpath = fileparts(s.path);
% mainpath = strcat(fullpath, '/data/Stanford3dDataset_v1.2_Aligned_Version')
mainpath = '../data/Stanford3dDataset_v1.2_Aligned_Version';
all_area = dir(mainpath);
all_area(1).name
all_area(2).name
all_area(3).name
all_area(4).name
all_area(5).name
length(all_area) - 2
for a=1:(length(all_area) - 2)
    area = all_area(area).name;
    category_path = strcat( mainpath, '/', area);
    all_category = dir(category_path);
    
    for cat=1:length(all_category)
        
        category = all_category(cat).name;
        data_name = strcat(category, '.txt');
        data_path = strcat( mainpath, '/', area, '/',category, data_name);

        Points = load(data_path);
        xyzPoints = Points(:,1:3);
        row = length(Points(:,1));

%       reduction based on label
%         label_path = strcat( mainpath, '/', category, '/points_label/', label_files(n).name);
%         lables = load(label_path);
%         A = (lables ~= 2);

%       cut part of the object bansed on axis
%         [Max_v,Max_i] = max(xyzPoints);
%         [Min_v,Min_i] = min(xyzPoints);
%         Range_value = Max_v - Min_v;
%         [value, axis] = max(Range_value);
%         A = xyzPoints(:,axis) > (Min_v(axis) + value * 0.3);
% 
%         xyzPoints = xyzPoints(A ~= 0,:);

    %       get normals
        ptCloud = pointCloud(xyzPoints);
        normals = pcnormals(ptCloud);

    %       show normals
        figure;
        pcshow(ptCloud);
        title('Estimated Normals of Point Cloud');
        hold on;

        x = ptCloud.Location(1:1:end,1);
        y = ptCloud.Location(1:1:end,2);
        z = ptCloud.Location(1:1:end,3);
        u = normals(1:1:end,1);
        v = normals(1:1:end,2);
        w = normals(1:1:end,3);

        quiver3(x,y,z,u,v,w);
        hold off

    %       out put normals and coords
        coords_normal = zeros(row, 12);
        coords_normal(1,6) = Points(1,6);
        coords_normal(7,12) = normals;
        
        output_path = input_path;
        fileID = fopen(output_path, 'w');

%         for ii = 1:size(coords_normal,1)
        fprintf(fileID,'%10.8f %10.8f %10.8f %d %d %d %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f\n',coords_normal);
%         end
        fclose(fileID);

    end
end

