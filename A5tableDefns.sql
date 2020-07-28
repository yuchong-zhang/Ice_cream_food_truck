DROP TABLE IF EXISTS productPrice;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS quoteItem;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS inventoryItem;
DROP TABLE IF EXISTS ingQuote;
DROP TABLE IF EXISTS supplierPhone;
DROP TABLE IF EXISTS localSupplier;
DROP TABLE IF EXISTS nationalSupplier;
DROP TABLE IF EXISTS saleDetail;
DROP TABLE IF EXISTS maintenance;
DROP TABLE IF EXISTS maintenanceLog;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS eventLog;
DROP TABLE IF EXISTS truckEvent;
DROP TABLE IF EXISTS xtra;
DROP TABLE IF EXISTS productType;
DROP TABLE IF EXISTS toDo;


/* find foreign key references
SELECT 
  TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
FROM
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
  REFERENCED_TABLE_SCHEMA = 'comp533Sp18' AND
  REFERENCED_TABLE_NAME = 'ingQuote';
*/

CREATE TABLE IF NOT EXISTS product (
	productCode CHAR(3),
    productName VARCHAR(50) NOT NULL,
	PRIMARY KEY(productCode),
    UNIQUE (productName)
);

CREATE TABLE IF NOT EXISTS productPrice (
	productCode CHAR(3) NOT NULL,
    startDate DATE NOT NULL,
    cost DECIMAL(6,2) NULL,
    price DECIMAL(6,2) NULL,
	PRIMARY KEY(productCode, startDate),
	FOREIGN KEY(productCode) REFERENCES product(productCode)
);


CREATE TABLE IF NOT EXISTS ingredient (
	ingId INTEGER,
    ingName VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    PRIMARY KEY(ingId),
	UNIQUE(ingName, category)
  );

# composes relation
CREATE TABLE IF NOT EXISTS recipe (
	ingId INTEGER,
 	productCode CHAR(3) NOT NULL,
	qty DECIMAL(5,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
	PRIMARY KEY(productCode, ingId),
 	FOREIGN KEY(productCode) REFERENCES product(productCode),
	FOREIGN KEY(ingId) REFERENCES ingredient(ingId)
 );

CREATE TABLE IF NOT EXISTS supplier (
	supplierId INTEGER,
	supplierName VARCHAR(150),
	street VARCHAR(150),
	city VARCHAR(150),
	state VARCHAR(50),
	postalCode VARCHAR(15),
	country VARCHAR(150),
	PRIMARY KEY(supplierId),
    UNIQUE(supplierName, street, city)
);

CREATE TABLE IF NOT EXISTS ingQuote (
	quoteId INTEGER AUTO_INCREMENT,
	supplierId INTEGER,
    issueDate DATE NOT NULL,
    expirationDate DATE NOT NULL,
    tax DECIMAL(6,2),
    fees DECIMAL (6,2),
    total DECIMAL(6,2),
	PRIMARY KEY(quoteId),
    UNIQUE(supplierId, issueDate),
	FOREIGN KEY(supplierId) REFERENCES supplier(supplierId)
);

CREATE TABLE IF NOT EXISTS inventoryItem (
	ingId INTEGER,
	quoteId INTEGER,
    expirationDate DATE,
	stockQty DECIMAL(5,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
	qtyRemaining DECIMAL(5,2) NULL,
	PRIMARY KEY(ingId, quoteId),
	FOREIGN KEY(ingId) REFERENCES ingredient(ingId),
	FOREIGN KEY(quoteId) REFERENCES ingQuote(quoteId)
);	


CREATE TABLE IF NOT EXISTS supplierPhone (
	supplierId INTEGER,
	phoneType VARCHAR(50),
	phoneNumber VARCHAR(20),
	PRIMARY KEY(supplierId, phoneType),
	FOREIGN KEY(supplierId) REFERENCES supplier(supplierId)
);

CREATE TABLE IF NOT EXISTS localSupplier (
	supplierId INTEGER,
	transportationFee DECIMAL(6,2),
	PRIMARY KEY(supplierId),
	FOREIGN KEY(supplierId) REFERENCES supplier(supplierId)
);


CREATE TABLE IF NOT EXISTS nationalSupplier (
	supplierId INTEGER,
	distance DECIMAL(6,2),
	mileageCost DECIMAL(6,2),
	PRIMARY KEY(supplierId),
	FOREIGN KEY(supplierId) REFERENCES supplier(supplierId)
);


CREATE TABLE IF NOT EXISTS quoteItem (
	quoteId INTEGER,
    ingId INTEGER,
    qty DECIMAL(6,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    unitCost DECIMAL(6,2) NOT NULL,
	PRIMARY KEY(quoteId,ingId),
	FOREIGN KEY(quoteId) REFERENCES ingQuote(quoteId), 
	FOREIGN KEY(ingId) REFERENCES ingredient(ingId)
);

CREATE TABLE IF NOT EXISTS delivery (
	deliveryId INTEGER AUTO_INCREMENT,
	quoteId INTEGER,
    orderDate DATE,
    deliveryDate DATE,
 	PRIMARY KEY(deliveryId),
	FOREIGN KEY(quoteId) REFERENCES ingQuote(quoteId)
);


CREATE TABLE IF NOT EXISTS truckEvent
(
	eventId INTEGER AUTO_INCREMENT,
	eventName VARCHAR(200) NOT NULL,
	eventStart DATETIME NULL,
	eventEnd DATETIME NULL,
	PRIMARY KEY (eventId),
	UNIQUE (eventName, eventStart)
);

CREATE TABLE IF NOT EXISTS sale (
	saleId INTEGER AUTO_INCREMENT,
	eventId INTEGER,
	productCode CHAR(3),
 	PRIMARY KEY(saleId),
	FOREIGN KEY(eventId) REFERENCES truckEvent(eventId), 
	FOREIGN KEY(productCode) REFERENCES product(productCode)
);

CREATE TABLE IF NOT EXISTS saleDetail (
    saleId INTEGER NOT NULL,
    ingId INTEGER NOT NULL,
	qty DECIMAL(6,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    PRIMARY KEY(saleId, ingId),
	FOREIGN KEY(saleId) REFERENCES sale(saleId), 
	FOREIGN KEY(ingId) REFERENCES ingredient(ingId)
);

CREATE TABLE IF NOT EXISTS equipment
(
	equipmentName VARCHAR(100),
	installDate DATETIME NOT NULL,
	PRIMARY KEY (equipmentName)
);

CREATE TABLE IF NOT EXISTS maintenance (
	maintId INTEGER AUTO_INCREMENT,
	equipmentName VARCHAR(50),
	description VARCHAR(100),
	beforeFlag VARCHAR(10) NOT NULL,
    triggerAmount INTEGER NOT NULL,
	triggerUnit VARCHAR(20) NOT NULL,
	duration INTEGER NOT NULL,
    PRIMARY KEY (maintId),
	UNIQUE(equipmentName,description),
	FOREIGN KEY(equipmentName) REFERENCES equipment(equipmentName)
);


CREATE TABLE IF NOT EXISTS maintenanceLog (
	maintId INTEGER,
	maintDate DATETIME NOT NULL,
    duration INTEGER NOT NULL,
	notes TEXT,
	PRIMARY KEY(maintId, maintDate)
);

CREATE TABLE IF NOT EXISTS xtra(
	productCode CHAR(3),
	xtraCode CHAR(3),
	PRIMARY KEY (productCode)
);

CREATE TABLE IF NOT EXISTS productType(
	productCode CHAR(3),
	productType VARCHAR(20),
	PRIMARY KEY (productCode)
);

CREATE TABLE IF NOT EXISTS productTypePairs(
	productType1 VARCHAR(20),
	productType2 VARCHAR(20),
	productCount INTEGER,
	PRIMARY KEY (productType1, productType2)
);

CREATE TABLE IF NOT EXISTS eventLog(
	eventId INTEGER,
	actualStart DATETIME NOT NULL,
	minutesDuration DECIMAL(5,2) NOT NULL,
	PRIMARY KEY (eventId),
	FOREIGN KEY(eventId) REFERENCES truckEvent(eventId)
);


CREATE TABLE IF NOT EXISTS toDo(
	toDoId INTEGER AUTO_INCREMENT,
	id INTEGER, 
	toDoType VARCHAR(20) NOT NULL,
	recorded DATETIME NOT NULL,
	done BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (toDoId)
);