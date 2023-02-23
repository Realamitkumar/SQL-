USE zomato;

-- SELECT COUNT(*) From order_details;

-- replicated sample func
-- SELECT * From users ORDER BY rand() LIMIT 5

-- to find null values
-- select * from orders
-- where restaurant_rating IS NULL;


-- To replace NULL values with 0
-- UPDATE orders SET restaurant_rating = '0' 
-- WHERE restaurant_rating = '' ;
-- or.. WHERE restaurant_rating IS NULL ;


-- Q5. Number of orders placed by each customer

SELECT u.name,count(*) AS number_of_orders
FROM orders o JOIN  users u
ON o.user_id = u.user_id
GROUP BY u.name;



-- Q6.find restaurant with most number of menu
-- items


SELECT r_name,count(*)  AS 'menu_items'FROM restaurants r
JOIN menu m ON r.r_id = m.r_id
GROUP BY r_name;



-- Q7.find avg rating and no. of votes
-- for all restaurants.

SELECT  r.r_name , count(*) AS no_votes,
ROUND(AVG(restaurant_rating),2) AS avg_rating
FROM orders o
JOIN restaurants r 
ON o.r_id = r.r_id
WHERE restaurant_rating != '0'
GROUP BY r.r_name;


-- Q8.find the food that is being sold at most 
-- number of restaurants.

select f_name,count(*) from food f 
JOIN menu m ON f.f_id = m.f_id 
GROUP BY f_name
ORDER BY count(*) DESC LIMIT 1;


-- Q9.find the restaurants
-- with maximum revenue in given month 

-- SELECT MONTHNAME(DATE(date))  FROM orders


SELECT o.r_id , SUM(amount) AS 'revenue'   
FROM orders o
JOIN restaurants r
ON o.r_id = r.r_id
WHERE MONTHNAME(DATE(date)) = 'May'
GROUP BY o.r_id
ORDER BY revenue DESC LIMIT 1;

-- month by month revenue for a particular 
-- restaurant

SELECT monthname(date(date)) as month,
sum(Amount) AS revenue 
FROM orders o
JOIN restaurants r
ON o.r_id = r.r_id
WHERE r_name = 'kfc'
GROUP BY month
ORDER BY revenue DESC ;

-- Q10. find restaurants with sales > x
SELECT r_name,SUM(amount) AS revenue 
FROM orders o JOIN restaurants r 
ON o.r_id = r.r_id
GROUP BY r_name
HAVING revenue> 1000;


-- Q11. find the customers who have never ordered

SELECT user_id,name FROM users 
EXCEPT
SELECT u.user_id ,name FROM orders o
JOIN users u ON o.user_id = u.user_id ;


-- Q12. show order details of a particular customer in a
-- given date range 

SELECT * FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.user_id = 3 AND date BETWEEN 
'2022-05-10' AND'2022-06-11';



-- Q13. customer fav food
-- Not appropriate query 
-- becoz of less knowledge at this time 

SELECT  u.user_id,f_id,count(*) FROM users u
JOIN orders o 
ON u.user_id = o.user_id
JOIN order_details o2 ON
o.order_id = o2.order_id
GROUP BY u.user_id,f_id
ORDER BY count(*) DESC ;

-- Q14. find most costliest restaurant(Avg price/dish)
-- Note
-- can also apply "AVG(price)" instead of "sum(price)/count(*)"

SELECT r.r_id,sum(price)/count(*) AS avg_price FROM menu m
JOIN restaurants r ON m.r_id = r.r_id
GROUP BY r.r_id
ORDER BY avg_price DESC LIMIT 1;


-- Q15. find delivery partner compensation
-- using the formula
-- (#deliveries * 100 + 1000*avg_rating)

SELECT d.partner_name,count(*) * 100
+ 1000*AVG(delivery_rating) AS 
deliveries FROM orders o
JOIN delivery_partner d 
ON o.partner_id = d.partner_id
GROUP BY d.partner_name;


-- Q16. find revenue per month for a restaurant

SELECT monthname(date(date)) AS Month,
sum(amount) AS revenue
FROM orders o JOIN restaurants r 
ON o.r_id = r.r_id
WHERE r_name = 'kfc'
GROUP BY Month;


-- 17. find all veg restaurants

SELECT r_name
FROM zomato.food f
JOIN zomato.menu m 
ON f.f_id = m.f_id
JOIN zomato.restaurants r ON
m.r_id = r.r_id
GROUP BY r_name
HAVING MIN(type) = 'Veg' AND MAX(type) = 'Veg' 
;


-- 18. find min and max order value for all
-- the customers

SELECT name,MIN(amount) AS min_order_value,
MAX(amount) AS max_order_value  
FROM orders o
JOIN users u ON 
o.user_id = u.user_id
GROUP BY u.name;

