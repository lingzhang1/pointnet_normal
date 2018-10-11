% read data
% s = what();
% fullpath = fileparts(s.path);
% mainpath = strcat(fullpath, '/data/Stanford3dDataset_v1.2_Aligned_Version')
mainpath = '../data/Stanford3dDataset_v1.2_Aligned_Version';
files = dir(mainpath);
dirFlags = [files.isdir];
all_area = files(dirFlags);

for a=3:length(all_area)

    area = all_area(a).name;
    category_path = strcat( mainpath, '/', area);

    files = dir(category_path);
    dirFlags = [files.isdir];
    all_category = files(dirFlags);

    for cat=3:length(all_category)

        category = all_category(cat).name;
        data_name = strcat(category, '.txt');

        data_path = strcat( mainpath, '/', area, '/',category,'/', 'Annotations/', '*.txt');
        all_files = dir(data_path);
        for f=1:length(all_files)

            professing = strcat(area, '/',category,'/', 'Annotations/', all_files(f).name)
            input_path = strcat( mainpath, '/', area, '/',category,'/', 'Annotations/', all_files(f).name);
            Points = load(input_path);
            xyzPoints = Points(:,1:3);
            row = length(Points(:,1));

    %       reduction based on label
    %         label_path = strcat( mainpath, '/', category, '/points_label/', label_files(n).name);
    %         lables = load(label_path)C;
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
    %         figure;
    %         pcshow(ptCloud);
    %         title('Estimated Normals of Point Cloud');
    %         hold on;
    %
    %         x = ptCloud.Location(1:1:end,1);
    %         y = ptCloud.Location(1:1:end,2);
    %         z = ptCloud.Location(1:1:end,3);
    %         u = normals(1:1:end,1);
    %         v = normals(1:1:end,2);
    %         w = normals(1:1:end,3);
    %
    %         quiver3(x,y,z,u,v,w);
    %         hold off

        %       out put normals and coords
            coords_normal = zeros(row, 12);
            coords_normal(:,1:6) = Points(:,1:6);
            coords_normal(:,10:12) = normals;
            coords_normal(1:2,:)

            output_path = input_path;
            fileID = fopen(output_path, 'w');
            for ii=1:row
                fprintf(fileID,'%10.8f %10.8f %10.8f %d %d %d %10.8f %10.8f %10.8f %10.8f %10.8f %10.8f\n',coords_normal(ii,:));
            end
            fclose(fileID);
        end
    end
end
