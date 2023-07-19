-- Задание 1: вывести количество активных клиентов на каждый месяц
-- Формирование тестового датасета:
CREATE TABLE ACTIVE_CLIENTS(
    CLIENT_ID INT PRIMARY KEY, 
    REPORT_MONTH DATE);

INSERT INTO active_clients (client_id, report_month) VALUES
    (1847982357, '2018-01-01'),
    (938475, '2018-01-01'),
    (1847982358, '2018-02-01'),
    (6789998, '2018-02-01'),
    (67900001, '2018-03-01');

-- код для вывода активных клиентов на каждый месяц    
SELECT COUNT(client_id) AS number_of_active_clients
FROM active_clients
GROUP BY report_month;

-- Задание 2: вывести количество действующих предложений на каждый день 2018 года. 
-- Формирование тестового датасета:
CREATE TABLE OFFERS(
    offer_id INT PRIMARY KEY, 
    offer_start_date DATE,
    offer_expiration_date DATE);

INSERT INTO offers (offer_id, offer_start_date, offer_expiration_date) VALUES
    (83942, '2017-12-01', '2018-02-01'),
    (94859, '2018-05-03', '2018-10-19'),
    (94857, '2018-02-01', '2018-10-20');

-- код для вывода количества действующих предложений на каждый день 2018 года.
SELECT date::date, COUNT(offer_id) AS active_offers_count
FROM generate_series('2018-01-01'::date, '2018-12-31'::date, '1 day') AS date
LEFT JOIN OFFERS ON date BETWEEN offer_start_date AND offer_expiration_date
GROUP BY date::date
ORDER BY date::date;

-- Задание 3: выбрать из всех работающих на дату 1.09.2018 дебетовых карт клиента ту, которая была выдана последней. Формат выдачи – client_id, card_id.
-- Формирование тестового датасета:
CREATE TABLE CARDS(
    client_id INT PRIMARY KEY, 
    card_id INT,
    open_date DATE,
    close_date DATE,
    card_type VARCHAR);

INSERT INTO cards (client_id, card_id, open_date, close_date, card_type) VALUES
    (1232110, 49585729, '2019-01-12', NULL, 'Deb_Card'),
    (234235, 48574749, '2017-03-29', '2018-09-01', 'Cred_Card'),
    (1232111, 4948729, '2019-05-12', NULL, 'Deb_Card'),
    (234236, 4857949, '2017-02-01', '2018-09-01', 'Cred_Card');

-- код для вывода всех работающих на дату 1.09.2018 дебетовых карт которая была выдана последней. 
--  Формат выдачи – client_id, card_id.
SELECT client_id, card_id
FROM cards
WHERE close_date >= '2018-09-01'
OrDER BY open_date DESC
LIMIT 1;

-- Задание 4: Вывести 1000 клиентов, которые 
-- первыми набрали 1000 бонусных баллов за покупки в категории «Авиабилеты» и «Отели».
-- Формирование тестового датасета bonus:
CREATE TABLE BONUS(
    client_id INT PRIMARY KEY, 
    bonus_cnt INT,
    bonus_date DATE,
    mcc_code INT);

INSERT INTO bonus (client_id, bonus_date, bonus_cnt, mcc_code) VALUES
    (1232110, '2018-01-01', 12, 3617),
    (234235, '2018-06-17', 5, 5931),
    (1232111, '2018-07-17', 6,3617),
    (234236, '2018-03-17', 11, 5931);

-- Формирование тестового датасета MCC_CATEGORIES:
CREATE TABLE MCC_CATEGORIES(
    mcc_code INT PRIMARY KEY, 
    mcc_category VARCHAR);

INSERT INTO mcc_categories (mcc_code, mcc_category) VALUES
    (3031, 'Авиабилеты'),
    (5735, 'Музыка'),
    (3617, 'Авиабилеты'),
    (5931, 'Отели');

-- код для отображения 1000 клиентов, 
-- которые первыми набрали 1000 бонусных баллов за покупки в категории «Авиабилеты» и «Отели».
SELECT * 
FROM bonus AS bonus
LEFT JOIN mcc_categories AS m_c ON bonus.mcc_code = m_c.mcc_code
WHERE m_c.mcc_category IN ('Авиабилеты', 'Отели')
ORDER BY bonus.bonus_date DESC
LIMIT 1000; 

-- Задание 5: получить курс валюты «USD» на заданную (любую) дату
SELECT rate
FROM currency_rates -- таблица курсов валют ЦБ
WHERE code = 'USD' AND value_date = '2023-05-01' -- подставить любую дату