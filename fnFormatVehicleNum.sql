/****** Object:  UserDefinedFunction [dbo].[fnFormatVehicleNum]    Script Date: 7/10/2022 5:51:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===================================================================================    
CREATED BY: SA    
Description: Formats and validates Vehicle Registration Number    
DATE : 11/20/2018    
USAGE : SELECT dbo.fnFormatVehicleNum('DV 4136','1','')    
=====================================================================================*/    
CREATE FUNCTION dbo.fnFormatVehicleNum(    
@Vehiclenumber NVARCHAR(100),    
@RegistrationType CHAR(1),---1:Standard,2:Customized    
@Usage             NVARCHAR(20) = ''--MCY:Motorcycle,GW1CLASS1:DV Plate,    
)    
RETURNS NVARCHAR(100)    
AS    
BEGIN    
DECLARE @Vehiclenumber2 NVARCHAR(100),@Vehiclenumber3 NVARCHAR(100),@Year BIGINT ,@Vehiclenumber4 NVARCHAR(100),    
@Vehiclenumber5 NVARCHAR(100),@NumericPart NVARCHAR(10),@lastchar nvarchar(2) 

DECLARE @VehicleCode TABLE(
strCode VARCHAR(2),
flgActive BIT
)

INSERT INTO @VehicleCode
SELECT 'AS',1
 UNION ALL
SELECT 'AE',1
 UNION ALL
SELECT 'AW',1
 UNION ALL
SELECT 'AC',1
 UNION ALL
SELECT 'BA',1
 UNION ALL
SELECT 'CR',1
 UNION ALL
SELECT 'ER',1
 UNION ALL
SELECT 'GR',1
 UNION ALL
SELECT 'GC',1
 UNION ALL
SELECT 'GE',1
 UNION ALL
SELECT 'GL',1
 UNION ALL
SELECT 'GM',1
 UNION ALL
SELECT 'GN',1
 UNION ALL
SELECT 'GT',1
 UNION ALL
SELECT 'GS',1
 UNION ALL
SELECT 'GW',1
 UNION ALL
SELECT 'GY',1
 UNION ALL
SELECT 'GX',1
 UNION ALL
SELECT 'NR',1
 UNION ALL
SELECT 'UE',1
 UNION ALL
SELECT 'UW',1
 UNION ALL
SELECT 'VR',1
 UNION ALL
SELECT 'WR',1
 UNION ALL
SELECT 'GA',1
 UNION ALL
SELECT 'GP',1
 UNION ALL
SELECT 'FS',1
 UNION ALL
SELECT 'PS',1
 UNION ALL
SELECT 'CD',1
 UNION ALL
SELECT 'GV',1
 UNION ALL
SELECT 'GG',1
 UNION ALL
SELECT 'GB',1
 UNION ALL
SELECT 'AK',1
 UNION ALL
SELECT 'EN',1
 UNION ALL
SELECT 'ES',1
 UNION ALL
SELECT 'BT',1
 UNION ALL
SELECT 'AP',1
 UNION ALL
SELECT 'BW',1
 UNION ALL
SELECT 'VD',1
 UNION ALL
SELECT 'WT',1
 UNION ALL
SELECT 'GJ',1
 UNION ALL
SELECT 'GD',1

SELECT @Year= YEAR(GETDATE())    
IF @RegistrationType = '1' -----------standard Vehicles----------------    
BEGIN    
IF @Usage IN ('MCY') OR (@Vehiclenumber LIKE '[A-Z]%' AND @Vehiclenumber LIKE '%[0-9]' AND REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','') LIKE '[A-Z][0-9]%' AND ISNULL(@Usage,'')='') --M-10-AS 1620         ---------------------Motor cycles----------------
----    
BEGIN    
--print 'This is a Motor Cycle'    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
IF (@Vehiclenumber2 NOT LIKE '[A-Z]%' OR @Vehiclenumber2 NOT LIKE '[A-Z][0-9][0-9]%'      
OR SUBSTRING(@Vehiclenumber2,2,2) > RIGHT(@Year,2) OR REVERSE(@Vehiclenumber2) NOT LIKE '[0-9]%' OR len(replace(@Vehiclenumber2,' ','')) > 9)    
BEGIN    
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'    
END   
ELSE IF (SUBSTRING(@Vehiclenumber2,4,2) NOT IN(SELECT strCode FROM @VehicleCode WHERE flgActive = 1))      
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END     
ELSE    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
SET @Vehiclenumber4 = @Vehiclenumber2    
WHILE PATINDEX('%[^0-9]%',@Vehiclenumber2) <> 0    
BEGIN    
    -- replace characters with empty space    
    SET @Vehiclenumber2 = STUFF(@Vehiclenumber2,PATINDEX('%[^0-9]%',@Vehiclenumber2),1,'')    
END    
SET @Vehiclenumber2 =   @Vehiclenumber2    
SET @Vehiclenumber3 = LEFT(@Vehiclenumber4,1) + '-' +    
       LEFT(@Vehiclenumber2,2) + '-' +    
       SUBSTRING(@Vehiclenumber4,4,2) + ' ' +    
       SUBSTRING(@Vehiclenumber2,3,LEN(@Vehiclenumber2)-2)    
END    
END    
-------------------DP Plate--------------------  
ELSE IF @Usage in ('GW1CLASS2')    
BEGIN    
  --  
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')   
SET @NumericPart = @Vehiclenumber2  
IF @Vehiclenumber2 LIKE '%[A-Z]'   
SET @lastchar = LEFT(REVERSE(@Vehiclenumber2),1)  
ELSE   
SET @lastchar = ''  
------------------------GET Numeric part from vehicle number -------------------  
While PatIndex('%[^0-9]%', @NumericPart) > 0  
 BEGIN  
 SET @NumericPart = Stuff(@NumericPart, PatIndex('%[^0-9]%', @NumericPart), 1, '')  
 END  
  
IF (@Vehiclenumber2 NOT LIKE '[A-Z][A-Z]%'  OR len(@NumericPart) > 5 OR @Vehiclenumber2 NOT LIKE 'DP%')    
BEGIN    
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'    
END    
ELSE    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
SET @Vehiclenumber4 = @Vehiclenumber2    
WHILE PATINDEX('%[^0-9]%',@Vehiclenumber2) <> 0    
BEGIN    
------------ replace characters with empty space-------------------------------    
    SET @Vehiclenumber2 = STUFF(@Vehiclenumber2,PATINDEX('%[^0-9]%',@Vehiclenumber2),1,'')    
END    
SET @Vehiclenumber2 =   @Vehiclenumber2    
SET @Vehiclenumber3 = LEFT(@Vehiclenumber4,2) + ' ' + @Vehiclenumber2 +' '+@lastchar    
END    
END  
-------------------DV Plate----------------------     
ELSE IF @Usage in ('GW1CLASS1')    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')   
SET @NumericPart = @Vehiclenumber2  
IF @Vehiclenumber2 LIKE '%[A-Z]'   
SET @lastchar = LEFT(REVERSE(@Vehiclenumber2),1)  
ELSE   
SET @lastchar = ''   
------------------------GET Numeric part from vehicle number -------------------  
While PatIndex('%[^0-9]%', @NumericPart) > 0  
 BEGIN  
 SET @NumericPart = Stuff(@NumericPart, PatIndex('%[^0-9]%', @NumericPart), 1, '')  
 END  
IF (@Vehiclenumber2 NOT LIKE '[A-Z][A-Z]%'  OR len(@NumericPart) > 4 OR @Vehiclenumber2 NOT LIKE 'DV%')    
BEGIN   
IF LEN(@Vehiclenumber) <= 11 AND LEFT(@Vehiclenumber,2)='DV' AND RIGHT(@Vehiclenumber,2) < = RIGHT(CONVERT(VARCHAR(4),YEAR(Getdate())),2) AND SUBSTRING(REVERSE(@Vehiclenumber),3,1) = '-'  
SET @Vehiclenumber3 = @Vehiclenumber  
ELSE   
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'    
END    
ELSE    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
SET @Vehiclenumber4 = @Vehiclenumber2    
WHILE PATINDEX('%[^0-9]%',@Vehiclenumber2) <> 0    
BEGIN    
------------------------ replace characters with empty space----------------------    
    SET @Vehiclenumber2 = STUFF(@Vehiclenumber2,PATINDEX('%[^0-9]%',@Vehiclenumber2),1,'')    
END    
SET @Vehiclenumber2 =   @Vehiclenumber2   
IF LEN(@Vehiclenumber) <= 11 AND LEFT(@Vehiclenumber,2)='DV' AND RIGHT(@Vehiclenumber,2) < = RIGHT(CONVERT(VARCHAR(4),YEAR(Getdate())),2) AND SUBSTRING(REVERSE(@Vehiclenumber),3,1) = '-'  
SET @Vehiclenumber3 = @Vehiclenumber  
ELSE   
SET @Vehiclenumber3 = LEFT(@Vehiclenumber4,2) + ' ' + @Vehiclenumber2+' '+@lastchar     
END    
END    
---------------------------------Other Usages----------------   
ELSE    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
IF @Vehiclenumber2 LIKE '%[0-9]' AND RIGHT(@Year,2) < RIGHT(@Vehiclenumber2,2)      
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END    
ELSE IF @Vehiclenumber2 LIKE '%[0-9]' AND LEN(@Vehiclenumber2)>8      
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END  
ELSE IF RIGHT(@Vehiclenumber2,2) IN ('00','01','02','03','04','05','06','07','08')   
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END  
ELSE IF @Vehiclenumber2 LIKE '%[A-Z]' AND LEN(@Vehiclenumber2)>7      
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END  
ELSE IF PATINDEX('%[0-9][0-9][0-9]',@Vehiclenumber2)-2 < 0 AND @Vehiclenumber2 NOT LIKE '%[A-Z]'  
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END    
ELSE IF PATINDEX('%[0-9][A-Z]',@Vehiclenumber2)-2 < 0 AND @Vehiclenumber2 LIKE '%[A-Z]'  
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END  
ELSE IF (@Vehiclenumber NOT LIKE '[A-Z][A-Z]%' OR len(REPLACE(@Vehiclenumber,' ','')) > 10 OR @Vehiclenumber LIKE '%[A-Z][A-Z]' OR @Vehiclenumber LIKE '%[A-Z][A-Z][A-Z]')       
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END     
ELSE IF (LEFT(RTRIM(LTRIM(@Vehiclenumber2)),2) NOT IN(SELECT strCode FROM @VehicleCode WHERE flgActive = 1))       
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END      
ELSE    
BEGIN    
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')    
SELECT @Vehiclenumber3 =     
                        LEFT(@Vehiclenumber2,2) + ' ' +    
      CASE     
        WHEN @Vehiclenumber2 LIKE '%[A-Z]' THEN SUBSTRING(@Vehiclenumber2,PATINDEX('%[0-9]%',@Vehiclenumber2),PATINDEX('%[0-9][A-Z]',@Vehiclenumber2)-2) +' '+    
                               SUBSTRING(@Vehiclenumber2,PATINDEX('%[A-Z]',@Vehiclenumber2),PATINDEX('[A-Z]%',REVERSE(@Vehiclenumber2)))     
        WHEN @Vehiclenumber2 LIKE '%[0-9]' THEN SUBSTRING(@Vehiclenumber2,PATINDEX('%[0-9]%',@Vehiclenumber2),PATINDEX('%[0-9][0-9][0-9]',@Vehiclenumber2)-2) + '-' +    
             RIGHT(@Vehiclenumber2,2)    
        ELSE @Vehiclenumber2     
      END    
END    
END    
END    
  
----------------------------Customized Vehicles----------------    
IF @RegistrationType = '2'    
BEGIN      
IF @Vehiclenumber LIKE '%[0-9]' AND RIGHT(@Year,2) < RIGHT(REPLACE(@Vehiclenumber,' ',''),2)      
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END      
ELSE IF (@Vehiclenumber LIKE '%[A-Z][A-Z]' OR @Vehiclenumber LIKE '%[A-Z][A-Z][A-Z]')       
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END      
ELSE IF @Vehiclenumber NOT LIKE '[A-Z]%'       
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END   
ELSE IF (LEFT(RTRIM(LTRIM(@Vehiclenumber)),2) IN(SELECT strCode FROM @VehicleCode WHERE flgActive = 1))       
BEGIN      
SELECT @Vehiclenumber3 = 'WRONG REGISTRATION NUMBER'      
END      
ELSE      
BEGIN   
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')   
SET @NumericPart = @Vehiclenumber2    
IF @Vehiclenumber2 LIKE '%[A-Z]'     
SET @lastchar = LEFT(REVERSE(@Vehiclenumber2),1)    
ELSE     
SET @lastchar = REVERSE(LEFT(REVERSE(@Vehiclenumber2),2))    
  
SELECT @Vehiclenumber2=REPLACE(REPLACE(@Vehiclenumber,' ',''),'-','')      
SET @Vehiclenumber4 = @Vehiclenumber2      
WHILE PATINDEX('%[^0-9]%',@Vehiclenumber2) <> 0      
BEGIN      
    -- replace characters with empty space      
    SET @Vehiclenumber2 = STUFF(@Vehiclenumber2,PATINDEX('%[^0-9]%',@Vehiclenumber2),1,'')      
END      
SET @Vehiclenumber2 =   @Vehiclenumber2      
SET @Vehiclenumber3 = CASE WHEN @lastchar LIKE '%[0-9]%' THEN SUBSTRING(@Vehiclenumber4,1,PATINDEX('%[0-9]%',@Vehiclenumber4)-1) + ' ' + Left(@Vehiclenumber2,len(@Vehiclenumber2)-2) +'-'+@lastchar  
                           WHEN @lastchar LIKE '%[A-Z]%' THEN SUBSTRING(@Vehiclenumber4,1,PATINDEX('%[0-9]%',@Vehiclenumber4)-1) + ' ' + @Vehiclenumber2 +' '+@lastchar   
         END     
END     
END  
RETURN UPPER(@Vehiclenumber3)    
END      
GO