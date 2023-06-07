function str = cleanLegendEntry(raw_string)

    result = strrep(raw_string, '_', ' ');
    result = strrep(result, '-', ' ');

    result = strtrim(result);
    
    str = result;

end
