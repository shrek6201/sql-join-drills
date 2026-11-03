# SQL Join Drills

Practice project covering all join types in SQL Server, with a focus on NULL behaviour.
Built with SQL Server 2025 Developer and SSMS.

## Data
- `customers` (5 rows): includes customers with no orders
- `orders` (7 rows): includes two NULL customer_ids and one orphan (customer 99)
- `employees` (4 rows): used for the self join

## Results
| Query | Rows | Why |
|---|---|---|
| INNER JOIN | 4 | Only rows that match on both sides; NULL and orphan keys are dropped |
| LEFT JOIN | 6 | All customers kept; Dana and Eli have NULL orders |
| RIGHT JOIN | 7 | All orders kept; 3 have no matching customer |
| FULL OUTER JOIN | 9 | 4 matches + 2 unmatched customers + 3 unmatched orders |
| CROSS JOIN | 35 | 5 x 7, no condition |
| SELF JOIN (inner) | 3 | Priya has no manager, so she is excluded |
| SELF JOIN (left) | 4 | Priya kept with NULL manager |
| Anti-join: LEFT + IS NULL | 2 | Customers without orders |
| Anti-join: NOT EXISTS | 2 | Same result, NULL-safe |
| Anti-join: NOT IN | 0 | Subquery contains NULL, so comparison is UNKNOWN |
| LEFT JOIN, filter in ON | 5 | All customers kept |
| LEFT JOIN, filter in WHERE | 2 | WHERE removes NULL rows, acting like an INNER JOIN |

## Key takeaways
- NULL never equals NULL, so NULL join keys never match.
- Filtering the outer table in WHERE turns an outer join into an inner join.
- Prefer NOT EXISTS over NOT IN when the column can contain NULLs.

## How to run
Open `join_drills.sql` in SSMS and run it top to bottom.
