select rd.route_ID,
ad.IATA_code as origin ,ad2.IATA_code as destination
from route_detail rd 
join airport_detail ad
on rd.origincode = ad.locationId
join airport_detail ad2
on rd.destinationcode = ad2.locationId
order by 1;

select fd.FlightId,fd.flight_date,fd.flight_year,fd.flight_month,fd.daymonth,fd.dayweek,fd.departuretime,fd.Scheduleddeparturetime,
fd.Arrivaltime,fd.ScheduledArrivaltime,cd.Carrier_code,fd.Actualelaspedtime,fd.Scheduledelapsedtime,fd.airtime,
fd.arrivaldelay,fd.departuredelay,ad.IATA_code as origin,ad.airport_name as origin_airport_name,ad.city as origin_city,ad.Latitude as org_lat,ad.Longitude as org_long,
ad2.IATA_code as destination,ad2.airport_name as destination_airport_name,ad2.city as destination_city,ad2.Latitude as dest_lat,ad2.Longitude as dest_long,        
fd.distance,fd.speed,fd.taxiIn,fd.taxiOut,fd.Cancelled,fd.CancellationCode,fd.diverted,fd.carrierdelay,fd.weatherdelay,fd.NASdelay,fd.securitydelay,fd.Late_aircraft_delay
from flight_detail fd
join carrier_detail cd 
on fd.carrierId = cd.Carrier_ID
 join route_detail rd on fd.routeId = rd.route_ID
join airport_detail ad
on rd.origincode = ad.locationId
join airport_detail ad2
on rd.destinationcode = ad2.locationId
order by 1;

show columns from flight_detail;