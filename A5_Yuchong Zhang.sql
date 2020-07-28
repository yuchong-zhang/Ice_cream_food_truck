#1.1
DROP FUNCTION IF EXISTS  numProductsAtEvent;
DELIMITER //
CREATE FUNCTION numProductsAtEvent(whichevent integer) RETURNS INTEGER
BEGIN
DECLARE numProdcuts INTEGER DEFAULT -1;
if whichevent in (select eventId from truckevent) then
SET@numProdcuts = (SELECT COUNT(*)
FROM Sale S
WHERE eventId = whichevent);
else
SET@numProdcuts =-1;
end if;
RETURN@numProdcuts;

END //
DELIMITER ;

SELECT numProductsAtEvent(3);
#result:
#40


#1.2
DROP FUNCTION IF EXISTS fractionXtra;

DELIMITER //
CREATE FUNCTION fractionXtra(whichevent integer) RETURNS decimal(5,3)
BEGIN
DECLARE fraction decimal(5,3) DEFAULT 0;
if whichevent in (select eventId from truckevent) then
if (SELECT COUNT(*)
FROM Sale S
JOIN xtra x ON S.productcode=x.productCode
WHERE S.eventId = whichevent)=0 then
SET@fraction =0;
else
SET@fraction =( SELECT (SELECT count(distinct S.saleId)
FROM Sale S
JOIN xtra x ON S.productcode=x.xtraCode
WHERE S.eventId = whichevent)/(SELECT COUNT(*)
FROM Sale S
JOIN xtra x ON S.productcode=x.productCode
WHERE S.eventId = whichevent));
end if;
else
SET@fraction =-1;
end if;
RETURN@fraction;
END //
DELIMITER ;
SELECT fractionXtra(4);
#result:
#0.818

#2.1
DROP TRIGGER IF EXISTS afterEvent;

DELIMITER //
CREATE TRIGGER afterEvent After insert ON eventLog 
FOR EACH ROW
BEGIN
    INSERT INTO toDo(id,toDoType,recorded)
        SELECT maintId ,'maint',now()
			FROM maintenance m where m.beforeFlag=0 and m.triggerUnit='event'; 
END //
DELIMITER ;

INSERT INTO eventLog(eventId, actualStart, minutesDuration)
VALUES (1,'2017-01-19 13:05:00' , 67);
SELECT * FROM toDo;

#result:
#'1', '4', 'maint', '2018-04-08 20:23:01', '0'
#'2', '11', 'maint', '2018-04-08 20:23:01', '0'
#'3', '12', 'maint', '2018-04-08 20:23:01', '0'

#2.2
DROP TRIGGER IF EXISTS afterDelivery;

DELIMITER //
CREATE TRIGGER afterDelivery After update ON delivery
FOR EACH ROW
BEGIN
    IF NEW.deliveryDate <> OLD.deliveryDate THEN
          IF datediff(NEW.deliveryDate,NEW.orderDate)>14 THEN
          INSERT INTO toDo(id,toDoType,recorded,done) values (NEW.deliveryID,'late delivery',now(),false);
          end if;
	end if;
END //
DELIMITER ;

TRUNCATE TABLE toDo;
UPDATE delivery
SET deliveryDate = '2018-01-16'
WHERE deliveryID = 2;
SELECT * FROM toDo;
#result:
#null

TRUNCATE TABLE toDo;
UPDATE delivery
SET deliveryDate = '2018-02-16'
WHERE deliveryID = 2;
SELECT * FROM toDo;

#result:
#'1', '2', 'late delivery', '2018-04-08 20:26:14', '0'



#3.1
DROP PROCEDURE IF EXISTS productChains;
delimiter //
create procedure productChains()
BEGIN
    DECLARE preveventId integer default 1;
    DECLARE thiseventId integer default 1;
    DECLARE thisproducttype varchar(20);
    DECLARE prevproducttype varchar(20);
    DECLARE thissaleId integer default 0;
    DECLARE prevsaleId integer default 0;
    DECLARE diffid integer default 0;
    DECLARE firstproduct integer default 0;
    DECLARE done integer default 0;
    # set up the cursor for the events 

    
    DECLARE productCursor CURSOR FOR SELECT s.saleId, s.eventId
    FROM sale s
    JOIN productType pt on s.productCode=pt.productCode
	where pt.productType='extra'
    order by s.saleId;
    
    DECLARE productCursor2 CURSOR FOR SELECT s.eventId, pt.productType
	FROM sale s
    JOIN productType pt on s.productCode=pt.productCode
	where pt.productType<>'extra'
    order by s.saleId;
    # declare not found handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	Truncate table producttypepairs;

    INSERT INTO productTypePairs(productType1,productType2,productCount)
	select distinct p1.productType, p2.productType,0
	from PRODUCTTYPE p1, PRODUCTTYPE p2
	where p1.productType<>'extra' and p2.productType<>'extra';
	INSERT INTO productTypePairs(productType1,productType2,productCount)
	values ('extra','extra',0);


	

    SET firstproduct = 1;

    # open the cursor
    OPEN productCursor;
    saleLoop:
        LOOP
        # set the previous date
        SET prevsaleId = thissaleId;
        SET preveventId = thiseventId;
        # get the next event info
        FETCH productCursor INTO thissaleId, thiseventId;
        # check for entries
        IF done THEN
            LEAVE saleLoop;
        END IF;

        IF firstproduct = 0 THEN
        # new event, keep going
            # is this the first event? 
            IF thissaleId- prevsaleId= 2 and thiseventId=preveventId THEN
                UPDATE productTypePairs
				SET productCount = productCount+1
				WHERE productType1='extra' and productType2='extra';
            END IF;
        END IF; 
	SET firstproduct = 0;
    END LOOP saleLoop;
    CLOSE productCursor; 
    
    SET firstproduct = 1;


    
    # open the cursor
    SET done=0;
    OPEN productCursor2;
    saleLoop2:
        LOOP
        # set the previous date
        SET preveventId = thiseventId;
        SET prevproducttype=thisproducttype;
        # get the next event info
        FETCH productCursor2 INTO  thiseventId, thisproducttype;
        # check for entries
        IF done THEN
            LEAVE saleLoop2;
        END IF;

        IF firstproduct = 0 THEN
        # new event, keep going
            # is this the first event? 
            IF thiseventId=preveventId THEN
                UPDATE productTypePairs
				SET productCount = productCount+1
				WHERE productType1=prevproducttype and productType2=thisproducttype;
            END IF;
        END IF; 
	SET firstproduct = 0;
    END LOOP saleLoop2;
    CLOSE productCursor2; 
    
END //
delimiter ;

call productChains();

/*
result: table of producttypepairs
productType1, productType2, productCount
'extra', 'extra', '922'
'sundae', 'sundae', '323'
'slush', 'sundae', '236'
'sundae', 'slush', '235'
'sundae', 'cone', '233'
'cone', 'sundae', '218'
'cone', 'cone', '197'
'slush', 'slush', '187'
'slush', 'cone', '180'
'cone', 'slush', '175'
'sundae', 'dish', '162'
'dish', 'sundae', '153'
'ice cream beverage', 'sundae', '151'
'dish', 'slush', '132'
'cone', 'dish', '130'
'sundae', 'ice cream beverage', '130'
'dish', 'cone', '106'
'slush', 'dish', '103'
'slush', 'ice cream beverage', '101'
'dish', 'dish', '90'
'ice cream beverage', 'cone', '87'
'cone', 'ice cream beverage', '86'
'ice cream beverage', 'slush', '79'
'ice cream beverage', 'dish', '71'
'dish', 'ice cream beverage', '69'
'sundae', 'pint', '63'
'beverage', 'sundae', '60'
'ice cream beverage', 'ice cream beverage', '59'
'cone', 'novelty', '53'
'pint', 'sundae', '52'
'sundae', 'beverage', '52'
'novelty', 'sundae', '49'
'sundae', 'novelty', '45'
'novelty', 'cone', '44'
'pint', 'slush', '44'
'slush', 'beverage', '44'
'slush', 'novelty', '44'
'novelty', 'slush', '42'
'beverage', 'slush', '40'
'pint', 'cone', '38'
'cone', 'pint', '35'
'slush', 'pint', '33'
'beverage', 'cone', '32'
'pint', 'dish', '31'
'dish', 'beverage', '30'
'dish', 'novelty', '29'
'novelty', 'ice cream beverage', '29'
'novelty', 'dish', '28'
'dish', 'pint', '26'
'ice cream beverage', 'beverage', '26'
'beverage', 'ice cream beverage', '24'
'cone', 'beverage', '23'
'ice cream beverage', 'novelty', '23'
'ice cream beverage', 'pint', '21'
'pint', 'ice cream beverage', '21'
'beverage', 'dish', '15'
'novelty', 'pint', '15'
'beverage', 'novelty', '14'
'beverage', 'beverage', '12'
'beverage', 'pint', '8'
'novelty', 'beverage', '8'
'pint', 'beverage', '8'
'pint', 'pint', '6'
'pint', 'novelty', '5'
'novelty', 'novelty', '3'
*/



