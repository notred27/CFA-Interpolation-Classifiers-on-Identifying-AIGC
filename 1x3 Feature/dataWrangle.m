% Script used to find the best feature for each image according to the
% lowest overall percent difference in the image. Also records what the
% best algorithm to generate the data was.


bayer_array = 'bggr';       % The Bayer array configuration of the data
type = "real"               % Set if you are processing the real or fake images
src = "2k Faces Results"    % The source folder for where the data files are stored
                            %       *Note that the files generated from
                            %       this script will also be stored in this
                            %       folder


if strcmp(type,"real")
    raw_bicubic = load(join([src , "\",bayer_array,'\r_bicubic3D_',bayer_array,'.mat'], "")).real;
    raw_bilinear = load(join([src , "\",bayer_array,'\r_bilinear3D_',bayer_array,'.mat'], "")).real;
    raw_smoothHue = load(join([src , "\",bayer_array,'\r_smoothHue3D_',bayer_array,'.mat'], "")).real;
    raw_gradient = load(join([src , "\",bayer_array,'\r_gradient3D_',bayer_array,'.mat'], "")).real;

    best_r = cell(size(raw_bicubic));
    best_name_r = cell(size(raw_bicubic));
    
    for i = 1:size(best_r)
        bilinear = raw_bilinear{i}{1} + raw_bilinear{i}{2} + raw_bilinear{i}{3};
        bicubic = raw_bicubic{i}{1} + raw_bicubic{i}{2} + raw_bicubic{i}{3};
        smoothHue = raw_smoothHue{i}{1} + raw_smoothHue{i}{2} + raw_smoothHue{i}{3};
        gradient = raw_gradient{i}{1} + raw_gradient{i}{2} + raw_gradient{i}{3};
    
    
        local = min([bilinear,bicubic,smoothHue, gradient]);
    
        if(local == bilinear)
            best_r{i} = raw_bilinear{i};
            best_name_r{i} = "bilinear";
        end
    
        if(local == bicubic)
            best_r{i} = raw_bicubic{i};
            best_name_r{i} = "bicubic";
        end
    
        if(local == smoothHue)
            best_r{i} = raw_smoothHue{i};
            best_name_r{i} = "smoothHue";
        end
    
    
        if(local == gradient)
            best_r{i} = raw_gradient{i};
            best_name_r{i} = "gradient";
        end
    
    end
    

    save(join([src , "\",bayer_array,'\best_r.mat'], ""), "best_r")
    save(join([src , "\",bayer_array,'\best_name_r.mat'], ""), "best_name_r")


else
    raw_bicubic = load(join([src , "\",bayer_array,'\f_bicubic3D_',bayer_array,'.mat'], "")).fake;
    raw_bilinear = load(join([src , "\",bayer_array,'\f_bilinear3D_',bayer_array,'.mat'], "")).fake;
    raw_smoothHue = load(join([src , "\",bayer_array,'\f_smoothHue3D_',bayer_array,'.mat'], "")).fake;
    raw_gradient = load(join([src , "\",bayer_array,'\f_gradient3D_',bayer_array,'.mat'], "")).fake;

    best_f = cell(size(raw_bicubic));
    best_name_f = cell(size(raw_bicubic));
    
    for i = 1:size(best_f)
        bilinear = raw_bilinear{i}{1} + raw_bilinear{i}{2} + raw_bilinear{i}{3};
        bicubic = raw_bicubic{i}{1} + raw_bicubic{i}{2} + raw_bicubic{i}{3};
        smoothHue = raw_smoothHue{i}{1} + raw_smoothHue{i}{2} + raw_smoothHue{i}{3};
        gradient = raw_gradient{i}{1} + raw_gradient{i}{2} + raw_gradient{i}{3};
    
    
        local = min([bilinear,bicubic,smoothHue, gradient]);
    
        if(local == bilinear)
            best_f{i} = raw_bilinear{i};
            best_name_f{i} = "bilinear";
        end
    
        if(local == bicubic)
            best_f{i} = raw_bicubic{i};
            best_name_f{i} = "bicubic";
        end
    
        if(local == smoothHue)
            best_f{i} = raw_smoothHue{i};
            best_name_f{i} = "smoothHue";
        end
    
    
        if(local == gradient)
            best_f{i} = raw_gradient{i};
            best_name_f{i} = "gradient";
        end
    
    end
    
    save(join([src , "\",bayer_array,'\best_f.mat'], ""), "best_f")
    save(join([src , "\",bayer_array,'\best_name_f.mat'], ""), "best_name_f")
end





