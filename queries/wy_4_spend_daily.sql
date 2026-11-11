-- 数据集 spend_daily：无氧专投花费（Meta + Google），位于 US
SELECT 'Meta Ads' AS channel, CAST(DATE(date_start) AS STRING) AS date, campaign_name, ROUND(SUM(spend),2) AS spend, SUM(impressions) AS impressions, SUM(link_clicks) AS clicks
FROM `merach-452802.facebook_ads.facebook_ad_insights`
WHERE DATE(date_start) BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND REGEXP_CONTAINS(campaign_name, r'P1[5-8]')
GROUP BY 1,2,3
UNION ALL
SELECT 'Google Ads', CAST(PARSE_DATE('%Y/%m/%d', __hevo_report_date) AS STRING), name, ROUND(SUM(cost_micros)/1e6,2), SUM(impressions), SUM(clicks)
FROM `merach-452802.google_ads.google_campaign`
WHERE PARSE_DATE('%Y/%m/%d', __hevo_report_date) BETWEEN '2026-10-20' AND DATE_SUB(CURRENT_DATE('America/Los_Angeles'), INTERVAL 1 DAY) AND REGEXP_CONTAINS(name, r'P1[5-8]')
GROUP BY 1,2,3
