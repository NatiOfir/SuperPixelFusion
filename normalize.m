function I = normalize(I)
    I = I-min(I(:));
    I = I./max(I(:));
end