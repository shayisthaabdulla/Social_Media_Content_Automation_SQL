# 📱 Social Content Automation: CRM Workflow Validation (SQL Project)

## Project Overview

**Project Title**: Social Content Automation: CRM Workflow Validation  
**Level**: Beginner – Intermediate  
**Database**: `social_content_workflow`

This SQL project replicates a real-world content operations pipeline, including agent onboarding, CSQ (Content Survey Questionnaire) submissions, and AI-generated content stages. It reflects my work as a Business Analyst using SQL for data validation, automation tracking, and reporting within CRM ecosystems like Dynamics 365.

## Why This Project Matters

Manual handling of content orders for thousands of insurance agents created delays and inconsistent outputs. This SQL project reflects a real initiative where I supported the automation of content production through:

- Validation of CRM orders and creative briefs (CSQs)
- Monitoring AI content workflow using SQL
- Detection of missing assignments and data inconsistencies
- Reporting trends from CSQ preferences and business categories
- My ability to use SQL to streamline digital content workflows

## Objectives

1. **Simulate an end-to-end CRM content workflow**: From order to agent approval  
2. **Validate data integrity**: Ensure completeness of assignments and dates  
3. **Explore CSQ response trends**: Business categories, tone, emoji use  
4. **Track pipeline progress**: Identify bottlenecks and approval delays  
5. **Deliver actionable insights**: Build queries that support reporting  

## Project Structure

### Tables

- `agent_orders`: Orders placed by agents, synced from third-party to CRM.
- `csq_responses`: Content Survey Questionnaires submitted by agents.
- `content_pipeline`: Tracks content progress (Writer → Editor → AE → Agent).

### Sample Data
Download the sample `.csv` files:

- 📦 [`agent_orders.csv`](./agent_orders.csv)
- 📝 [`csq_responses.csv`](./csq_responses.csv)
- 🚦 [`content_pipeline.csv`](./content_pipeline.csv)

## Database & Table Creation

```sql
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
    order_id INT REFERENCES agent_orders(order_id),
    is_ai_generated BOOLEAN,
    draft_generated_on DATE,
    writer_reviewed_on DATE,
    editor_reviewed_on DATE,
    ae_approved_on DATE,
    agent_approved_on DATE,
    current_status VARCHAR(40));
```

## Data Validation & Cleaning Queries

### Agent Orders Validation

```sql

1. Write a SQL query to find the missing writer, editor, or AE assignments

SELECT *
FROM agent_orders
WHERE writer_assigned IS NULL
   OR editor_assigned IS NULL
   OR ae_assigned IS NULL;

2. Write a SQL query to find orders with any missing date fields

SELECT *
FROM agent_orders
WHERE order_date IS NULL
   OR content_live_date IS NULL
   OR content_end_date IS NULL;

3. Write a SQL query to find duplicate orders for the same agent on the same date

SELECT agent_id, order_date, COUNT(*) AS duplicate_count
FROM agent_orders
GROUP BY agent_id, order_date
HAVING COUNT(*) > 1;

4. Write a SQL query to find orders with missing agent names

SELECT *
FROM agent_orders
WHERE agent_name IS NULL OR agent_name = '';

5. Write a SQL query to find orders not part of the correct program

SELECT *
FROM agent_orders
WHERE program_enrolled <> 'Digital Content Program';

6. Write a SQL query to find orders with blank region

SELECT *
FROM agent_orders
WHERE region IS NULL OR region = '';

7. Write a SQL query to find orders where AE is missing

SELECT *
FROM agent_orders
WHERE ae_assigned IS NULL OR ae_assigned = '';
```

## Data Exploration Queries
### Agent & Assignment Insights

```sql

8. Write a SQL query to get the total number of orders

SELECT COUNT(*) AS total_orders
FROM agent_orders;

9. Write a SQL query to get the total number of orders per agent

SELECT agent_name, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY agent_name;

10. Write a SQL query to find agents with multiple orders

SELECT agent_name, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY agent_name
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

11. Write a SQL query to find the order count by region

SELECT region, COUNT(*) AS orders_count
FROM agent_orders
GROUP BY region
ORDER BY orders_count DESC;

12. Write a SQL query to find the number of orders assigned by writer

SELECT writer_assigned, COUNT(*) AS number_of_order_per_writer
FROM agent_orders
GROUP BY writer_assigned
ORDER BY number_of_order_per_writer DESC;

13. Write a SQL query to find the total number of orders handled by each writer

SELECT writer_assigned, COUNT(*) AS total_orders
FROM agent_orders
GROUP BY writer_assigned
ORDER BY writer_assigned;

14. Write a SQL query to find the number of distinct regions handled per writer

SELECT writer_assigned, COUNT(DISTINCT region) AS unique_regions
FROM agent_orders
GROUP BY writer_assigned
ORDER BY writer_assigned;

15. Write a SQL query to count distinct writers, editors, and AEs

SELECT 
  COUNT(DISTINCT writer_assigned) AS no_of_writers,
  COUNT(DISTINCT editor_assigned) AS no_of_editors,
  COUNT(DISTINCT ae_assigned) AS no_of_ae
FROM agent_orders;

16. Write a SQL query to find the number of orders for each content live date

SELECT content_live_date, COUNT(*) AS content
FROM agent_orders
GROUP BY content_live_date
ORDER BY content DESC;
```
### CSQ Insights

```sql

17. Write a SQL query to count CSQ submissions by region

SELECT ao.region, COUNT(*) AS total_csq_submissions
FROM csq_responses AS csq
JOIN agent_orders AS ao ON csq.order_id = ao.order_id
GROUP BY ao.region
ORDER BY total_csq_submissions DESC;

18. Write a SQL query to count CSQs by business category

SELECT business_category, COUNT(*) AS total_submissions
FROM csq_responses
GROUP BY business_category;

19. Write a SQL query to find the most common preferred tone

SELECT preferred_tone, COUNT(*) AS count
FROM csq_responses
GROUP BY preferred_tone
ORDER BY count DESC;

20. Write a SQL query to find CSQs submitted in October 2024

SELECT *
FROM csq_responses
WHERE submitted_on BETWEEN '2024-10-01' AND '2024-10-31';

21. Write a SQL query to find CSQs with and without emojis

SELECT wants_emojis, COUNT(*) AS count
FROM csq_responses
GROUP BY wants_emojis;

22. Write a SQL query to find CSQs that prefer 'Professional' tone

SELECT preferred_tone, COUNT(*)
FROM csq_responses
WHERE preferred_tone = 'Professional'
GROUP BY preferred_tone;

23. Write a SQL query to find daily CSQ submission trends

SELECT submitted_on, COUNT(*) AS submissions
FROM csq_responses
GROUP BY submitted_on
ORDER BY submitted_on;

24. Write a SQL query to find hashtags used in Real Estate CSQs

SELECT csq_id, hashtags
FROM csq_responses
WHERE business_category = 'Real Estate';

25. Write a SQL query to identify unique business categories

SELECT business_category
FROM csq_responses
GROUP BY business_category;
```


```sql
26. Write a SQL query to find CSQs that don't want emojis and prefer friendly tone

SELECT *
FROM csq_responses
WHERE wants_emojis = 'false'
  AND preferred_tone = 'Friendly';

27. Write a SQL query to get CSQ details with corresponding content live and end dates

SELECT c.csq_id,
       c.business_category,
       c.submitted_on,
       o.content_live_date,
       o.content_end_date
FROM csq_responses AS c
JOIN agent_orders AS o
  ON c.order_id = o.order_id
ORDER BY c.submitted_on;

28. Write a SQL query to list CSQs with associated writer, editor, and AE

SELECT c.csq_id,
       o.agent_name,
       o.writer_assigned,
       o.editor_assigned,
       o.ae_assigned
FROM csq_responses AS c
JOIN agent_orders AS o
  ON c.order_id = o.order_id;
```
### Content Workflow Tracking

```sql
29. Write a SQL query to find orders where content is approved by agent

SELECT p.content_id, p.order_id, p.current_status, o.agent_name
FROM content_pipeline AS p
JOIN agent_orders AS o ON p.order_id = o.order_id
WHERE current_status = 'Approved by Agent';

30. Write a SQL query to find orders pending agent approval

SELECT *
FROM content_pipeline
WHERE ae_approved_on IS NOT NULL
  AND agent_approved_on IS NULL;
```

## Findings

- **All CRM Orders Are Valid**: Every agent order in the dataset includes assigned writers, editors, and AEs, indicating proper workflow ownership and readiness for content creation.
- **No Null or Incomplete Records**: All date fields (order_date, content_live_date, content_end_date) are present, and agent names and regions are properly filled. This reflects a clean and standardized CRM data entry process.
- **No Duplicate Orders**: Each order is uniquely placed per agent per date, confirming that order entry rules are being followed.
- **Balanced Writer Distribution**: Writers are assigned a roughly even number of orders, showing thoughtful load balancing across the team.
- **Consistent Regional Coverage**: Orders are spread across multiple regions, with some writers handling a broader geographic scope — useful for aligning writing style to local markets.
- **CSQ Data Is Fully Submitted**: All orders in the dataset have a corresponding CSQ response. No pending or skipped CSQ forms were found.
- **Tone Preferences Are Measurable**: The most common preferred tone is “Professional,” but “Friendly” is also popular. This provides valuable input for AI-generated prompt tuning.
- **Emojis Are Widely Accepted**: A majority of agents are open to using emojis in their content, indicating a shift toward more casual, engaging social media messaging.

## Reports

- **Order Volume by Region & Writer**: Highlights order distribution across regions and writing staff for operational load balancing.
- **Content Submission Tracker**: Tracks daily CSQ submissions and content live dates for forecasting.
- **Tone & Emoji Preference Report**: Analyzes CSQ preferences to guide AI prompt tuning for content generation.
- **Business Category Breakdown**: Identifies which industries (e.g., Real Estate, Insurance) dominate the pipeline.
- **Content Approval Funnel**: Displays where content is in the workflow—from draft to final agent approval.

## Conclusion
This project demonstrates how SQL can be a powerful tool for:

- Validating CRM and content data to ensure workflow readiness
- Uncovering inefficiencies in order entry and approval processes
- Supporting AI automation with structured, clean input data from CSQs
- Providing actionable insights through business-friendly reporting

It reflects real-world responsibilities of a Business Analyst supporting automation, CRM data accuracy, and content operations. The SQL-driven insights generated here could directly inform improvements in workload distribution, editorial SLA management, and creative strategy.

## Author - Shayistha

This project is part of my business analyst portfolio and highlights my hands-on experience with SQL for CRM data validation and reporting. It reflects key skills in data quality analysis, troubleshooting relational inconsistencies, and extracting business insights using PostgreSQL.
Feel free to reach out if you'd like to collaborate or provide feedback!
https://www.linkedin.com/in/shayisthaa/

Thank you for your support, and I look forward to connecting with you!
