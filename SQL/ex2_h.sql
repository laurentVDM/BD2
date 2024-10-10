--ex 2.h.ii

--1
SELECT a.au_id, a.au_lname,a.au_fname, a.address, t.title_id,
       COALESCE(t.title, 'aucun livre')
FROM authors a
    LEFT OUTER JOIN titleauthor ta ON a.au_id = ta.au_id
    LEFT OUTER JOIN titles t ON ta.title_id = t.title_id
ORDER BY t.title_id
