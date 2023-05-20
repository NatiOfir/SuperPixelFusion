function g = getGrades(I, L, N)
    g = zeros(size(I));
    for j = 1:N
        mask = L == j;
        pixels = I(mask);
        grade = std(pixels);
        g(mask) = grade;
    end
end
