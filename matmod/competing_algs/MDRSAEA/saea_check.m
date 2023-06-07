function result = saea_check(dim,num)
    global evaluation;
    temp = size(dim,2);
    if 40*nchoosek(temp,num)*num>evaluation
        result = 1;
    else
        result = -1;
    end
end