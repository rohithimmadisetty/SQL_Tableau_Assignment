create database flight_Delay_db;
use flight_delay_db;
drop table flight_detail;
create table flight_detail(
FlightId int,
flight_date date,
flight_year int,
flight_month int,
daymonth int,
dayweek int,
departuretime time,
Scheduleddeparturetime time,
Arrivaltime time,
ScheduledArrivaltime time,
carrierdId int,
Actualelaspedtime int,
Scheduledelapsedtime int,
airtime int,
arrivaldelay int,
departuredelay int,
routeId int,
distance int,
speed float,
taxiIn int,
taxiOut int,
Cancelled int,
CancellationCode varchar(5),
diverted varchar(5),
carrierdelay int,
weatherdelay int,
NASdelay int,
securitydelay int,
Late_aircraft_delay int);

drop table carrier_detail;

create table carrier_detail(
Carrier_ID int,
Carrier_code varchar(5));


drop table route_detail;

create table route_detail(
route_ID int,
origincode int,
destinationcode int);

drop table airport_detail;

create table airport_detail(
IATA_code varchar(5),
airport_name varchar(150),
city varchar(100),
Latitude float,
Longitude int,
locationId int,
stateId int);

drop table state_detail;

create table state_detail(
stateId int,
state_code varchar(5),
country varchar(5)
);

drop table cancellation;

create table cancellation(
cancellation_code varchar(5),
code_description varchar(30));





