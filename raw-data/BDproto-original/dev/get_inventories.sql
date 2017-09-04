SELECT * 
FROM BDPROTO.languesbdproto
JOIN BDPROTO.segments
ON BDPROTO.languesbdproto.Code = BDPROTO.segments.code

# need to flip unicode2ipa.ipala (e.g. 2001) to unicode2ipa.unicode (hex)