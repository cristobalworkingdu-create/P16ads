# 无氧系列日报

MERACH 美国站无氧系列（P15–P18）与地垫套装（地垫 MR-2603 + 收边条 MR-2604）的每日看板。

- 独立网页：https://cristobalworkingdu-create.github.io/P16ads/daily/ （本目录 `index.html`，数据已内嵌）
- Claude 看板：https://claude.ai/artifact/FFb8QoJFUsoWFZxrCLYBhn
- 口径：日期按美西时间，只统计已结束的完整日；订单、销量、销售额来自 Shopify，浏览、加购、发起结账来自 Convbox（按事件计）。

## 目录

| 路径 | 说明 |
|---|---|
| `index.html` | 独立网页版（内嵌数据快照） |
| `dashboard/index.html` | Claude 看板页面源码 |
| `data/*.csv` | 数据快照：sales、funnel、orders、paths |
| `queries/d1–d5.sql` | 取数查询，`{{END}}` 为最近一个美西完整日，`{{ORDER_IDS}}` 由脚本生成 |
| `scripts/` | 解析、整理与生成脚本 |

## 每日更新步骤

1. `python3 scripts/end_date.py` 得到 END（最近一个已结束的美西完整日）。
2. 在 BigQuery 项目 `merach-452802` 依次运行 `d1_sales.sql`、`d2_funnel.sql`、`d3_items.sql`（把 `{{END}}` 换成 END）。每个查询带 `_pad` 列，结果会存成文件；用 `python3 scripts/pq.py <结果文件> <工作目录>/raw_sales.csv`（funnel、items 同理）转成 CSV。
3. `python3 scripts/order_ids.py <工作目录>/raw_items.csv` 得到订单号列表，填入 `d4_paths.sql`、`d5_survey.sql` 的 `{{ORDER_IDS}}` 后运行，分别存为 `raw_paths.csv`、`raw_survey.csv`。
4. `python3 scripts/build_daily.py <工作目录> data` 生成 `data/*.csv`；`python3 scripts/make_standalone.py .` 生成 `index.html`。
5. 把 4 个 CSV 上传到 Claude 看板的资源库，用 `python3 scripts/make_store_docs.py <输出目录> <END> sales=<id> funnel=<id> orders=<id> paths=<id>` 生成数据集文档并写入看板（`datasets/sales|funnel|orders|paths`），再删除旧的资源文件。
6. 提交并推送到 GitHub。

---

© Cristobal Du Peiming (杜沛明) — All Rights Reserved / 知识产权所有
