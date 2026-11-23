-- Shopify 每日销量与销售额（美西日期，截至 {{END}}）
SELECT CAST(date AS STRING) date, sku, SUM(order_count) orders, SUM(quantity) units, ROUND(SUM(net_amount),2) net_sales, REPEAT('.', 20000) _pad
FROM `merach-452802.miaoda.total_site_sku_by_date`
WHERE site='US' AND (spu IN ('P15','P16','P17','P18') OR REGEXP_CONTAINS(sku, r'^MR-260[34]')) AND sku <> 'MR-P16-HP-TEST'
  AND date BETWEEN '2026-10-20' AND '{{END}}'
  AND (order_count <> 0 OR quantity <> 0 OR net_amount <> 0)
GROUP BY 1,2
