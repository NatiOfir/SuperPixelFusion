function [La1,Lo1,ga1,go1] = gaussLapPyr(img1,img2,nlab)
    Ia = im2double(img1);
    Io = im2double(img2);
    ga1 = {};go1 = {};La1= {};
    % gaussian pyramid
    for p = 1:nlab
        if p>1
            ga= impyramid(Ia,'reduce');
        else
            ga = Ia;
        end
        ga1{p} = ga;
        if p>1
            go= impyramid(Io,'reduce');
        else
            go = Io;
        end
        go1{p} = go;
        Ia = ga;
        Io = go1{p};
    end
    for l = 1:nlab-1   
        La1{l}= ga1{l} - imresize(impyramid(ga1{l+1},'expand'),[size(ga1{l},1) size(ga1{l},2)]);
        if l ==(nlab-1)
            La1{4} = ga1{4};
        end
        Lo1{l}= go1{l} - imresize(impyramid(go1{l+1},'expand'),[size(go1{l},1) size(go1{l},2)]);
        if l ==(nlab-1)
            Lo1{nlab} = go1{nlab};
        end
    end
end