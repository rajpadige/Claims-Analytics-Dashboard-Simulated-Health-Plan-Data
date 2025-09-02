# Claims Analytics Dashboard – Simulated Health Plan Data 🩺📊

## Introduction 🌟
Managing healthcare costs and provider performance is vital for effective health plan administration. In November 2022, this project developed a Snowflake-based claims warehouse and Tableau dashboards to analyze simulated health plan data. By consolidating eligibility, provider, and claims records, we provided insights into per-member-per-month (PMPM) costs, readmission rates, and provider performance, with simulations for contract optimization to enhance cost efficiency.

The goal was to create a scalable analytics platform to support data-driven decisions in population health management, empowering administrators to optimize outcomes and reduce costs.

## Literature Review 📚🔍
This project draws on healthcare analytics literature, including reports from the Healthcare Cost Institute and studies in the Journal of Healthcare Management. Research by Bates et al. (2014) highlights the value of data warehousing for integrating healthcare datasets. Eckerson (2011) underscores Tableau’s effectiveness for visualizing complex metrics. Studies from the Agency for Healthcare Research and Quality emphasize PMPM cost analysis and readmission tracking, guiding our focus. Snowflake’s scalability, as noted in industry whitepapers, supports our data platform choice.

## Problem Statement 🎯
Can we consolidate disparate healthcare data to monitor costs, readmissions, and provider performance effectively? This project aims to:
- Build a centralized Snowflake warehouse for eligibility, provider, and claims data.
- Develop Tableau dashboards for PMPM costs, readmission rates, and provider performance.
- Simulate contract optimization scenarios to reduce costs for high-risk populations.

## Methodology 📊🔬
We employed a three-pronged approach:
1. **Data Warehousing**: Snowflake SQL queries consolidated and normalized data, creating a scalable claims warehouse.
2. **Visualization**: Tableau dashboards visualized PMPM costs, readmission rates, and provider performance for interactive analysis.
3. **Simulation**: SQL-based scenarios modeled contract adjustments to optimize costs.

This methodology ensured a robust, user-friendly analytics solution.

## Data Collection and Preparation 📈🔍
The simulated health plan dataset included:
- **Eligibility Records**: Member ID, demographics, enrollment status.
- **Provider Records**: Provider ID, specialty, network status.
- **Claims Records**: Claim ID, procedure codes, costs, admission/discharge dates.

Snowflake SQL queries cleaned and joined datasets, resolving duplicates, missing provider IDs, and inconsistent date formats. Indexes optimized query performance, and aggregated tables supported dashboard integration, ensuring reliable data for analysis.

## Analysis and Results 📝📈
Key findings from the analysis:
- **PMPM Costs**: Average PMPM cost was $450, with 60% of costs driven by high-risk members (top 20%), identified via SQL queries.
- **Readmission Rates**: 30-day readmission rates averaged 8%, with some providers reaching 12%, visualized in Tableau.
- **Provider Performance**: Top providers had 15% lower PMPM costs than the median.
- **Contract Optimization**: Simulations showed 5-7% cost reductions for high-risk populations.

Tableau dashboards enabled drill-downs by region, provider specialty, and member cohort, enhancing stakeholder insights.

## Conclusion and Recommendations 🎉🔮
This project delivered a Snowflake-based claims warehouse and Tableau dashboards, revealing critical healthcare metrics and cost-saving opportunities. Recommendations include:
- Scale the warehouse with real-time claims feeds for dynamic monitoring.
- Enhance dashboards with machine learning for readmission risk prediction.
- Use simulation results to negotiate cost-effective provider contracts.

This platform empowers health plan administrators to drive proactive, data-driven decisions! 🩺🚀

### Repository Files
- `warehouse.sql`: Snowflake queries for building and querying the claims warehouse.
- `dashboard.twb`: Tableau workbook with PMPM, readmission, and performance dashboards.
- `report.pdf`: Comprehensive report detailing methodology and findings.
