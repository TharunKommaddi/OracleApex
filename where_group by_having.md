Let's take a simple example with a dataset of sales records to illustrate the use of `WHERE`, `GROUP BY`, and `HAVING`:

**Sample Data:**

| OrderID | Product  | Quantity | Sales | Date       |
|---------|----------|----------|-------|------------|
| 1       | Apple    | 5        | 10    | 2024-01-01 |
| 2       | Banana   | 10       | 20    | 2024-01-01 |
| 3       | Apple    | 2        | 4     | 2024-01-02 |
| 4       | Orange   | 3        | 15    | 2024-01-02 |
| 5       | Banana   | 1        | 2     | 2024-02-01 |

Let's say you want to find the total sales for each product, but only for the products where total quantity is more than 5 and only considering sales in January.

**SQL Query:**

```sql
SELECT Product, SUM(Sales) AS TotalSales
FROM SalesData
WHERE Date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY Product
HAVING SUM(Quantity) > 5;
```

**Explanation:**
- The `WHERE` clause filters the records to only include sales from January 2024.
- The `GROUP BY` clause groups the remaining records by the `Product` column.
- The `HAVING` clause filters these groups to include only those where the total quantity (sum of quantities in a group) is more than 5.

**Resulting Data:**

| Product  | TotalSales |
|----------|------------|
| Apple    | 14         |
| Banana   | 22         |

This query excludes the 'Orange' product because the total quantity for Orange in January is 3, which does not meet the `HAVING` condition of more than 5.
