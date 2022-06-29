import sys
import pandas as pd
from io import StringIO

escape_dict={'\a':r'\a',
             '\b':r'\b',
             '\c':r'\c',
             '\f':r'\f',
             '\n':r'\n',
             '\r':r'\r',
             '\t':r'\t',
             '\v':r'\v',
             '\'':r'\'',
             '\"':r'\"'}

def raw(text):
    """Returns a raw string representation of text"""
    new_string=''
    for char in text:
        try: 
            new_string += escape_dict[char]
        except KeyError: 
            new_string += char
    return new_string

str_input = ""
for line in sys.stdin:

    if line.find("\\hline") != -1 or line.find("\\multicolumn") != -1 or line.find("NaN") != -1:
        continue

    str_input = str_input + raw(line).replace("569BJNRXghikls", "$^-") + "\n"; 


df = pd.read_csv(StringIO(str_input), header=None, delimiter="&")


df = df.sort_values(df.columns[1])
print(df.to_csv(sep="&", index= False))


