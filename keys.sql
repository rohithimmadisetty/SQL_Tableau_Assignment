use flight_delay_db;

ALTER TABLE flight_detail
ADD PRIMARY KEY (FlightId);

ALTER TABLE flight_detail
ADD CONSTRAINT FK_CarrierID
FOREIGN KEY (carrierId) REFERENCES carrier_detail(Carrier_ID);

ALTER TABLE carrier_detail
ADD PRIMARY KEY (Carrier_ID);

ALTER TABLE route_detail
ADD PRIMARY KEY (route_ID);

ALTER TABLE airport_detail
ADD PRIMARY KEY (locationId);


ALTER TABLE state_detail
ADD PRIMARY KEY (stateId);

ALTER TABLE cancellation
ADD PRIMARY KEY (cancellation_code);

ALTER TABLE flight_detail
ADD CONSTRAINT FK_routeID
FOREIGN KEY (routeId) REFERENCES route_detail(route_ID);

ALTER TABLE flight_detail
ADD CONSTRAINT FK_Cancellation
FOREIGN KEY (CancellationCode) REFERENCES cancellation(cancellation_code);

ALTER TABLE airport_detail
ADD CONSTRAINT FK_stateID
FOREIGN KEY (stateId) REFERENCES state_detail(stateId);

ALTER TABLE route_detail
ADD CONSTRAINT FK_location
FOREIGN KEY (origincode) REFERENCES airport_detail(locationId);

ALTER TABLE route_detail
ADD CONSTRAINT FK_locationdest
FOREIGN KEY (destinationcode) REFERENCES airport_detail(locationId);