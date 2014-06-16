DECLARE @DayStart DATETIME = '2014-06-16 08:00:00', @DayEnd DATETIME = '2014-06-16 23:30:00' 
DECLARE @S DATETIME, @E DATETIME
DECLARE @t TABLE(RecordID INT PRIMARY KEY, DayDate DATETIME, BookingHours DECIMAL(12,2), IsPlaces BIT) 
-- add record
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (1, '2014-06-16 08:00:00', 2.0, 0)
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (2, '2014-06-16 09:00:00', 1.0, 0)
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (3, '2014-06-16 10:00:00', 2.0, 0)
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (4, '2014-06-16 12:00:00', 1.0, 0)
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (5, '2014-06-16 13:00.00', 0.0, 0)
INSERT INTO @t ( RecordID, DayDate, BookingHours, IsPlaces) VALUES (6, '2014-06-16 14:00:00', 1.0, 0)
--SELECT * FROM @t

DECLARE @RecordID INT, @DayDate DATETIME, @BookingHours DECIMAL(12,2), @BookingMinutes DECIMAL(12,2), @IsPlaces BIT
DECLARE Cs CURSOR READ_ONLY FOR 
	SELECT RecordID, DayDate, BookingHours, IsPlaces
	FROM @t WHERE DayDate BETWEEN @DayStart AND @DayEnd AND IsPlaces = 0 ORDER BY DayDate
OPEN Cs

FETCH NEXT FROM Cs INTO @RecordID, @DayDate, @BookingHours, @IsPlaces
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN 
		PRINT '-------';
		PRINT 'Working on:';
		PRINT 'ID:';
		PRINT @RecordID;
		PRINT @DayDate
		PRINT 'book for';
		PRINT @BookingHours;
		IF NOT EXISTS ( SELECT * FROM @t WHERE DayDate BETWEEN DATEADD(MINUTE, 1, @DayDate) AND DATEADD(MINUTE, @BookingHours*60-1, @DayDate))
		BEGIN 
			PRINT 'This is book at';
			PRINT DATEADD(MINUTE, @BookingHours*60, @DayDate)
			
			UPDATE @t SET IsPlaces=1, DayDate=DATEADD(MINUTE, @BookingHours*60, @DayDate) WHERE RecordID = @RecordID;
			
			FETCH NEXT FROM Cs INTO @RecordID, @DayDate, @BookingHours, @IsPlaces
		END
		PRINT 'LOOP-END';
	END
	FETCH NEXT FROM Cs INTO @RecordID, @DayDate, @BookingHours, @IsPlaces
END

CLOSE Cs
DEALLOCATE Cs

			SELECT * FROM @t;