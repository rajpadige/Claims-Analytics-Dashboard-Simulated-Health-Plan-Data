-- warehouse.sql: Snowflake queries for Claims Analytics Dashboard project
-- Purpose: Build and query a claims warehouse for healthcare analytics

-- Create schema for simulated health plan dataset
CREATE SCHEMA IF NOT EXISTS health_plan;

-- Create eligibility table
CREATE TABLE IF NOT EXISTS health_plan.eligibility (
    member_id VARCHAR(20) PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    enrollment_status VARCHAR(20),
    enrollment_date DATE
);

-- Create providers table
CREATE TABLE IF NOT EXISTS health_plan.providers (
    provider_id VARCHAR(20) PRIMARY KEY,
    specialty VARCHAR(50),
    network_status VARCHAR(20)
);

-- Create claims table
CREATE TABLE IF NOT EXISTS health_plan.claims (
    claim_id VARCHAR(20) PRIMARY KEY,
    member_id VARCHAR(20),
    provider_id VARCHAR(20),
    procedure_code VARCHAR(10),
    cost DECIMAL(10,2),
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (member_id) REFERENCES health_plan.eligibility(member_id),
    FOREIGN KEY (provider_id) REFERENCES health_plan.providers(provider_id)
);

-- Insert sample data for demonstration
INSERT INTO health_plan.eligibility VALUES
('M001', 45, 'Male', 'Active', '2022-01-01'),
('M002', 30, 'Female', 'Active', '2022-01-01'),
('M003', 65, 'Male', 'Active', '2022-01-01'),
('M004', 50, 'Female', 'Active', '2022-01-01'),
('M005', 28, 'Male', 'Active', '2022-01-01');

INSERT INTO health_plan.providers VALUES
('P001', 'Cardiology', 'In-Network'),
('P002', 'General Practice', 'In-Network'),
('P003', 'Orthopedics', 'Out-of-Network'),
('P004', 'Neurology', 'In-Network'),
('P005', 'Pediatrics', 'In-Network');

INSERT INTO health_plan.claims VALUES
('C001', 'M001', 'P001', '99213', 500.00, '2022-06-01', '2022-06-03'),
('C002', 'M002', 'P002', '99214', 300.00, '2022-06-10', '2022-06-10'),
('C003', 'M001', 'P001', '99213', 450.00, '2022-06-20', '2022-06-22'),
('C004', 'M003', 'P003', '99215', 700.00, '2022-06-15', '2022-06-18'),
('C005', 'M004', 'P004', '99213', 400.00, '2022-07-01', '2022-07-03'),
('C006', 'M005', 'P005', '99212', 200.00, '2022-07-05', '2022-07-05'),
('C007', 'M001', 'P001', '99214', 600.00, '2022-07-10', '2022-07-12');

-- Query 1: Calculate PMPM costs by member
SELECT 
    e.member_id,
    e.age,
    e.gender,
    COUNT(c.claim_id) AS claim_count,
    SUM(c.cost) / 6 AS pmpm_cost -- Assuming 6 months of data
FROM health_plan.eligibility e
LEFT JOIN health_plan.claims c ON e.member_id = c.member_id
WHERE c.admission_date BETWEEN '2022-01-01' AND '2022-06-30'
GROUP BY e.member_id, e.age, e.gender
HAVING SUM(c.cost) IS NOT NULL
ORDER BY pmpm_cost DESC;

-- Query 2: Calculate 30-day readmission rates by provider specialty
WITH admissions AS (
    SELECT 
        c.member_id,
        c.provider_id,
        c.admission_date,
        c.discharge_date,
        LEAD(c.admission_date) OVER (PARTITION BY c.member_id ORDER BY c.admission_date) AS next_admission
    FROM health_plan.claims c
    WHERE c.admission_date IS NOT NULL AND c.discharge_date IS NOT NULL
)
SELECT 
    p.specialty,
    COUNT(*) AS total_admissions,
    SUM(CASE WHEN DATEDIFF(day, a.discharge_date, a.next_admission) <= 30 THEN 1 ELSE 0 END) AS readmissions,
    SUM(CASE WHEN DATEDIFF(day, a.discharge_date, a.next_admission) <= 30 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS readmission_rate
FROM admissions a
JOIN health_plan.providers p ON a.provider_id = p.provider_id
GROUP BY p.specialty
ORDER BY readmission_rate DESC;

-- Query 3: Provider performance (PMPM costs and claim counts)
SELECT 
    p.provider_id,
    p.specialty,
    p.network_status,
    AVG(c.cost) AS avg_claim_cost,
    COUNT(c.claim_id) AS claim_count,
    SUM(c.cost) / (COUNT(DISTINCT c.member_id) * 6) AS pmpm_cost
FROM health_plan.providers p
LEFT JOIN health_plan.claims c ON p.provider_id = c.provider_id
WHERE c.admission_date BETWEEN '2022-01-01' AND '2022-06-30'
GROUP BY p.provider_id, p.specialty, p.network_status
HAVING COUNT(c.claim_id) > 0
ORDER BY pmpm_cost ASC;

-- Query 4: Contract optimization simulation for high-risk members
WITH high_risk AS (
    SELECT 
        c.member_id,
        SUM(c.cost) AS total_cost
    FROM health_plan.claims c
    WHERE c.admission_date BETWEEN '2022-01-01' AND '2022-06-30'
    GROUP BY c.member_id
    HAVING SUM(c.cost) > (SELECT AVG(SUM(cost)) * 1.5 FROM health_plan.claims GROUP BY member_id)
)
SELECT 
    hr.member_id,
    SUM(c.cost) AS original_cost,
    SUM(c.cost) * 0.93 AS optimized_cost, -- Simulate 7% cost reduction
    SUM(c.cost) * 0.07 AS savings
FROM high_risk hr
JOIN health_plan.claims c ON hr.member_id = c.member_id
WHERE c.admission_date BETWEEN '2022-01-01' AND '2022-06-30'
GROUP BY hr.member_id
ORDER BY savings DESC;
