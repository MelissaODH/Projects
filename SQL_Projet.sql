
/*PROJET N°1 SQL

       

/*Question 1*/
DROP TABLE IF EXISTS `payments2`;
CREATE TABLE `payments2` (
  `customerNumber` int(11) NOT NULL,
  `checkNumber` varchar(50) NOT NULL,
  `paymentDate` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`customerNumber`,`checkNumber`),
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `payments2` 
SELECT *
FROM `payments` ORDER BY customerNumber LIMIT 5;


/*Question 2*/
DROP TABLE IF EXISTS `payments3`;

CREATE TABLE `payments3` (
  `customerNumber` int(11) NOT NULL,
  `customerName` varchar(50) NOT NULL,
  `total_checks` int(2) NOT NULL,
  PRIMARY KEY (`customerNumber`),
  CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `payments3` (`customerNumber`, `customerName`,`total_checks`)
SELECT E.customerNumber, C.customerName,COUNT(DISTINCT checkNumber) AS total_checks
FROM `payments` E
INNER JOIN customers C
	ON C.customerNumber = E.customerNumber
GROUP BY E.customerNumber,C.customerName;

/* Autre méthode : Utiliser ALTER TABLE */


/*Question 3*/
DROP TABLE IF EXISTS `payments4`;

CREATE TABLE `payments4` (
  `customerNumber` int(11) NOT NULL,
  `checkNumber` varchar(50) NOT NULL,
  `paymentDate` date NOT NULL,
  `annee` int(2) NOT NULL,
  `mois` int(2) NOT NULL,
  `jour` int(2) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`customerNumber`,`checkNumber`),
  CONSTRAINT `payments_ibfk_4` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `payments4` (`customerNumber`,`checkNumber`,`paymentDate`,`annee`,`mois`,`jour`,`amount`)
SELECT customerNumber,checkNumber,paymentDate,YEAR(paymentDate),MONTH(paymentDate),DAY(paymentDate),amount
FROM `payments` ;


/*Question 4*/
DROP TABLE IF EXISTS `payments5`;

CREATE TABLE `payments5` (
  `customerNumber` int(11) NOT NULL,
  `checkNumber` varchar(50) NOT NULL,
  `paymentDate` date NOT NULL,
  `annee` int(2) NOT NULL,
  `mois` int(2) NOT NULL,
  `jour` int(2) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `flag_summer` int(1) NOT NULL,
  PRIMARY KEY (`customerNumber`,`checkNumber`),
  CONSTRAINT `payments_ibfk_5` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `payments5` (`customerNumber`,`checkNumber`,`paymentDate`,`annee`,`mois`,`jour`,`amount`,`flag_summer`)
SELECT customerNumber,checkNumber,paymentDate,annee,mois,jour,amount,IF(6<=mois and mois<=8,1,0) 
FROM `payments4` ;

/*Question 5*/
DROP TABLE IF EXISTS `payments6`;

CREATE TABLE `payments6` (
  `customerNumber` int(11) NOT NULL,
  `summer_expense` decimal(10,2) NOT NULL,
  PRIMARY KEY (`customerNumber`),
  CONSTRAINT `payments_ibfk_6` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `payments6` (`customerNumber`,`summer_expense`)
select customerNumber,SUM(amount) AS summer_expense
from `payments5` 
where flag_summer=1
group by customerNumber;

/*Question 6*/
DROP TABLE IF EXISTS `customers1`;

CREATE TABLE `customers1` (
  `contactLastName` varchar(50) NOT NULL,
  `contactFirstName` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `continent` varchar(50) NOT NULL,  
  `creditLimit` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `customers1` (`contactLastName`,`contactFirstName`,`city`,`country`,`continent`,`creditLimit` )
select contactLastName,contactFirstName,city,country,IF(country="USA","North America","Europe"),creditLimit
from `customers`
where creditLimit between 10000 and 30000;

/*Question 7*/
DROP TABLE IF EXISTS `employee_profile`;

CREATE TABLE `employee_profile` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `jobTitle` varchar(50) NOT NULL,
  `number_of_members_by_job` INT(3) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TEMPORARY TABLE IF NOT EXISTS T AS (
	SELECT JobTitle,SUM(1) AS number_of_members_by_job
    FROM `employees`
    GROUP BY jobTitle
);


INSERT INTO `employee_profile`(`employeeNumber`,`lastName`,`firstName`,`jobTitle`,`number_of_members_by_job`)
SELECT E.employeeNumber,E.lastName,E.firstName,E.jobTitle,number_of_members_by_job
FROM `employees` E
INNER JOIN T C 
	ON E.jobTitle = C.JobTitle;

/*Question 8*/
DROP TABLE IF EXISTS `employee_profile2`;

CREATE TABLE `employee_profile2` (
  `employeeNumber` int(11) NOT NULL,
  `number_of_customers` int(3) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `employee_profile2`(`employeeNumber`,`number_of_customers`)
SELECT E.employeeNumber,COUNT(DISTINCT customerNumber) AS number_of_customers
FROM `customers` C
INNER JOIN `employee_profile` E
	ON C.salesRepEmployeeNumber = E.employeeNumber
GROUP BY E.employeeNumber;

/*Question 9*/
DROP TABLE IF EXISTS `employee_profile3`;

CREATE TABLE `employee_profile3` (
  `employeeNumber` int(11) NOT NULL,
  `flag_france` int(1) NOT NULL,
  `flag_usa` int(1) NOT NULL,
  `flag_germany` int(1) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `employee_profile3`(`employeeNumber`,`flag_france`,`flag_usa`,`flag_germany`)
WITH EmpCoun AS (
SELECT  E.employeeNumber,C.country
FROM customers C
INNER JOIN `employees` E
	ON C.salesRepEmployeeNumber = E.employeeNumber
GROUP BY E.employeeNumber,C.country ) 

SELECT E.employeeNumber
	  ,IF(EC.employeeNumber IS NOT NULL,1,0) AS flag_france
	  ,IF(EC1.employeeNumber IS NOT NULL,1,0) AS flag_usa
      ,IF(EC2.employeeNumber IS NOT NULL,1,0) AS flag_germany
FROM Employees E
LEFT JOIN EmpCoun EC
	ON E.employeeNumber = EC.employeeNumber
    AND EC.country = "France"
LEFT JOIN EmpCoun EC1
	ON E.employeeNumber = EC1.employeeNumber
    AND EC1.country = "USA"
LEFT JOIN EmpCoun EC2
	ON E.employeeNumber = EC2.employeeNumber
    AND EC2.country = "Germany";
    
/*Question 10*/

DROP TABLE IF EXISTS `employee_profile5`;

CREATE TABLE `employee_profile5` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  KEY `reportsTo` (`reportsTo`),
  KEY `officeCode` (`officeCode`),
  CONSTRAINT `employees_ibfk_5` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`),
  CONSTRAINT `employees_ibfk_6` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO employee_profile5
SELECT * 
FROM employees
WHERE jobTitle LIKE '%Sale%Manager%';


DROP TABLE IF EXISTS `customers_salesmanager`;

CREATE TABLE `customers_salesmanager` (
`customerNumber` int(11) NOT NULL,
  `customerName` varchar(50) NOT NULL,
  `contactLastName` varchar(50) NOT NULL,
  `contactFirstName` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `addressLine1` varchar(50) NOT NULL,
  `addressLine2` varchar(50) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `postalCode` varchar(15) DEFAULT NULL,
  `country` varchar(50) NOT NULL,
  `salesRepEmployeeNumber` int(11) DEFAULT NULL,
  `creditLimit` decimal(10,2) DEFAULT NULL,
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
   PRIMARY KEY (`customerNumber`),
  KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),
  CONSTRAINT `customers_ibfk_8` FOREIGN KEY (`salesRepEmployeeNumber`) REFERENCES `employees` (`employeeNumber`),
  KEY `reportsTo` (`reportsTo`),
  KEY `officeCode` (`officeCode`),
  CONSTRAINT `employees_ibfk_7` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`),
  CONSTRAINT `employees_ibfk_8` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO customers_salesmanager
SELECT C.*,E.*
FROM customers C
INNER JOIN employees E
	ON C.salesRepEmployeeNumber = E.employeeNumber
LEFT JOIN employee_profile5 E5
	ON E.employeeNumber = E5.employeeNumber
    AND E.jobTitle = E5.jobTitle
WHERE E5.employeeNumber IS NULL;



