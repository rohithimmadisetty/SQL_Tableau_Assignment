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
order by 1 limit 100;

/* 1.	Find out the airline company which has a greater number of flight movement. */

select Carrier_code,
       Carrier_ID,
       count(carrier_id) as no_of_flights
       from flight_detail
       join carrier_detail
           on carrier_detail.Carrier_ID = flight_detail.carrierId
		group by Carrier_code 
        order by no_of_flights desc
        limit 1;
        
/* 2.	Get the details of the first five flights that has high airtime. */

select * 
       from
       flight_detail
       order by airtime desc
       limit 5;
       
/* 3. Compute the maximum difference between the scheduled and actual arrival 
      and departure time for the flights and categorize it by the airline companies. */
      
      select carrierId,
			 Carrier_code,
             MAX(arrivaldelay)
             from flight_detail
             join carrier_detail
                on carrier_detail.Carrier_ID = flight_detail.carrierId
             group by carrierId;
      

/* 4.	Find the month in which the flight delays happened to be more. */

        select  flight_month,
                avg(arrivaldelay) + avg(departuredelay) as total_delay
                from flight_detail
                group by flight_month
                order by total_delay desc limit 1
                ;


/* 5.	Get the flight count for each state and identify the top 1. */

    select state_detail.stateId,
           count(state_detail.stateId) as flight_count
           from flight_detail
           join route_detail
                on route_detail.route_ID = flight_detail.routeId
		   join airport_detail ad
                on route_detail.origincode = ad.locationId
		   join airport_detail ad2
                on route_detail.Destinationcode = ad2.locationId 
		   join state_detail
               on state_detail.stateId = ad.stateId	
		   group by state_detail.stateId
           order by flight_count desc;
		
    /* 6. A customer wants to book a flight under an emergency situation. Which airline would you suggest him to book. Justify your answer. */
    
                select flight_detail.CarrierId,    
					   Carrier_code,
                       avg(arrivaldelay) as avg_arrival_delay,
                       avg(departuredelay) as avg_departure_delay ,
                       (avg(arrivaldelay) + avg(departuredelay)) as avg_total_delay
                       from flight_detail
                       join carrier_detail
                            on flight_detail.carrierId = carrier_detail.Carrier_ID
                       group  by carrierId order by avg_delay limit 1;
          /* I will suggest AQ airlines it has minimum average delay */         
          
/* 7.	Find the dates in each month on which the flight delays are more. */
    /* considering avg delay > 30 are delay flights*/
      select flight_month,
             daymonth,
             avg(arrivaldelay) as avg_arrival_delay,
             avg(departuredelay) as avg_departure_delay ,
             (avg(arrivaldelay) + avg(departuredelay))  as avg_total_delay
             from flight_detail
             group by flight_month, daymonth 
             having avg_total_delay > 30 
             order by avg_total_delay desc
             ;
             
	/* 8.	Calculate the percentage of flights that are delayed compared to flights that arrived on time. */
         select  ( count(arrivaldelay) / (select  count(arrivaldelay) from flight_detail where arrivaldelay < 0 ) ) * 100 as "percentage of flights that are delayed compared to flights that arrived on time"
                 from flight_detail
                 where arrivaldelay > 0;
		
	/* 9.	Identify the routes that has more delay time. */
    
    SELECT routeId,
           (avg(arrivaldelay) + avg( departuredelay)) as total_delay
           FROM flight_detail
           join route_detail 
                on route_detail.route_ID = flight_detail.routeId
		 	group by routeId
            order by total_delay desc limit 10;
	
    /* 10.	Find out on which day of week the flight delays happen more. */
     select  dayweek,
             (avg(arrivaldelay) + avg( departuredelay)) as total_delay
            from flight_detail
            where (arrivaldelay + departuredelay) > 0
            group by dayweek
            order by total_delay desc limit 10 ;
	/* 11.	Identify at which part of day flights arrive late. */
    select  hour(ScheduledArrivaltime),
            count(*) as no_of_flights
            from flight_detail
            where arrivaldelay > 0
            group by hour(ScheduledArrivaltime)
            order  by no_of_flights desc limit 1;
	/* 12.	Compute the maximum, minimum and average TaxiIn and TaxiOut time. */
    select min(taxiIn),
           max(taxiIn),
           avg(taxiIn),
           min(taxiout),
           max(taxiout),
           avg(taxiout)
           from flight_detail
            ;
	
    /* 13.	Get the details of origin and destination with maximum flight movement. */
    
        SELECT routeId,
               count(routeId) as flight_count,
               a1.airport_name as origin,
               a2.airport_name as destination
               FROM flight_detail
               join route_detail 
                on route_detail.route_ID = flight_detail.routeId
		       join airport_detail as a1
                on a1.locationId = route_detail.origincode
			   join airport_detail as a2
                on route_detail.destinationcode = a2.locationId
               group by flight_detail.routeId
               order by flight_count desc limit 1;
               
	  /* 14.	Find out which delay cause occurrence is maximum */
          select /*  sum(case  when arrivaldelay > 0 then 1 else 0 end ) as arrivaldelay_count  ,                     
                   sum(case  when departuredelay > 0 then 1 else 0 end )as departuredelay_count,  */
                   sum(case  when carrierdelay > 0 then 1 else 0 end )as carrierdelayy_count,
                   sum(case  when weatherdelay > 0 then 1 else 0 end )as weatherdelay_count,
                   sum(case  when NASdelay > 0 then 1 else 0 end )as NASdelay_count,
                   sum(case  when securitydelay > 0 then 1 else 0 end )as securitydelay_count,
                   sum(case  when Late_aircraft_delay > 0 then 1 else 0 end )as Late_aircraft_delay_count
                   from flight_detail;
	/* 15.	Get details of flight whose speed is between 400 to 600 miles/hr for each airline company. */
    
       select *
              from flight_detail
              where speed > 400 and speed < 600
              order by carrierId desc;
	/* 16.	Identify the best time in a day to book a flight for a customer to reduce the delay. */
     select hour(Scheduleddeparturetime) as slot_time,
             avg(departuredelay),
             avg(arrivaldelay),
            ( avg(departuredelay) + avg(arrivaldelay) ) as total_delay
             from flight_detail
             group by hour(Scheduleddeparturetime)
             order by total_delay limit 1 ;
	/* 17.	Get the route details with airline company code ‘AQ’ */
    select distinct(routeId),
           a1.airport_name as origin,
           a2.airport_name as destination
		   from flight_detail
           left join carrier_detail
             on carrier_detail.Carrier_ID =  flight_detail.carrierId
		   join route_detail 
			 on route_detail.route_ID = flight_detail.routeId
		   join airport_detail as a1
             on a1.locationId = route_detail.origincode
		   join airport_detail as a2
             on route_detail.destinationcode = a2.locationId
	       where carrierId = 17;
           
	/* 18.	Identify on which dates in a year flight movement is large. */
    
    select flight_date,
           count(flight_date) as no_of_flights
           from flight_detail
           group by flight_date
           order by no_of_flights limit 10;
  /* 19.	Find out which delay cause is occurring more for each airline company. */
         select    carrierId,
                   sum(case  when arrivaldelay > 0 then 1 else 0 end ) as arrivaldelay_count  ,                     
                   sum(case  when departuredelay > 0 then 1 else 0 end )as departuredelay_count,  
                   sum(case  when carrierdelay > 0 then 1 else 0 end )as carrierdelayy_count,
                   sum(case  when weatherdelay > 0 then 1 else 0 end )as weatherdelay_count,
                   sum(case  when NASdelay > 0 then 1 else 0 end )as NASdelay_count,
                   sum(case  when securitydelay > 0 then 1 else 0 end )as securitydelay_count,
                   sum(case  when Late_aircraft_delay > 0 then 1 else 0 end )as Late_aircraft_delay_count
                   from flight_detail
                   group by carrierId;
	/* 20. Write a query that represent your unique observation in the database. */
      select *
             from flight_detail
  
             
    
			
    
    
    
            



       
