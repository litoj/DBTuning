-- Query 1: no additional filter
SELECT a.name, p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID;

-- Query 2: extra filter on Auth
SELECT p.title
  FROM Auth AS a
  JOIN Publ AS p ON a.pubID = p.pubID
 WHERE a.name = 'Divesh Srivastava';
