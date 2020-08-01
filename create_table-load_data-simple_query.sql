DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS ProductPrice;
DROP TABLE IF EXISTS Ingredient;
DROP TABLE IF EXISTS Recipe;
DROP TABLE IF EXISTS TruckEvent;
DROP TABLE IF EXISTS Sale;
DROP TABLE IF EXISTS SaleDetail;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS SupplierPhone;
DROP TABLE IF EXISTS LocalSupplier;
DROP TABLE IF EXISTS NationalSupplier;
DROP TABLE IF EXISTS IngQuote;
DROP TABLE IF EXISTS QuoteItem;
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS InventoryItem;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Maintenance;
DROP TABLE IF EXISTS MaintenanceLog;


#1. creat tables

#1.1 product
CREATE TABLE IF NOT EXISTS Product 
(
	productCode CHAR(3) NOT NULL, 
	productName VARCHAR(50) NOT NULL, 
	PRIMARY KEY  (productCode),
	UNIQUE (productName)  
);

#1.2 product price

CREATE TABLE IF NOT EXISTS ProductPrice 
(
	productCode CHAR(3) NOT NULL, 
	startDate DATE NOT NULL, 
	cost DECIMAL(5, 2) NULL,
	price DECIMAL(5, 2) NULL,
	PRIMARY KEY (productCode, startDate),
	FOREIGN KEY(productCode) REFERENCES Product(productCode)
);

#1.3 Ingredient


CREATE TABLE IF NOT EXISTS Ingredient 
(
	ingId INTEGER NOT NULL AUTO_INCREMENT,
	ingName VARCHAR(50) NOT NULL,
	category VARCHAR(50) NOT NULL,
	PRIMARY KEY (ingId),
	UNIQUE (ingName, category)	
);

#1.4 recipe

CREATE TABLE IF NOT EXISTS Recipe 
(
	productCode CHAR(3) NOT NULL,
	ingId INTEGER NOT NULL,
	qty FLOAT NOT NULL,
	unit VARCHAR(20) NOT NULL,
	PRIMARY KEY (productCode, ingId),
	FOREIGN KEY (productCode) REFERENCES Product(productCode),
	FOREIGN KEY (ingId) REFERENCES Ingredient (ingId)
);

#1.5 truckEvent

CREATE TABLE IF NOT EXISTS TruckEvent 
(
	eventId INTEGER NOT NULL AUTO_INCREMENT,
	eventName VARCHAR(200) NOT NULL,
	eventStart DATETIME NULL,
	eventEnd DATETIME NULL,
	PRIMARY KEY(eventId),
	UNIQUE (eventName, eventStart)
);

#1.6 sale

CREATE TABLE IF NOT EXISTS Sale 
(
	saleId INTEGER NOT NULL AUTO_INCREMENT,
	eventId INTEGER NOT NULL,
	productCode CHAR(3) NOT NULL,
	PRIMARY KEY (saleId),
	FOREIGN KEY (eventId) REFERENCES TruckEvent (eventId),
	FOREIGN KEY (productCode) REFERENCES Product (productCode)
);

#1.7 saledetail 

CREATE TABLE IF NOT EXISTS SaleDetail 
(
	saleId INTEGER NOT NULL,
	ingId INTEGER NOT NULL,
	qty FLOAT NOT NULL,
	unit VARCHAR(20) NOT NULL,
	PRIMARY KEY (saleId, ingId),
	FOREIGN KEY (saleId) REFERENCES Sale (saleId),
	FOREIGN KEY (ingId) REFERENCES Ingredient (ingId)
);

#1.8 supplier 

CREATE TABLE IF NOT EXISTS Supplier 
(
	supplierId INTEGER NOT NULL AUTO_INCREMENT,
	supplierName VARCHAR(150) NULL,
	street VARCHAR(150) NULL,
	city VARCHAR(150) NULL,
	state VARCHAR(50) NULL,
	postalCode VARCHAR(15) NULL,
	country VARCHAR(150) NULL,
	PRIMARY KEY (supplierId),
	UNIQUE (supplierName, street, city)
);

#1.9 supplierphone

CREATE TABLE IF NOT EXISTS SupplierPhone 
(
	supplierId INTEGER NOT NULL,
	phoneType VARCHAR(50) NOT NULL,
	phoneNumber VARCHAR(20) NULL,
	PRIMARY KEY (supplierId, phoneType)
);

# 1.10 LocalSupplier


CREATE TABLE IF NOT EXISTS LocalSupplier 
(
	supplierId INTEGER NOT NULL,
	transportFee DECIMAL(5, 2) NULL,
	PRIMARY KEY (supplierId),
	FOREIGN KEY (supplierId) REFERENCES Supplier (supplierId)
);

#1.11 nationalsupplier

CREATE TABLE IF NOT EXISTS NationalSupplier 
(
	supplierId INTEGER NOT NULL,
	mileageCost DECIMAL(5, 3) NOT NULL,
	distance DECIMAL(7, 2) NOT NULL,
	PRIMARY KEY (supplierId),
	FOREIGN KEY (supplierId) REFERENCES Supplier (supplierId)
);

#1.12 ingQuote


CREATE TABLE IF NOT EXISTS IngQuote 
(
	quoteId INTEGER NOT NULL AUTO_INCREMENT,
	supplierId INTEGER NOT NULL,
	issueDate DATE NOT NULL,
	expirationDate DATE NOT NULL,
	tax DECIMAL(5, 2) NOT NULL, 
	fees DECIMAL(5, 2) NOT NULL,  
	total DECIMAL(6, 2) NULL,  
	PRIMARY KEY (quoteId),
	FOREIGN KEY (supplierId) REFERENCES Supplier (supplierId),
	UNIQUE (supplierId, issueDate)
);

#1.13 quoteItem

CREATE TABLE IF NOT EXISTS QuoteItem 
(
	quoteId INTEGER NOT NULL,
	ingId INTEGER NOT NULL,
	qty FLOAT NOT NULL,
	unitCost DECIMAL(5, 2) NOT NULL,
	unit VARCHAR(20) NOT NULL,
	PRIMARY KEY(quoteId, ingId),
	FOREIGN KEY (quoteId) REFERENCES IngQuote (quoteId),
	FOREIGN KEY (ingId) REFERENCES Ingredient (ingId)
);

#1.14 Delivery

CREATE TABLE IF NOT EXISTS Delivery 
(
	deliveryId INTEGER NOT NULL AUTO_INCREMENT,
	quoteId INTEGER NOT NULL,
	orderDate DATE NOT NULL, 
	deliveryDate DATE NULL, 
	PRIMARY KEY (deliveryId),
	FOREIGN KEY (quoteId) REFERENCES IngQuote (quoteId)
);


#1.15 inventory Item


CREATE TABLE IF NOT EXISTS InventoryItem 
(
	ingId INTEGER NOT NULL,
	quoteId INTEGER NOT NULL,
	expirationDate DATE NULL,
	stockQty FLOAT NOT NULL,
	unit VARCHAR(20) NOT NULL,
	qtyRemaining FLOAT NOT NULL,
	PRIMARY KEY (ingId, quoteId),
	FOREIGN KEY (quoteId) REFERENCES IngQuote(quoteId),
	FOREIGN KEY (ingId) REFERENCES Ingredient (ingId)
);


#1.16 Equipment
CREATE TABLE IF NOT EXISTS Equipment 
(
	equipmentName VARCHAR(50) NOT NULL,
	installDate DATE NOT NULL,
	PRIMARY KEY (equipmentName)
);

#1.17 Maintenance 
CREATE TABLE IF NOT EXISTS Maintenance 
(
	maintId INTEGER NOT NULL AUTO_INCREMENT,
	equipmentName VARCHAR(50) NOT NULL,
	description VARCHAR(150) NULL,
	beforeFlag INTEGER NOT NULL,
	triggerAmount INTEGER NOT NULL,
	triggerUnit VARCHAR(20) NOT NULL,
	duration INTEGER NOT NULL,
	PRIMARY KEY (maintId),
	FOREIGN KEY (equipmentName) REFERENCES Equipment (equipmentName)
);


#1.18 MaintenanceLog
CREATE TABLE IF NOT EXISTS MaintenanceLog 
(
	maintId INTEGER NOT NULL,
	datePerformed DATE NOT NULL,
	duration INTEGER NULL,
	notes TEXT NULL,
	PRIMARY KEY (maintId, datePerformed)
);

#2.1 533 sundae
INSERT INTO Product 
VALUES ('533','533 sundae'),
	   ('sx','extra sundae topping'),
	   ('mt','monkey tail'),
	   ('dk','drink');
       
INSERT INTO ProductPrice 
VALUES 	('sx','2018-03-1',0.05,0.25),
		('mt','2018-03-1',2.5,5),
		('dk','2018-03-1',0.44,0.75),
		('533','2018-03-1',null,4);

INSERT INTO Ingredient (ingName,category) 
VALUES 	('10 oz dish','cup'),
		('tall napkin','paper goods'),
		('chocolate','ice cream base'),
		('vanilla','ice cream base'),
		('sprinkles','topping'),
		('oreo','topping'),
		('peanuts','topping'),
		('no topping','topping'),
		('short spoon','spoon'),
		('hot fudge','topping'),
		('monkey tail','others'),
		('coke','drink'),
		('sprite','drink'),
		('water','drink'),
        ('general base', 'ice cream base'),
        ('general topping', 'topping'),
        ('general drink', 'drink');
        
INSERT INTO Recipe
VALUES  ('533', 1,1, 'item'),
		('533', 2, 1, 'item'),
		('533', 15, 6, 'ounce'),
		('533', 16, 1.5, 'ounce'),
		('533', 9, 1, 'item'),
		('533', 10, 1.5, 'ounce'),
		('sx', 16, 1.5, 'ounce'),
		('mt', 11, 1, 'item'),
		('dk', 17, 1, 'item');


#2.2 Equipment
INSERT INTO Equipment 
VALUES 	('Rice','2017-03-01'),
		('Owl','2017-03-01'),
		('generator','2017-03-01');

INSERT INTO Maintenance (equipmentName,description,beforeFlag,triggerAmount,triggerUnit,duration) 
VALUES  ('Rice','clean', 0, 7, 'day', 120), 
		('Owl','clean', 0, 7, 'day', 120), 
		('generator','refuel', 0, 40,'hour', 10), 
		('generator','oil&filter change', 0, 200, 'hour', 10); 

INSERT INTO MaintenanceLog  
VALUES  (3, '2018-03-01', null, 'Purchase more diesel!'),
		(1, '2018-03-02', 100, null),
		(2, '2018-03-02', 110, null);

#2.3 TruckEvent
INSERT INTO TruckEvent (eventName, eventStart, eventEnd)
VALUES ('GSA study break', '2018-03-01 20:00:00', '2018-03-01 23:00:00');

INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'533');
INSERT INTO Sale(eventId,productCode) VALUES (1,'mt');
INSERT INTO Sale(eventId,productCode) VALUES (1,'mt');
INSERT INTO Sale(eventId,productCode) VALUES (1,'mt');
INSERT INTO Sale(eventId,productCode) VALUES (1,'mt');
INSERT INTO Sale(eventId,productCode) VALUES (1,'mt');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');
INSERT INTO Sale(eventId,productCode) VALUES (1,'dk');


INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (1,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (2,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (3,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (4,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (5,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (6,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (7,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (8,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (9,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,8,0,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (10,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (11,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (12,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (13,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (14,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (15,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (16,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (17,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (18,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (19,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (20,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (21,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (22,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (23,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (24,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,4,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (25,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (26,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (27,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (28,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (29,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,6,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (30,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,7,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (31,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,7,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (32,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,7,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (33,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (34,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (35,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (36,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (37,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (38,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (39,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (40,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (41,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (42,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (43,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (44,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (45,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (46,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (47,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (48,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (49,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (50,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (51,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (52,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,1,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,2,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,3,6,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,5,1.5,'ounce');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,9,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (53,10,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (54,11,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (55,11,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (56,11,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (57,11,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (58,11,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (59,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (60,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (61,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (62,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (63,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (64,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (65,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (66,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (67,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (68,12,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (69,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (70,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (71,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (72,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (73,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (74,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (75,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (76,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (77,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (78,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (79,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (80,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (81,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (82,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (83,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (84,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (85,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (86,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (87,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (88,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (89,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (90,13,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (91,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (92,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (93,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (94,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (95,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (96,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (97,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (98,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (99,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (100,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (101,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (102,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (103,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (104,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (105,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (106,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (107,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (108,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (109,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (110,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (111,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (112,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (113,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (114,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (115,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (116,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (117,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (118,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (119,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (120,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (121,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (122,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (123,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (124,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (125,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (126,14,1,'item');
INSERT INTO SaleDetail(saleId,ingId,qty,unit) VALUES (127,14,1,'item');

#2.4 quotes
INSERT INTO Supplier (supplierName,street,city,state,postalCode,country) 
VALUES 	('Houston''s Best Food', '943 University Blvd', 'Houston','TX','77005','USA'), 
		('Local Premium Food','101 Main St', 'Houston','TX','77004','USA'),
		('Best Food in Canada', '735 First Ave.','Toronto','Ontario', 'M4B 1B5','Canada'),
		('LA Ice Cream Supply', '535 King St.','Lake Charles','LA','70601',null);
        
        
INSERT INTO LocalSupplier (supplierId,transportFee) 
VALUES 	(1, 7),
		(2, 5);

INSERT INTO NationalSupplier (supplierId, mileageCost,distance) 
VALUES 	( 3,0.1,1530),
		( 4,0.11,148);

INSERT INTO ingQuote (supplierId,issueDate,expirationDate,tax,fees,total) 
VALUES 	(1,'2018-02-02','2018-02-10',5.98,7,null), 
		(2,'2018-02-03','2018-02-09',6.35,5,null); 

INSERT INTO Ingredient (ingName, category)
VALUES ('strawberries', 'fruits');

INSERT INTO quoteItem () 
VALUES 	(1,18,20,2,'pound'), 
		(1,4,5,3,'gallon'), 
		(1,3,5,3.5,'gallon'), 
		(2,18,25,1.75,'pound'), 
		(2,4,5,3.2,'gallon'), 
		(2,3,5,3.45,'gallon'); 

/*3.0.1 
	I use numeric types such as decimal and float. Because decimal type can choose different precision and scale, so that I could tailor attributes with different precision and scale as long as the scale
	can cover all the possible values and the precision makes sense. Float type is used for attributes that do not require a very high precision and it is not as expensive as decimal type.


3.0.2 
	advantage: easy to search for a certain gradient 
	disadvantage：occupy odditional space

3.0.3 
	The combination of equipmentName and description can be used as the primary key.

3.0.4 
    We could add a new table truck with attributes truckID (primary key, integer and auto_increment), truckName, purchaseDate
	Then for or the equipment table, we should add a truckID column, and the primary key should be the combination of truckId and equipmentName.
	Also, for the maintenance table and the maintenance log table, we need to add the truckId column, and combine the truckId with the current primary key.


3.0.5 
	vanilla 

*/

#4.0.1
SELECT p.productCode, p.productName, i.ingId, i.ingName, i.category, r.qty, r.unit
FROM Recipe r
JOIN Product p ON  r.productCode = p.productCode
JOIN Ingredient i ON r.ingId = i.ingId
WHERE p.productName = '533 sundae'
ORDER BY i.ingName;

/* 
result:
productCode, productName, ingId, ingName, category, qty, unit
'533', '533 sundae', '1', '10 oz dish', 'cup', '1', 'item'
'533', '533 sundae', '15', 'general base', 'ice cream base', '6', 'ounce'
'533', '533 sundae', '16', 'general topping', 'topping', '1.5', 'ounce'
'533', '533 sundae', '10', 'hot fudge', 'topping', '1.5', 'ounce'
'533', '533 sundae', '9', 'short spoon', 'spoon', '1', 'item'
'533', '533 sundae', '2', 'tall napkin', 'paper goods', '1', 'item'
*/

#4.0.2
 
Select quoteid
From
(SELECT   q.quoteId as qid,sum(q.qty*q.unitCost) as icost
From quoteItem AS q
group by quoteId) s1
Join IngQuote s2 on s1.qid=s2.quoteId
ORDER BY s2.tax+s2.fees+s1.icost
limit 1;


/* 
result:1
*/


#4.0.3
SELECT SUM(p.price) totalPrice
FROM Sale s
JOIN ProductPrice p 
ON s.productCode = p.productCode;
/*
result:288.75
*/

