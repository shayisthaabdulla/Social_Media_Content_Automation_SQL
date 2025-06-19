CREATE TABLE agent_orders (
    order_id SERIAL PRIMARY KEY,
    agent_id INT,
    agent_name VARCHAR(100),
    region VARCHAR(50),
    program_enrolled VARCHAR(50) DEFAULT 'Digital Content Program',
    order_date DATE,
    content_live_date DATE,
    content_end_date DATE,
    writer_assigned VARCHAR(100),
    editor_assigned VARCHAR(100),
    ae_assigned VARCHAR(100),
    CHECK (program_enrolled = 'Digital Content Program'));

	select agent_name, count (*)
	from agent_orders
	group by agent_name

CREATE TABLE csq_responses (
    csq_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES agent_orders(order_id),
    submitted_on DATE,
    business_category VARCHAR(100),
    target_audience TEXT,
    unique_selling_points TEXT,
    preferred_tone VARCHAR(30),
    hashtags TEXT,
    wants_emojis BOOLEAN);

CREATE TABLE content_pipeline (
    content_id INT PRIMARY KEY,
    order_id INT,
    is_ai_generated BOOLEAN,
    draft_generated_on DATE,
    writer_reviewed_on DATE,
    editor_reviewed_on DATE,
    ae_approved_on DATE,
    agent_approved_on DATE,
    current_status VARCHAR(40)
);

-- Data Validation & Cleaning Queries--

--1. Write a SQL query to check for missing writer, editor, or AE assignments--

SELECT *
FROM agent_orders
WHERE writer_assigned IS NULL OR
		editor_assigned IS NULL OR
		ae_assigned IS NULL;

--2. Write a SQL query to detect orders where any date field is NULL--

SELECT *
FROM agent_orders
WHERE order_date IS NULL
   OR content_live_date IS NULL
   OR content_end_date IS NULL;

--3. Write a SQL Query to find dupliccate orders for the same agent on the same date--

SELECT agent_id, order_date, COUNT(*) AS duplicate_count
FROM agent_orders
GROUP BY agent_id, order_date
HAVING COUNT(*) > 1;

--4. Write a SQL query to find orders with agents missing names--
SELECT *
FROM agent_orders
WHERE agent_name IS NULL OR agent_name = '';

--5. Write a SQL query to check that all records belong to the correct program--

SELECT *
FROM agent_orders
WHERE program_enrolled='Digital Content Program'
 
--6. Write a SQL query to find the total number of orders handled by each writer--

SELECT writer_assigned, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY writer_assigned
ORDER BY writer_assigned;

--7. Write a SQL query to find the count of distinct regions each writer has handled orders from

SELECT writer_assigned, COUNT(DISTINCT region) AS unique_regions
FROM agent_orders
GROUP BY writer_assigned
ORDER BY writer_assigned;

--8. Write a SQL query to find the disctinct writers, editors and aes--

SELECT 
  COUNT(DISTINCT writer_assigned) AS no_of_writers, 
  COUNT(DISTINCT editor_assigned) AS no_of_editors,
  COUNT(DISTINCT ae_assigned) AS no_of_ae
FROM agent_orders;

--9. Write a SQL query to find region is blank

SELECT *
FROM agent_orders
WHERE region IS NULL OR region = '';

-- Data Exploration Queries--
--10. Write a SQL query to get total number of orders--

SELECT COUNT(*) AS total_orders
FROM agent_orders

--11. Write a SQL query to get total number of orders per agent--

SELECT agent_name, COUNT (*) AS total_orders
FROM agent_orders
GROUP BY agent_name

--12. Write a SQL query find the order by region--

SELECT region, COUNT (*) AS orders_count
FROM agent_orders
GROUP BY region
ORDER BY orders_count DESC;

--13. Write a SQL query to list all the agents and no. of orders placed--

SELECT agent_name, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY agent_name

--13. Write a SQL query to list all the agents will multiple orders--

SELECT agent_name, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY agent_name
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

--14. Write a SQL query to find the numnber of orders assigned by writer--

SELECT writer_assigned, COUNT(*) AS number_of_order_per_writer
FROM agent_orders
GROUP BY writer_assigned
ORDER BY number_of_order_per_writer DESC;

--15. Write a SQL query to show orders where AE is missing

SELECT *
FROM agent_orders
WHERE ae_assigned IS NULL or ae_assigned='';

--16. Write a SQL query to find the number of orders for each content live date--

SELECT content_live_date, COUNT(*) as content
FROM agent_orders
GROUP BY content_live_date
ORDER BY content desc

SELECT *
FROM csq_responses

--17. Write a SQL query to count the CSQs submitted by region--

SELECT ao.region, COUNT(*) AS total_csq_submissions
FROM csq_responses AS csq
JOIN agent_orders AS ao 
ON csq.order_id = ao.order_id
GROUP BY ao.region
ORDER BY total_csq_submissions DESC;

--18. Write a SQL query to find the count of CSQs by business category--
SELECT business_category, COUNT(*) AS total_submissions
FROM csq_responses
GROUP BY business_category;

--19. Write a SQL query to find the most common preferred Tone-- 

SELECT preferred_tone, COUNT(*) AS count
FROM csq_responses
GROUP BY preferred_tone
ORDER BY count desc;

--20. Write a SQL query to find the CSQs submitted in October 2024--

SELECT *
FROM csq_responses
WHERE submitted_on BETWEEN '2024-10-01' and '2024-10-31'

--21. Write a SQL query to find the total CSQs with and without emojis--

SELECT wants_emojis, count (*)  AS count
FROM csq_responses
GROUP BY wants_emojis

--22. Write a SQL query to find the CSQs that prefer “Professional” Tone-- 
SELECT preferred_tone, COUNT (*)
FROM csq_responses
WHERE preferred_tone='Professional'
GROUP BY preferred_tone

--23. Write a SQL query to find the daily csq submission trend--
SELECT submitted_on, COUNT(*) AS submissions
FROM csq_responses
GROUP BY submitted_on
ORDER BY submitted_on;

--24. Write a SQL query to find the hashtags used by real estate CSQs--
SELECT csq_id, hashtags
FROM csq_responses
WHERE business_category = 'Real Estate';

--25. Write a SQL query to identify uniquess business category--

SELECT business_category
FROM csq_responses
GROUP BY business_category;

--26. Write a SQL query to find the CSQs that dont want emojis and prefer friendly tone--

SELECT *
FROM csq_responses
WHERE wants_emojis='false' AND preferred_tone='Friendly';

--27. Write a SQL query to get CSQ details with corresponding content live & end dates--

SELECT c.csq_id,c.business_category,c.submitted_on,o.content_live_date,o.content_end_date
FROM csq_responses AS C
JOIN agent_orders AS O 
ON c.order_id=o.order_id
ORDER BY c.submitted_on

--28. Write a SQL query to list the CSQs with associated writer, editor and AEs

SELECT c.csq_id,o.agent_name,o.writer_assigned, o.editor_assigned,o.ae_assigned
FROM agent_orders AS O
JOIN csq_responses As C
ON o.order_id=c.order_id;

--29. Write a SQL query to list the details of orders, agent name where the content is approved by agent--
SELECT 
    p.content_id,
    p.order_id,
    p.current_status,
	o. agent_name
FROM 
    content_pipeline AS P
JOIN agent_orders AS O
ON o.order_id=p.order_id
WHERE current_status='Approved by Agent';

--30. Write a SQL query to list all the orders that are pending agent approval--

SELECT *
FROM content_pipeline
WHERE ae_approved_on IS NOT NULL AND
	agent_approved_on IS NULL;
