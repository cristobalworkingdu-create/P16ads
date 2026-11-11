-- 数据集 attr_sources：全部流量来源归因（Convbox 渠道报表，U 型）
WITH prod AS (
  SELECT * FROM UNNEST([STRUCT('10363227209903' AS product_id, 'P15' AS spu), ('10364097593519','P15'), ('10363239366831','P15'),
    ('10330238812335','P16'), ('10363226587311','P17'), ('10363225964719','P17'), ('10363225604271','P17'), ('10360842453167','P18')])
)
SELECT p.spu, par.channel_group, par.channel,
  ROUND(SUM(par.product_view),1) AS product_views, ROUND(SUM(par.sessions),1) AS sessions, ROUND(SUM(par.atc_sessions),1) AS atc, ROUND(SUM(par.ic_sessions),1) AS checkout,
  ROUND(SUM(par.product_sold),3) AS orders_attr, ROUND(SUM(par.product_sales),2) AS revenue_attr
FROM `merach-452802.convbox.product_report_v2` par
JOIN prod p ON p.product_id = par.product_id
WHERE par.ondate BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND par.shop_name='merach-fitness-store' AND par.attribution_model='ushaped'
GROUP BY 1,2,3
