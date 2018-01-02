use Weather;

ALTER TABLE AQS_Sites Add GeoLocation Geography;

UPDATE AQS_Sites
SET GeoLocation = geography::STPointFromText('POINT(' + CAST(Longitude AS VARCHAR(20)) + ' ' + 
                    CAST(Latitude AS VARCHAR(20)) + ')', 4326)
					where Latitude <> '';

DECLARE @h geography;
SET @h = geography::STGeomFromText('POINT(74.1790 40.7420)', 4326);
SELECT top 5 County_Name, City_Name, Zip_Code, (GeoLocation.STDistance(@h)) as distance
from AQS_Sites 
where Latitude <> '' and 
	City_Name <> 'Not in a city'
order by distance;


Create Procedure [dbo].[DistCalc] (
	@Longitude nvarchar(255),
	@Latitude nvarchar(255),
	@State_Name nvarchar(255)
)
As
Begin	
	Set Nocount On;
	Declare @home geography;
	Declare @state varchar(50); 
	Set @home = geography::STGeomFromText('POINT(' + @longitude + ' ' + @Latitude + ')', 4326);
	Set @state = @State_Name;

	SELECT top 20 County_Name, City_Name, Address, Zip_Code, GeoLocation.STDistance(@home) as Distance
	from AQS_Sites 
	where Latitude <> '' and
		State_Name = @state and
		City_Name <> 'Not in a city'
	order by Distance;
End

EXEC [dbo].[DistCalc] @Longitude= '-66.852931', @Latitude= '38.345236', @State_Name = 'Idaho';
