import unicodedata
import sys

infile = open("unicode.temp", "r")
header = infile.readline()

for line in infile:
    line = line.strip()
    tokens = line.split("\t")
    ipala = tokens[0]
    unicode = tokens[1]

    ipala_int = int(ipala, 16)
    unicode_int = int(unicode, 16)

    print(ipala+"\t"+"SEE IPALA FONT"+"\t"+unicode+"\t"+unicodedata.name(chr(unicode_int)))
