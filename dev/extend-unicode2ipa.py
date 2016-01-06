# -*- coding: utf-8 -*-

"""
Script to convert original BDPROTO database dumps to Unicode-IPA in PHOIBLE data format.

Steven Moran <steven.moran@uzh.ch>
September, 2014

"""

import sys
import unicodedata

# original BDPROTO mapping to Unicode; they used IPALA font
infile = open("unicode2ipa-updated2.tsv", "r")
header = infile.readline()
header_tokens = header.split("\t")

# uncomment this when working with first half of this file
# print("id"+"\t"+header_tokens[0]+"\t"+"ipala char"+"\t"+header_tokens[2]+"\t"+"unicode char")

# store ipala-unicode hex mappings
ipala_to_unicode = {}

id = 0
for line in infile:
    id += 1
    line = line.strip()
    tokens = line.split("\t")
    ipala = tokens[0].strip()
    unicode = tokens[2].strip()
    unicode = unicode.lstrip("u")

    if ipala not in ipala_to_unicode:
        ipala_to_unicode[ipala] = unicode
    else:
        print(line)
        sys.exit("you have duplicate ipala-to-unicode mappings")

    # conver to int for input to chr()
    ipala_int = int(ipala, 16)
    unicode_int = int(unicode, 16)

    # print output
    # print(str(id)+"\t"+ipala+"\t"+chr(ipala_int)+"\t"+unicode+"\t"+chr(unicode_int))

"""
for k, v in hex_to_char.items():
    print(k, v)
"""
infile.close()



# process phonemes file
infile = open("languesbdproto-segments-phonemes.tsv", "r")
header = infile.readline()
# ht = header.split("\t")
print("BdprotoID"+"\t"+"LanguageName"+"\t"+"LanguageFamily"+"\t"+"Phoneme")

for line in infile:
    line = line.strip()
    line = line.replace('"', "")
    tokens = line.split("\t")
    hex = tokens[25].strip()

    # split the string into 4-digit hex values
    n = 4
    hex_codes = [hex[i:i+n] for i in range(0, len(hex), n)]
    result = ""
    for code in hex_codes:
        # check if missing hex codes in IPA conversion
        if code in ipala_to_unicode:
            code = ipala_to_unicode[code]

            # skip the COMBINING DOUBLE INVERTED BREVE at U+0361
            if code == "0361":
                continue
            i = int(code, 16)
            # print(code+"\t"+ipala_to_unicode[code])

        # this checked for hex codes not in the original BDPROTO's unicode2ipa mapping table
        # i went through these manually and tracked down the rest and noted them in unicode2ipa-updated
        else:
            i = int(code, 16)
            print("NOT IN CONVERSION:"+"\t"+code+"\t"+chr(i))

        # concatenate into a character string
        result += chr(i)

    # convert the result from BDPROTO to Unicode NFD
    result_nfd = unicodedata.normalize("NFD", result)

    # test if there is any difference between original BDPROTO and Unicode NFD strings
    # c-cedilla always a problem
    # one other problem was: 0061+0303+0318 (original) vs 0061+0318+0303
    """
    same = result==result_nfd
    if not same:
        print(result+"\t"+result_nfd+"\t"+str(same))
        """
    # replace the problematic cases mentioned above
    result_nfd = result_nfd.replace("ç", "ç")

    # print the resulting concatenated string
    print(tokens[2]+"\t"+tokens[0]+"\t"+tokens[1]+"\t"+result)

