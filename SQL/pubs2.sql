-- pubs2

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

-- CREATE TABLE

CREATE TABLE authors (
    au_id character(11) PRIMARY KEY NOT NULL,
    au_lname character varying(40) NOT NULL,
    au_fname character varying(20) NOT NULL,
    phone character varying(12) DEFAULT NULL,
    address character varying(40),
    city character varying(20),
    state character(2),
    country character varying(12)
);

CREATE TABLE publishers (
    pub_id character(4) PRIMARY KEY NOT NULL,
    pub_name character varying(40) NOT NULL,
    city character varying(20),
    state character(2)
);

CREATE TABLE stores (
    stor_id character(4) PRIMARY KEY NOT NULL,
    stor_name character varying(40) NOT NULL,
    stor_address character varying(40),
    city character varying(20),
    state character(2),
    country character varying(12)
);

CREATE TABLE sales (
    stor_id character(4) NOT NULL REFERENCES stores(stor_id),
    ord_num character varying(20) NOT NULL,
    date timestamp without time zone NOT NULL,
    PRIMARY KEY(stor_id,ord_num)
);

CREATE TABLE titles (
    title_id character varying(6) PRIMARY KEY NOT NULL,
    title character varying(80) NOT NULL,
    type character varying(12) DEFAULT NULL,
    pub_id character(4) REFERENCES publishers(pub_id) NOT NULL,
    price numeric(8,2),
    total_sales integer,
    pubdate timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE titleauthor (
    au_id character(11) NOT NULL REFERENCES authors(au_id),
    title_id character(6) NOT NULL REFERENCES titles(title_id),
    PRIMARY KEY (au_id, title_id)
);

CREATE TABLE salesdetail (
    stor_id character(4) NOT NULL,
    ord_num character varying(20) NOT NULL,
    title_id character(6) NOT NULL REFERENCES titles(title_id),
    qty smallint NOT NULL,
    PRIMARY KEY(stor_id, ord_num, title_id),
    FOREIGN KEY(stor_id, ord_num) REFERENCES sales(stor_id,ord_num)
);

-- GRANT

GRANT SELECT ON TABLE authors, publishers, stores, sales, salesdetail, titles, titleauthor TO public;

set datestyle = US;

--INSERT

INSERT INTO authors VALUES ('409-56-7008', 'Bennet', 'Abraham', '415 658-9932', '6223 Bateman St.', 'Berkeley', 'CA', 'USA');
INSERT INTO authors VALUES ('213-46-8915', 'Green', 'Marjorie', '415 986-7020', '309 63rd St. #411', 'Oakland', 'CA', 'USA');
INSERT INTO authors VALUES ('238-95-7766', 'Carson', 'Cheryl', '415 548-7723', '589 Darwin Ln.', 'Berkeley', 'CA', 'USA');
INSERT INTO authors VALUES ('998-72-3567', 'Ringer', 'Albert', '801 826-0752', '67 Seventh Av.', 'Salt Lake City', 'UT', 'USA');
INSERT INTO authors VALUES ('899-46-2035', 'Ringer', 'Anne', '801 826-0752', '67 Seventh Av.', 'Salt Lake City', 'UT', 'USA');
INSERT INTO authors VALUES ('722-51-5454', 'DeFrance', 'Michel', '219 547-9982', '3 Balding Pl.', 'Gary', 'IN', 'USA');
INSERT INTO authors VALUES ('807-91-6654', 'Panteley', 'Sylvia', '301 946-8853', '1956 Arlington Pl.', 'Rockville', 'MD', 'USA');
INSERT INTO authors VALUES ('893-72-1158', 'McBadden', 'Heather', '707 448-4982', '301 Putnam', 'Vacaville', 'CA', 'USA');
INSERT INTO authors VALUES ('724-08-9931', 'Stringer', 'Dirk', '415 843-2991', '5420 Telegraph Av.', 'Oakland', 'CA', 'USA');
INSERT INTO authors VALUES ('274-80-9391', 'Straight', 'Dick', '415 834-2919', '5420 College Av.', 'Oakland', 'CA', 'USA');
INSERT INTO authors VALUES ('756-30-7391', 'Karsen', 'Livia', '415 534-9219', '5720 McAuley St.', 'Oakland', 'CA', 'USA');
INSERT INTO authors VALUES ('724-80-9391', 'MacFeather', 'Stearns', '415 354-7128', '44 Upland Hts.', 'Oakland', 'CA', 'USA');
INSERT INTO authors VALUES ('427-17-2319', 'Dull', 'Ann', '415 836-7128', '3410 Blonde St.', 'Palo Alto', 'CA', 'USA');
INSERT INTO authors VALUES ('672-71-3249', 'Yokomoto', 'Akiko', '415 935-4228', '3 Silver Ct.', 'Walnut Creek', 'CA', 'USA');
INSERT INTO authors VALUES ('267-41-2394', 'O Leary', 'Michael', '408 286-2428', '22 Cleveland Av. #14', 'San Jose', 'CA', 'USA');
INSERT INTO authors VALUES ('472-27-2349', 'Gringlesby', 'Burt', '707 938-6445', 'PO Box 792', 'Covelo', 'CA', 'USA');
INSERT INTO authors VALUES ('527-72-3246', 'Greene', 'Morningstar', '615 297-2723', '22 Graybar House Rd.', 'Nashville', 'TN', 'USA');
INSERT INTO authors VALUES ('172-32-1176', 'White', 'Johnson', '408 496-7223', '10932 Bigge Rd.', 'Menlo Park', 'CA', 'USA');
INSERT INTO authors VALUES ('712-45-1867', 'del Castillo', 'Innes', '615 996-8275', '2286 Cram Pl. #86', 'Ann Arbor', 'MI', 'USA');
INSERT INTO authors VALUES ('846-92-7186', 'Hunter', 'Sheryl', '415 836-7128', '3410 Blonde St.', 'Palo Alto', 'CA', 'USA');
INSERT INTO authors VALUES ('486-29-1786', 'Locksley', 'Chastity', '415 585-4620', '18 Broadway Av.', 'San Francisco', 'CA', 'USA');
INSERT INTO authors VALUES ('648-92-1872', 'Blotchet-Halls', 'Reginald', '503 745-6402', '55 Hillsdale Bl.', 'Corvallis', 'OR', 'USA');
INSERT INTO authors VALUES ('341-22-1782', 'Smith', 'Meander', '913 843-0462', '10 Mississippi Dr.', 'Lawrence', 'KS', 'USA');
INSERT INTO authors VALUES ('125-42-3141', 'Van Roy', 'Peter', '02 435 34 35', '42 Rue du Paradis', 'Louvain-la-Neuve', 'BW', 'BEL');

INSERT INTO stores VALUES ('7066', 'Barnum''s', '567 Pasadena Ave.', 'Tustin', 'CA', 'USA');
INSERT INTO stores VALUES ('7067', 'News & Brews', '577 First St.', 'Los Gatos', 'CA', 'USA');
INSERT INTO stores VALUES ('7131', 'Doc-U-Mat: Quality Laundry and Books', '24-A Avrogado Way', 'Remulade', 'WA', 'USA');
INSERT INTO stores VALUES ('8042', 'Bookbeat', '679 Carson St.', 'Portland', 'OR', 'USA');
INSERT INTO stores VALUES ('6380', 'Eric the Read Books', '788 Catamaugus Ave.', 'Seattle', 'WA', 'USA');
INSERT INTO stores VALUES ('7896', 'Fricative Bookshop', '89 Madison St.', 'Fremont', 'CA', 'USA');
INSERT INTO stores VALUES ('5023', 'Thoreau Reading Discount Chain', '20435 Walden Expressway', 'Concord', 'MA', 'USA');


INSERT INTO publishers VALUES ('0736', 'New Age Books', 'Boston', 'MA');
INSERT INTO publishers VALUES ('0877', 'Binnet & Hardley', 'Washington', 'DC');
INSERT INTO publishers VALUES ('1389', 'Algodata Infosystems', 'Berkeley', 'CA');

INSERT INTO titles VALUES ('PC8888', 'Secrets of Silicon Valley', 'popular_comp', '1389', 20.00, 4095, '1987-06-12 00:00:00');
INSERT INTO titles VALUES ('BU1032', 'The Busy Executive''s Database Guide', 'business', '1389', 19.99, 4095, '1986-06-12 00:00:00');
INSERT INTO titles VALUES ('PS7777', 'Emotional Security: A New Algorithm', 'psychology', '0736', 7.99, 3336, '1988-06-12 00:00:00');
INSERT INTO titles VALUES ('PS3333', 'Prolonged Data Deprivation: Four Case Studies', 'psychology', '0736', 19.99,4072 , '1988-06-12 00:00:00');
INSERT INTO titles VALUES ('BU1111', 'Cooking with Computers: Surreptitious Balance Sheets', 'business', '1389', 11.95, 3876, '1988-06-09 00:00:00');
INSERT INTO titles VALUES ('MC2222', 'Silicon Valley Gastronomic Treats', 'mod_cook', '0877', 19.99, 2032, '1989-06-09 00:00:00');
INSERT INTO titles VALUES ('TC7777', 'Sushi, Anyone?', 'trad_cook', '0877', 14.99, 4095, '1987-06-12 00:00:00');
INSERT INTO titles VALUES ('TC4203', 'Fifty Years in Buckingham Palace Kitchens', 'trad_cook', '0877', 11.95, 15096, '1985-06-12 00:00:00');
INSERT INTO titles VALUES ('PC1035', 'But Is It User Friendly?', 'popular_comp', '1389', 22.95, 8780, '1986-06-30 00:00:00');
INSERT INTO titles VALUES ('BU2075', 'You Can Combat Computer Stress!', 'business', '0736', 2.99, 18722, '1985-06-30 00:00:00');
INSERT INTO titles VALUES ('PS2091', 'Is Anger the Enemy?', 'psychology', '0736', 10.95, 2045, '1989-06-15 00:00:00');
INSERT INTO titles VALUES ('PS2106', 'Life Without Fear', 'psychology', '0736', 7.00, 111, '1990-10-05 00:00:00');
INSERT INTO titles VALUES ('MC3021', 'The Gourmet Microwave', 'mod_cook', '0877', 2.99, 22246, '1985-06-18 00:00:00');
INSERT INTO titles VALUES ('TC3218', 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', 'trad_cook', '0877', 20.95, 375, '1990-10-21 00:00:00');
INSERT INTO titles VALUES ('MC3026', 'The Psychology of Computer Cooking', NULL, '0877', NULL, NULL, '2011-06-27 20:40:01.531');
INSERT INTO titles VALUES ('BU7832', 'Straight Talk About Computers', 'business', '1389', 19.99, 4095, '1987-06-22 00:00:00');
INSERT INTO titles VALUES ('PS1372', 'Computer Phobic and Non-Phobic Individuals: Behavior Variations', 'psychology', '0877', 21.59, 375, '1990-10-21 00:00:00');
INSERT INTO titles VALUES ('PC9999', 'Net Etiquette', 'popular_comp', '1389', NULL, NULL, '2011-06-27 20:40:01.531');
INSERT INTO titles VALUES ('CI6666', 'The Children of IPL', 'psychology', '1389', 3.14, NULL, '2011-05-05 00:00:00');

INSERT INTO sales VALUES ('7066', 'BA27618', '1985-10-12 00:00:00');
INSERT INTO sales VALUES ('5023', 'AB-123-DEF-425-1Z3', '1985-10-31 00:00:00');
INSERT INTO sales VALUES ('5023', 'AB-872-DEF-732-2Z1', '1985-11-06 00:00:00');
INSERT INTO sales VALUES ('8042', '12-F-9', '1986-07-13 00:00:00');
INSERT INTO sales VALUES ('7896', '124152', '1986-08-14 00:00:00');
INSERT INTO sales VALUES ('7131', 'Asoap132', '1986-11-16 00:00:00');
INSERT INTO sales VALUES ('5023', 'BS-345-DSE-860-1F2', '1986-12-12 00:00:00');
INSERT INTO sales VALUES ('7067', 'NB-1.142', '1987-01-02 00:00:00');
INSERT INTO sales VALUES ('5023', 'AX-532-FED-452-2Z7', '1990-12-01 00:00:00');
INSERT INTO sales VALUES ('5023', 'NF-123-ADS-642-9G3', '1987-07-18 00:00:00');
INSERT INTO sales VALUES ('7131', 'Fsoap867', '1987-09-08 00:00:00');
INSERT INTO sales VALUES ('7066', 'BA52498', '1987-10-27 00:00:00');
INSERT INTO sales VALUES ('8042', '91-A-7', '1991-03-20 00:00:00');
INSERT INTO sales VALUES ('8042', '91-V-7', '1991-03-20 00:00:00');
INSERT INTO sales VALUES ('8042', '55-V-7', '1991-03-20 00:00:00');
INSERT INTO sales VALUES ('8042', '13-J-9', '1988-01-13 00:00:00');
INSERT INTO sales VALUES ('7896', '234518', '1991-02-14 00:00:00');
INSERT INTO sales VALUES ('5023', 'GH-542-NAD-713-9F9', '1987-03-15 00:00:00');
INSERT INTO sales VALUES ('7131', 'Asoap432', '1990-12-20 00:00:00');
INSERT INTO sales VALUES ('5023', 'ZA-000-ASD-324-4D1', '1988-07-27 00:00:00');
INSERT INTO sales VALUES ('7066', 'BA71224', '1988-08-05 00:00:00');
INSERT INTO sales VALUES ('5023', 'ZD-123-DFG-752-9G8', '1991-03-21 00:00:00');
INSERT INTO sales VALUES ('8042', '13-E-7', '1989-05-23 00:00:00');
INSERT INTO sales VALUES ('7067', 'NB-3.142', '1990-06-13 00:00:00');
INSERT INTO sales VALUES ('5023', 'ZS-645-CAT-415-1B2', '1991-03-21 00:00:00');
INSERT INTO sales VALUES ('5023', 'XS-135-DER-432-8J2', '1991-03-21 00:00:00');
INSERT INTO sales VALUES ('5023', 'ZZ-999-ZZZ-999-0A0', '1991-03-21 00:00:00');
INSERT INTO sales VALUES ('6380', '342157', '1985-12-13 00:00:00');
INSERT INTO sales VALUES ('6380', '356921', '1991-02-17 00:00:00');
INSERT INTO sales VALUES ('6380', '234518', '1987-09-30 00:00:00');

INSERT INTO salesdetail VALUES ('7896', '234518', 'TC3218', 75);
INSERT INTO salesdetail VALUES ('7896', '234518', 'TC7777', 75);
INSERT INTO salesdetail VALUES ('7131', 'Asoap432', 'TC3218', 50);
INSERT INTO salesdetail VALUES ('7131', 'Asoap432', 'TC7777', 80);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'TC3218', 85);
INSERT INTO salesdetail VALUES ('8042', '91-A-7', 'PS3333', 90);
INSERT INTO salesdetail VALUES ('8042', '91-A-7', 'TC3218', 40);
INSERT INTO salesdetail VALUES ('8042', '91-A-7', 'PS2106', 30);
INSERT INTO salesdetail VALUES ('8042', '91-V-7', 'PS2106', 50);
INSERT INTO salesdetail VALUES ('8042', '55-V-7', 'PS2106', 31);
INSERT INTO salesdetail VALUES ('8042', '91-A-7', 'MC3021', 69);
INSERT INTO salesdetail VALUES ('5023', 'BS-345-DSE-860-1F2', 'PC1035', 1000);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'BU2075', 500);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'BU1032', 200);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'BU7832', 150);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'PS7777', 125);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'TC7777', 1000);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'BU1032', 1000);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'PC1035', 750);
INSERT INTO salesdetail VALUES ('7131', 'Fsoap867', 'BU1032', 200);
INSERT INTO salesdetail VALUES ('7066', 'BA52498', 'BU7832', 100);
INSERT INTO salesdetail VALUES ('7066', 'BA71224', 'PS7777', 200);
INSERT INTO salesdetail VALUES ('7066', 'BA71224', 'PC1035', 300);
INSERT INTO salesdetail VALUES ('7066', 'BA71224', 'TC7777', 350);
INSERT INTO salesdetail VALUES ('5023', 'ZD-123-DFG-752-9G8', 'PS2091', 1000);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'PS2091', 200);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'PS7777', 250);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'PS3333', 345);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'BU7832', 360);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'PS2091', 845);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'PS7777', 581);
INSERT INTO salesdetail VALUES ('5023', 'ZZ-999-ZZZ-999-0A0', 'PS1372', 375);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'BU1111', 175);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'BU7832', 885);
INSERT INTO salesdetail VALUES ('5023', 'ZD-123-DFG-752-9G8', 'BU7832', 900);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'TC4203', 550);
INSERT INTO salesdetail VALUES ('7131', 'Fsoap867', 'TC4203', 350);
INSERT INTO salesdetail VALUES ('7896', '234518', 'TC4203', 275);
INSERT INTO salesdetail VALUES ('7066', 'BA71224', 'TC4203', 500);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'TC4203', 512);
INSERT INTO salesdetail VALUES ('7131', 'Fsoap867', 'MC3021', 400);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'PC8888', 105);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'PC8888', 300);
INSERT INTO salesdetail VALUES ('7066', 'BA71224', 'PC8888', 350);
INSERT INTO salesdetail VALUES ('7067', 'NB-3.142', 'PC8888', 335);
INSERT INTO salesdetail VALUES ('7131', 'Asoap432', 'BU1111', 500);
INSERT INTO salesdetail VALUES ('7896', '234518', 'BU1111', 340);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'BU1111', 370);
INSERT INTO salesdetail VALUES ('5023', 'ZD-123-DFG-752-9G8', 'PS3333', 750);
INSERT INTO salesdetail VALUES ('8042', '13-J-9', 'BU7832', 300);
INSERT INTO salesdetail VALUES ('8042', '13-E-7', 'BU2075', 150);
INSERT INTO salesdetail VALUES ('8042', '13-E-7', 'BU1032', 300);
INSERT INTO salesdetail VALUES ('8042', '13-E-7', 'PC1035', 400);
INSERT INTO salesdetail VALUES ('8042', '91-A-7', 'PS7777', 180);
INSERT INTO salesdetail VALUES ('8042', '13-J-9', 'TC4203', 250);
INSERT INTO salesdetail VALUES ('8042', '13-E-7', 'TC4203', 226);
INSERT INTO salesdetail VALUES ('8042', '13-E-7', 'MC3021', 400);
INSERT INTO salesdetail VALUES ('8042', '91-V-7', 'BU1111', 390);
INSERT INTO salesdetail VALUES ('5023', 'AB-872-DEF-732-2Z1', 'MC3021', 5000);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'BU2075', 2000);
INSERT INTO salesdetail VALUES ('5023', 'GH-542-NAD-713-9F9', 'PC1035', 2000);
INSERT INTO salesdetail VALUES ('5023', 'ZA-000-ASD-324-4D1', 'PC1035', 2000);
INSERT INTO salesdetail VALUES ('5023', 'ZA-000-ASD-324-4D1', 'PS7777', 1500);
INSERT INTO salesdetail VALUES ('5023', 'ZD-123-DFG-752-9G8', 'BU2075', 3000);
INSERT INTO salesdetail VALUES ('5023', 'ZD-123-DFG-752-9G8', 'TC7777', 1500);
INSERT INTO salesdetail VALUES ('5023', 'ZS-645-CAT-415-1B2', 'BU2075', 3000);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'PS3333', 2687);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'TC7777', 1090);
INSERT INTO salesdetail VALUES ('5023', 'XS-135-DER-432-8J2', 'PC1035', 2138);
INSERT INTO salesdetail VALUES ('5023', 'ZZ-999-ZZZ-999-0A0', 'MC2222', 2032);
INSERT INTO salesdetail VALUES ('5023', 'ZZ-999-ZZZ-999-0A0', 'BU1111', 1001);
INSERT INTO salesdetail VALUES ('5023', 'ZA-000-ASD-324-4D1', 'BU1111', 1100);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'BU7832', 1400);
INSERT INTO salesdetail VALUES ('5023', 'BS-345-DSE-860-1F2', 'TC4203', 2700);
INSERT INTO salesdetail VALUES ('5023', 'GH-542-NAD-713-9F9', 'TC4203', 2500);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'TC4203', 3500);
INSERT INTO salesdetail VALUES ('5023', 'BS-345-DSE-860-1F2', 'MC3021', 4500);
INSERT INTO salesdetail VALUES ('5023', 'AX-532-FED-452-2Z7', 'MC3021', 1600);
INSERT INTO salesdetail VALUES ('5023', 'NF-123-ADS-642-9G3', 'MC3021', 2550);
INSERT INTO salesdetail VALUES ('5023', 'ZA-000-ASD-324-4D1', 'MC3021', 3000);
INSERT INTO salesdetail VALUES ('5023', 'ZS-645-CAT-415-1B2', 'MC3021', 3200);
INSERT INTO salesdetail VALUES ('5023', 'BS-345-DSE-860-1F2', 'BU2075', 2200);
INSERT INTO salesdetail VALUES ('5023', 'GH-542-NAD-713-9F9', 'BU1032', 1500);
INSERT INTO salesdetail VALUES ('5023', 'ZZ-999-ZZZ-999-0A0', 'PC8888', 1005);
INSERT INTO salesdetail VALUES ('7896', '124152', 'BU2075', 42);
INSERT INTO salesdetail VALUES ('7896', '124152', 'PC1035', 25);
INSERT INTO salesdetail VALUES ('7131', 'Asoap132', 'BU2075', 35);
INSERT INTO salesdetail VALUES ('7067', 'NB-1.142', 'PC1035', 34);
INSERT INTO salesdetail VALUES ('7067', 'NB-1.142', 'TC4203', 53);
INSERT INTO salesdetail VALUES ('8042', '12-F-9', 'BU2075', 30);
INSERT INTO salesdetail VALUES ('8042', '12-F-9', 'BU1032', 94);
INSERT INTO salesdetail VALUES ('7066', 'BA27618', 'BU2075', 200);
INSERT INTO salesdetail VALUES ('7896', '124152', 'TC4203', 350);
INSERT INTO salesdetail VALUES ('7066', 'BA27618', 'TC4203', 230);
INSERT INTO salesdetail VALUES ('7066', 'BA27618', 'MC3021', 200);
INSERT INTO salesdetail VALUES ('7131', 'Asoap132', 'MC3021', 137);
INSERT INTO salesdetail VALUES ('7067', 'NB-1.142', 'MC3021', 270);
INSERT INTO salesdetail VALUES ('7067', 'NB-1.142', 'BU2075', 230);
INSERT INTO salesdetail VALUES ('7131', 'Asoap132', 'BU1032', 345);
INSERT INTO salesdetail VALUES ('7067', 'NB-1.142', 'BU1032', 136);
INSERT INTO salesdetail VALUES ('8042', '12-F-9', 'TC4203', 300);
INSERT INTO salesdetail VALUES ('8042', '12-F-9', 'MC3021', 270);
INSERT INTO salesdetail VALUES ('8042', '12-F-9', 'PC1035', 133);
INSERT INTO salesdetail VALUES ('5023', 'AB-123-DEF-425-1Z3', 'TC4203', 2500);
INSERT INTO salesdetail VALUES ('5023', 'AB-123-DEF-425-1Z3', 'BU2075', 4000);
INSERT INTO salesdetail VALUES ('6380', '342157', 'BU2075', 200);
INSERT INTO salesdetail VALUES ('6380', '342157', 'MC3021', 250);
INSERT INTO salesdetail VALUES ('6380', '356921', 'PS3333', 200);
INSERT INTO salesdetail VALUES ('6380', '356921', 'PS7777', 500);
INSERT INTO salesdetail VALUES ('6380', '356921', 'TC3218', 125);
INSERT INTO salesdetail VALUES ('6380', '234518', 'BU2075', 135);
INSERT INTO salesdetail VALUES ('6380', '234518', 'BU1032', 320);
INSERT INTO salesdetail VALUES ('6380', '234518', 'TC4203', 300);
INSERT INTO salesdetail VALUES ('6380', '234518', 'MC3021', 400);

INSERT INTO titleauthor VALUES ('409-56-7008', 'BU1032');
INSERT INTO titleauthor VALUES ('486-29-1786', 'PS7777');
INSERT INTO titleauthor VALUES ('486-29-1786', 'PC9999');
INSERT INTO titleauthor VALUES ('712-45-1867', 'MC2222');
INSERT INTO titleauthor VALUES ('172-32-1176', 'PS3333');
INSERT INTO titleauthor VALUES ('213-46-8915', 'BU1032');
INSERT INTO titleauthor VALUES ('238-95-7766', 'PC1035');
INSERT INTO titleauthor VALUES ('213-46-8915', 'BU2075');
INSERT INTO titleauthor VALUES ('998-72-3567', 'PS2091');
INSERT INTO titleauthor VALUES ('899-46-2035', 'PS2091');
INSERT INTO titleauthor VALUES ('998-72-3567', 'PS2106');
INSERT INTO titleauthor VALUES ('722-51-5454', 'MC3021');
INSERT INTO titleauthor VALUES ('899-46-2035', 'MC3021');
INSERT INTO titleauthor VALUES ('807-91-6654', 'TC3218');
INSERT INTO titleauthor VALUES ('274-80-9391', 'BU7832');
INSERT INTO titleauthor VALUES ('427-17-2319', 'PC8888');
INSERT INTO titleauthor VALUES ('846-92-7186', 'PC8888');
INSERT INTO titleauthor VALUES ('756-30-7391', 'PS1372');
INSERT INTO titleauthor VALUES ('724-80-9391', 'PS1372');
INSERT INTO titleauthor VALUES ('724-80-9391', 'BU1111');
INSERT INTO titleauthor VALUES ('267-41-2394', 'BU1111');
INSERT INTO titleauthor VALUES ('672-71-3249', 'TC7777');
INSERT INTO titleauthor VALUES ('267-41-2394', 'TC7777');
INSERT INTO titleauthor VALUES ('472-27-2349', 'TC7777');
INSERT INTO titleauthor VALUES ('648-92-1872', 'TC4203');
INSERT INTO titleauthor VALUES ('427-17-2319', 'CI6666');

