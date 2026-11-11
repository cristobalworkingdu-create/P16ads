-- 数据集 sales_daily：Shopify 实际销售（miaoda）
SELECT CAST(date AS STRING) AS date, spu, sku, SUM(order_count) AS orders, SUM(quantity) AS units, ROUND(SUM(net_amount),2) AS net_sales, ROUND(SUM(product_cost),2) AS cogs
FROM `merach-452802.miaoda.total_site_sku_by_date`
WHERE site='US' AND brand='Merach' AND spu IN ('P15','P16','P17','P18') AND sku <> 'MR-P16-HP-TEST' AND date BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY)
  AND (order_count <> 0 OR quantity <> 0 OR net_amount <> 0)
GROUP BY 1,2,3
