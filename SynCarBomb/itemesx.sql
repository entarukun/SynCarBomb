ALTER TABLE owned_vehicles
ADD (`carbomb` int(12) NOT NULL DEFAULT '0');






INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('vehiclebomb', 'Car Bomb', 4, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('vehiclebombburnerphone', 'Car Bomb Phone', 4, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('vehicletracker', 'Vehicle Tracker', 4, 0, 1);



/* INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('VehicleBombSearchItem', 'Bomb Search Device', 4, 0, 1); */