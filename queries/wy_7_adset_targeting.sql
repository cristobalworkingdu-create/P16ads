-- meta_ads（第 3 部分）：Ad Set 兴趣标签
SELECT adset_name, STRING_AGG(DISTINCT targeting_name, ' | ') AS targeting
FROM `merach-452802.facebook_ads.adset_targeting` GROUP BY adset_name
