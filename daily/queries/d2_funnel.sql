-- Convbox 商品漏斗：每个商品每天按渠道（U 型归因，截至 {{END}}）
WITH prod AS (
  SELECT * FROM UNNEST([STRUCT('10363227209903' AS product_id, 'P15' AS spu), ('10364097593519','P15'), ('10363239366831','P15'),
    ('10330238812335','P16'), ('10363226587311','P17'), ('10363225964719','P17'), ('10363225604271','P17'), ('10360842453167','P18'), ('10361139953839','地垫套装')])
)
SELECT CAST(par.ondate AS STRING) date, p.spu, par.channel_group, par.channel,
  ROUND(SUM(par.product_view),2) product_views, ROUND(SUM(par.sessions),2) sessions, ROUND(SUM(par.atc_sessions),2) atc_sessions, ROUND(SUM(par.ic_sessions),2) ic_sessions,
  ROUND(SUM(par.atc_events),3) atc_events, ROUND(SUM(par.ic_events),3) ic_events, ROUND(SUM(par.product_sold),3) sold_attr, ROUND(SUM(par.product_sales),2) sales_attr, REPEAT('.', 3000) _pad
FROM `merach-452802.convbox.product_report_v2` par JOIN prod p USING (product_id)
WHERE par.shop_name='merach-fitness-store' AND par.attribution_model='ushaped' AND par.ondate BETWEEN '2026-10-20' AND '{{END}}'
GROUP BY 1,2,3,4
HAVING SUM(par.product_view)+SUM(par.sessions)+SUM(par.atc_events)+SUM(par.ic_events)+SUM(par.product_sold) > 0
