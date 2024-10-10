-- Ex 2.g.ii

--1
SELECT st.stor_name, SUM(t.price*sd.qty) as chiffre_dffaire
FROM stores st
    LEFT OUTER JOIN salesdetail sd ON st.stor_id = sd.stor_id
    LEFT OUTER JOIN titles t ON t.title_id = sd.title_id
GROUP BY st.stor_name
ORDER BY st.stor_name;

--2
SELECT st.stor_name, SUM(t.price*sd.qty) as chiffre_dffaire
FROM stores st
    LEFT OUTER JOIN salesdetail sd ON st.stor_id = sd.stor_id
    LEFT OUTER JOIN titles t ON t.title_id = sd.title_id
GROUP BY st.stor_name
ORDER BY chiffre_dffaire desc;

--3
--Donnez la liste des livres de plus de $20, classés par type, en donnant pour chacun son type,
-- son titre, le nom de son éditeur et son prix.
SELECT t.title_id, t.type, t.title, p.pub_name, t.price
FROM titles t, publishers p
WHERE t.pub_id = p.pub_id
AND t.price > 20
ORDER BY t.type;

--4
--Donnez la liste des livres de plus de $20, classés par type, en donnant pour chacun son type,
--son titre, les noms de ses auteurs et son prix.
SELECT t.title_id, t.type, t.title, a.au_lname, a.au_fname, t.price
FROM titles t
    LEFT OUTER JOIN titleauthor ta ON t.title_id = ta.title_id
    LEFT OUTER JOIN authors a ON a.au_id = ta.au_id
WHERE t.price > 20
ORDER BY t.type;

--5
--Quelles sont les villes de Californie où l'on peut trouver un auteur et/ou un éditeur, mais
--aucun magasin ?
SELECT p.city
FROM publishers p
WHERE p.state = 'CA' and p.city IS NOT NULL
UNION ( SELECT a.city
        FROM authors a
        WHERE a.state = 'CA' and a.city IS NOT NULL)
EXCEPT ( SELECT st.city
         FROM stores st
         WHERE st.state = 'CA');

--6
-- Donnez la liste des auteurs en indiquant pour chacun, outre son nom et son prénom, le
-- nombre de livres de plus de 20 $ qu'il a écrits. Classez cela par ordre décroissant de nombre de livres,
-- et, en cas d'ex aequo, par ordre alphabétique. N'oubliez pas les auteurs qui n'ont écrit aucun livre de plus de 20 $
SELECT a.au_id, a.au_lname, a.au_fname, count(t.title_id) as counter
FROM authors a
    LEFT OUTER JOIN titleauthor ta ON ta.au_id = a.au_id
    LEFT OUTER JOIN titles t ON t.title_id = ta.title_id
    AND t.price > 20
GROUP BY a.au_id, a.au_lname, a.au_fname
ORDER BY counter desc, a.au_lname, a.au_fname
