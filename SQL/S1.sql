--Ex 2.A.ii
--1
SELECT a.au_id, a.au_lname
FROM authors a
WHERE a.city = 'Oakland';

--2
SELECT a.au_id, a.au_lname, a.au_fname, a.address
FROM authors a
WHERE a.au_fname SIMILAR TO 'A%';

--3
SELECT a.au_fname, a.address
FROM authors a
WHERE a.phone = NULL;

--4
SELECT a.au_id
FROM authors a
WHERE a.state = 'CA'
AND a.phone NOT SIMILAR TO '415%';

--5
SELECT a.au_id, a.au_lname
FROM authors a
WHERE a.country = 'BEL'
OR a.country = 'NED'
OR a.country = 'LUX';

--6
SELECT ta.au_id
FROM  titles t, titleauthor ta
WHERE t.title_id = ta.title_id
AND t.type = 'psychology'
GROUP BY ta.au_id;

--7
SELECT p.pub_id
FROM  titles t, publishers p
WHERE t.pub_id = p.pub_id
AND t.price >= 10
AND t.price <= 25
AND t.type = 'psychology'
GROUP BY p.pub_id;

--8
SELECT a.au_id, a.city
FROM authors a
WHERE a.au_fname = 'Albert'
OR a.au_lname SIMILAR TO '%er';

--9
SELECT DISTINCT a.state, a.country
FROM authors a
WHERE a.country <> 'USA'
AND a.state IS NOT NULL;

--10
SELECT t.type
FROM titles t
WHERE t.price < 15
GROUP BY t.type


