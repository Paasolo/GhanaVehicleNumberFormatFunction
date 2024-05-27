
/****** Object:  UserDefinedFunction [dbo].[fnFormatVehicleNum2]    Script Date: 7/10/2022 5:51:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===================================================================================    
CREATED BY: SA    
Description: Formats and validates Vehicle Registration Number    
DATE : 05/23/2019    
USAGE : SELECT dbo.fnFormatVehicleNum2('GC 1990A')    
=====================================================================================*/    
CREATE FUNCTION [dbo].[fnFormatVehicleNum2](    
@Vehiclenumber NVARCHAR(100)
)    
RETURNS NVARCHAR(100)    
AS    
BEGIN

SELECT @Vehiclenumber = RTRIM(LTRIM(@Vehiclenumber))

DECLARE @Vehiclenumber2 NVARCHAR(100),@Vehiclenumber3 NVARCHAR(100),@Vehiclenumber4 NVARCHAR(100),
@Vehiclenumber5 NVARCHAR(100),@Vehiclenumber6 NVARCHAR(100),@Vehiclenumber7 NVARCHAR(100),@Vehiclenumber8 NVARCHAR(100)

SELECT @Vehiclenumber2='WRONG REGISTRATION NUMBER'

IF @Vehiclenumber2='WRONG REGISTRATION NUMBER'
BEGIN
SELECT    @Vehiclenumber3 = dbo.fnFormatVehicleNum(@Vehiclenumber,'1','MCY1')  
END
IF @Vehiclenumber3='WRONG REGISTRATION NUMBER' OR @Vehiclenumber3 IS NULL
BEGIN
SELECT    @Vehiclenumber4 = dbo.fnFormatVehicleNum(@Vehiclenumber,'1','MCY2')  
END
IF @Vehiclenumber4='WRONG REGISTRATION NUMBER' OR @Vehiclenumber4 IS NULL
BEGIN
SELECT    @Vehiclenumber5 = dbo.fnFormatVehicleNum(@Vehiclenumber,'1','GW1CLASS1')  
END
IF @Vehiclenumber5='WRONG REGISTRATION NUMBER' OR @Vehiclenumber5 IS NULL
BEGIN
SELECT    @Vehiclenumber6 = dbo.fnFormatVehicleNum(@Vehiclenumber,'1','')  
END
IF @Vehiclenumber6='WRONG REGISTRATION NUMBER' OR @Vehiclenumber6 IS NULL
BEGIN
SELECT    @Vehiclenumber7 = dbo.fnFormatVehicleNum(@Vehiclenumber,'2','')  
END

SELECT @Vehiclenumber8 = CASE WHEN @Vehiclenumber3 <>'WRONG REGISTRATION NUMBER' THEN @Vehiclenumber3
                              WHEN @Vehiclenumber4 <>'WRONG REGISTRATION NUMBER' THEN @Vehiclenumber4
							  WHEN @Vehiclenumber5 <>'WRONG REGISTRATION NUMBER' THEN @Vehiclenumber5
							  WHEN @Vehiclenumber6 <>'WRONG REGISTRATION NUMBER' THEN @Vehiclenumber6
							  WHEN @Vehiclenumber7 <>'WRONG REGISTRATION NUMBER' THEN @Vehiclenumber7
							  ELSE 'WRONG REGISTRATION NUMBER'
							  END


RETURN UPPER(RTRIM(LTRIM(@Vehiclenumber8)))    
END
GO