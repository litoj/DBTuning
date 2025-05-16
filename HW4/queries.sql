-- Point queries
SELECT * FROM Publ WHERE pubID = 'conf/icnsc/LiJS08';
SELECT * FROM Publ WHERE pubID = 'books/aw/stonebraker86/Stonebraker86a';
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Yip88_'; -- has no match
SELECT * FROM Publ WHERE pubID = 'books/idea/encyclopedia2005/Erbas05';
SELECT * FROM Publ WHERE pubID = 'conf/aaai/Val99';

-- Multipoint low selectivity
SELECT * FROM Publ WHERE booktitle = 'IS4TM'; -- 1 result
SELECT * FROM Publ WHERE booktitle = 'DELOS Workshop: Personalisation and Recommender Systems in Digital Libraries'; -- 18 results
SELECT * FROM Publ WHERE booktitle = 'DELOS Workshop: Personalisation and Recommender Systems in Digital Librarie'; -- no results
SELECT * FROM Publ WHERE booktitle = 'TWOMD'; -- 8 results

-- Multipoint low selectivity using IN
SELECT * FROM Publ WHERE pubID IN (
'conf/hpcn/MayerPSKBS95',
'conf/uist/HartmannWCK07',
'conf/waa/WangLP03',
'conf/icde/DesslochHWRZ08',
'conf/ictcs/MacchettiCBC05',
'conf/prdc/SunH01',
'journals/apal/BaumgartnerL90',
'journals/eor/Ozer08',
'conf/icse/BasiliR87',
'conf/humo/SongP00',
'conf/geos/AdabalaT05',
'conf/aips/Cook94',
'journals/ijcm/IsmailAS03',
'journals/siamcomp/BajajCGW93',
'journals/jsyml/Masseron83');
SELECT * FROM Publ WHERE pubID IN (
'conf/prdc/DrebesN08',
'conf/mcs/MarcialisR04',
'conf/siggraph/Waters87',
'conf/ascilite/DonaldNKM02',
'conf/iv/BelousovTC99',
'conf/pos/90',
'conf/stoc/Reif97');
SELECT * FROM Publ WHERE pubID IN ('conf/dac/2008',
'conf/mfdbs/BiskupR87',
'conf/holomas/BoussaidBDC03',
'journals/actaC/Domosi00',
'books/sp/wang2005/Zhang05',
'journals/jifs/FonsAR04',
'conf/flairs/Wooley98',
'conf/apweb/LiZWM04',
'journals/endm/HamburgerC05',
'journals/envsoft/TurpinBRBKTFSHGPBLRERBBBLLPZ05',
'conf/knowright/Gendreau95',
'conf/icde/KleinDHKL07',
'conf/cade/Baker-PlummerBM92',
'conf/hicss/KopferS02');
SELECT * FROM Publ WHERE pubID IN (
'journals/tcs/EsikK04',
'conf/icra/KobayashiH04',
'conf/coling/KerpedjievN90');

-- Multipoint high selectivity
SELECT * FROM Publ WHERE year = 2008; -- 118113 results
SELECT * FROM Publ WHERE year = 2006; -- 117705 results
SELECT * FROM Publ WHERE year = 2005; -- 108435 results
SELECT * FROM Publ WHERE year = 2004; --  91059 results
SELECT * FROM Publ WHERE year = 2007; -- 123190 results
