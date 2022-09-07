-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users SET created_at = NOW() AND updated_at = NOW();

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
ALTER TABLE users MODIFY COLUMN created_at varchar(100);
ALTER TABLE users MODIFY COLUMN updated_at varchar(100);
UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'), updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
ALTER TABLE users MODIFY COLUMN created_at DATETIME, MODIFY COLUMN updated_at DATETIME;

-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

CREATE TABLE IF NOT EXISTS storehouses_products (
	id SERIAL PRIMARY KEY,
    storehouse_id INT unsigned,
    product_id INT unsigned,
    `value` INT unsigned COMMENT 'Запас товарный позиции на складке',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Складские запасы';
INSERT INTO storehouses_products (storehouse_id, product_id, value)
VALUES
    (1, 1, 0),
    (1, 2, 2500),
    (1, 3, 0),
	(1, 4, 30),
    (1, 5, 500),
    (1, 6, 1);
    SELECT  value FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;
    
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)
SELECT * FROM users WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august'); 

-- Подсчитайте средний возраст пользователей в таблице users.
SELECT ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(birthday_at)) / 365.25), 0) AS AVG_Age FROM users;

-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS week_day_of_birthday_in_this_Year, COUNT(*) AS amount_of_birthday
FROM users
GROUP BY week_day_of_birthday_in_this_Year
ORDER BY amount_of_birthday DESC;





