--Ex 2.B.iv
--1
SELECT t.title, t.price, p.pub_name
FROM titles t, publishers p
WHERE p.pub_id = t.pub_id;

--2
SELECT t.title, t.price, p.pub_name
FROM titles t, publishers p
WHERE p.pub_id = t.pub_id
AND t.type = 'psychology';

--3
SELECT DISTINCT a.au_fname, a.au_lname
FROM authors a, titleauthor ta
WHERE ta.au_id = a.au_id;

--4
SELECT DISTINCT a.state
FROM authors a, titleauthor ta
WHERE ta.au_id = a.au_id;

--5
SELECT st.stor_name, st.stor_address
FROM stores st, sales sa
WHERE sa.stor_id = st.stor_id
AND date >'1991-10-30' AND date <'1991-12-1';

--6
SELECT t.title_id
FROM titles t, publishers p
WHERE p.pub_id = t.pub_id
AND p.pub_name NOT SIMILAR TO 'Algo%'
AND t.type = 'psychology'
AND t.price<20;

--7
SELECT t.title_id, t.title
FROM titles t, authors a
WHERE a.state = 'CA'
GROUP BY t.title_id, t.title;

--8
SELECT DISTINCT a.au_id, a.au_fname, a.au_lname
FROM authors a, titleauthor ta, titles t, publishers p
WHERE ta.au_id = a.au_id
AND ta.title_id = t.title_id
AND t.pub_id = p.pub_id
AND p.state = 'CA';

--9
SELECT DISTINCT a.au_id, au_lname, au_fname
FROM authors a, titleauthor ta, titles t, publishers p
WHERE ta.au_id = a.au_id
AND ta.title_id = t.title_id
AND t.pub_id = p.pub_id
AND p.state = a.state;

--10
SELECT p.pub_id, p.pub_name
FROM publishers p, titles t, salesdetail sd, sales sa
WHERE p.pub_id= t.pub_id
AND t.title_id = sd.title_id
AND sd.stor_id = sa.stor_id
AND sd.ord_num = sa.ord_num
AND sa.date < '1991-03-01' AND sa.date > '1990-11-1';

--11
SELECT DISTINCT st.stor_id, st.stor_name
FROM stores st, sales sa, salesdetail sd, titles t
WHERE st.stor_id = sa.stor_id
AND sa.ord_num = sd.ord_num
AND sd.stor_id = sa.stor_id
AND sd.title_id = t.title_id
AND t.title SIMILAR TO '%Cook%' OR t.title SIMILAR TO '%cook%';

--12
SELECT t1.title_id, t1.title, t2.title_id, t2.title
FROM titles t1, titles t2, publishers p
WHERE t1.pub_id = p.pub_id
AND t2.pub_id = p.pub_id
AND t1.pubdate = t2.pubdate
AND t1.title_id < t2.title_id;

--13
SELECT a.au_id, a.au_fname, au_lname
FROM authors a, titleauthor ta, titles t1, titles t2, publishers p1, publishers p2
WHERE a.au_id = ta.au_id
AND ta.title_id = t1.title_id
AND ta.title_id = t2.title_id
AND t1.pub_id = p1.pub_id
AND t2.pub_id = p2.pub_id
AND p1.pub_id <> p2.pub_id;

--14
SELECT t.title_id, t.title
FROM titles t, salesdetail sd, sales sa
WHERE t.title_id = sd.title_id
AND sd.stor_id = sa.stor_id
AND sd.ord_num = sa.ord_num
AND sa.date < t.pubdate;

--15
SELECT DISTINCT st.stor_id, st.stor_name
FROM stores st, sales sa, salesdetail sd, titles t, titleauthor ta, authors a
WHERE st.stor_id = sa.stor_id
AND sa.ord_num = sd.ord_num
AND sd.stor_id = sa.stor_id
AND sd.title_id = t.title_id
AND t.title_id = ta.title_id
AND ta.au_id = a.au_id
AND a.au_fname SIMILAR TO 'Anne' AND a.au_lname SIMILAR TO 'Ringer';

--16
SELECT DISTINCT a.state
FROM authors a, titleauthor ta, salesdetail sd, sales sa, stores st
WHERE a.au_id= ta.au_id
AND ta.title_id = sd.title_id
AND sd.ord_num = sa.ord_num
AND sd.stor_id = sa.stor_id
AND sa.stor_id = st.stor_id
AND st.state = 'CA'
AND sa.date > '1991-01-31'
AND sa.date < '1991-03-1'
AND a.state IS NOT NULL;

--17
SELECT DISTINCT  st1.stor_id, st1.stor_name, st2.stor_id, st2.stor_name
FROM stores st1, stores st2, sales sa, salesdetail sd1, salesdetail sd2, titleauthor ta1, titleauthor ta2
WHERE st1.stor_id = sd1.stor_id AND st2.stor_id = sd2.stor_id
AND sd1.title_id = ta1.title_id AND sd2.title_id = ta2.title_id
AND st1.stor_id < st2.stor_id AND ta1.au_id = ta2.au_id
AND st1.state = st2.state;
--a continuer

--18
SELECT DISTINCT a1.au_id, a1.au_fname, a1.au_lname, a2.au_id, a2.au_fname, a2.au_lname
FROM authors a1, authors a2, titleauthor ta1, titleauthor ta2
WHERE a1.au_id = ta1.au_id
AND a2.au_id = ta2.au_id
AND a1.au_id<a2.au_id
AND ta1.title_id = ta2.title_id;

--19
--Pour chaque détail de vente, donnez le titre du livre, le nom du magasin, le prix unitaire, le
--nombre d'exemplaires vendus, le montant total et le montant de l'éco-taxe totale (qui s'élève à 2%
--du chiffre d'affaire)

--le count de nbr examplaire
SELECT t.title, st.stor_name, t.price, sum(sd.qty*t.price)
FROM salesdetail sd, titles t, stores st, sales sa
WHERE st.stor_id = sa.stor_id
AND sa.stor_id = sd.stor_id
AND sa.ord_num = sd.ord_num
AND sd.title_id = t.title_id
group by t.title, st.stor_name, t.price
--pas fini


