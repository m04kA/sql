CREATE TABLE pilots(

pilot_id PRIMARY KEY,

name TEXT,

age INTEGER,

rank TEXT,

education_level TEXT

);

CREATE TABLE planes (

plane_id PRIMARY KEY,

capacity INTEGER,

cargo_flg bool

);

CREATE TABLE flights(

flight_id PRIMARY KEY,

flight_dt data,

plane_id INTEGER,

first_pilot_id INTEGER,

second_pilot_id INTEGER,

destination TEXT,

quantity INTEGER,

foreign KEY (first_pilot_id) references pilots (pilot_id) ON DELETE CASCADE,

foreign KEY (second_pilot_id) references pilots (pilot_id) ON DELETE CASCADE,

foreign KEY (plane_id) references planes (plane_id) ON DELETE CASCADE

);

INSERT INTO pilots

VALUES (1,"Evgen", 25, "rank1", "lv1"), (2,"Goga", 47, "rank3", "lv5"), (3,"Boba", 50, "rank4", "lv7");

INSERT INTO planes

VALUES (1,40, 1), (2, 30, 1), (3,20,1);

INSERT INTO flights

VALUES (1,"2022-08-18", 1, 2, 1, "Шереметьево",29), (2,"2022-08-02", 2, 3, 1, "Шереметьево",25), (3,"2022-08-18", 3, 1, 2, "Домодедово",20), (4,"2022-08-12", 1, 3, 1, "Шереметьево",35);

-- #1

SELECT `pilots`.`pilot_id`, `pilots`.`name`, `pilots`.`age`, `pilots`.`rank`, `pilots`.`education_level`

FROM `flights` AS `fl`

JOIN `pilots` ON `pilots`.`pilot_id` = `fl`.`second_pilot_id`

WHERE 'fl'.'destination' = 'Шереметьево' and 'fl'.'flight_dt' >= '2022-08-01' and 'fl'.'flight_dt' < '2023-09-01'

GROUP by `fl`.`second_pilot_id` having COUNT('fl'.'destination') = 3;

-- #2

SELECT `pilots`.`pilot_id`, `pilots`.`name`, `pilots`.`age`, `pilots`.`rank`, `pilots`.`education_level`

FROM `pilots`

JOIN `flights` AS `fl` ON `fl`.`second_pilot_id` = `pilots`.`pilot_id` OR `fl`.`first_pilot_id` = `pilots`.`pilot_id`

JOIN `planes` AS `pl` ON `pl`.`plane_id` = `fl`.`plane_id`

WHERE `pl`.`cargo_flg` = 0 AND `fl`.`quantity` > 30 AND `pilots`.`age` > 45

GROUP BY `pilots`.`pilot_id`;

-- #3.1

SELECT `pilots`.`pilot_id`, `pilots`.`name`, `pilots`.`age`, `pilots`.`rank`, `pilots`.`education_level`, COUNT(`fl`.`flight_id`) AS `flight_count`

FROM `flights` AS `fl`

JOIN `planes` AS `pl` ON `pl`.`plane_id` = `fl`.`plane_id`

JOIN `pilots` ON `pilots`.`pilot_id` = `fl`.`first_pilot_id`

WHERE `pl`.`cargo_flg` = 1 AND YEAR('fl'.'flight_dt') = YEAR(current_date)

GROUP BY `fl`.`first_pilot_id`

order BY `flight_count` desc

limit 10;

-- #3.2

SELECT `pilots`.`pilot_id`, `pilots`.`name`, `pilots`.`age`, `pilots`.`rank`, `pilots`.`education_level`, COUNT(`fl`.`flight_id`) AS `flight_count`

FROM `flights` AS `fl`

JOIN `planes` AS `pl` ON `pl`.`plane_id` = `fl`.`plane_id`

JOIN `pilots` ON `pilots`.`pilot_id` = `fl`.`first_pilot_id`

WHERE `pl`.`cargo_flg` = 1 AND 'fl'.'flight_dt' >= '2022-01-01' and 'fl'.'flight_dt' < '2023-01-01'

GROUP BY `fl`.`first_pilot_id`

order BY `flight_count` desc

limit 10;
