function B = blend(Ia,Io,mask)
    nlab = 4;
    [La1,Lo1,ga1,go1] = gaussLapPyr(Ia,Io,nlab);
    maska = mask;
    maskb = 1-maska;
    blurh = fspecial('gauss',70,15); % feather the border
    maska = imfilter(maska,blurh,'replicate');
    maskb = imfilter(maskb,blurh,'replicate');
    Lc = cell(1,nlab); % the blended pyramid
    for p = 1:nlab
        [Mp, Np, ~] = size(La1{p});
        maskap = imresize(maska,[Mp Np]);
        maskbp = imresize(maskb,[Mp Np]);
        Lc{p} = La1{p}.*maskap + Lo1{p}.*maskbp;
    end

    for p = length(Lc)-1:-1:1
        Lc{p} = Lc{p}+ imresize(impyramid((Lc{p+1}),'expand'),[size(Lc{p},1) size(Lc{p},2)]);
    end
    %for i = 1:nlab
    %    figure(i)
    %    imshow(Lc{i})
    %end 
    B = Lc{1};
end
