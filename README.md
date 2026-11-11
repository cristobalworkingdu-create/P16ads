# P16ads · MERACH 无氧系列广告看板

美国站无氧系列（P15 / P16 / P17 / P18）的广告闭环看板源码归档，包括看板页面、计算逻辑、数据快照和取数查询。

- 独立网页：https://cristobalworkingdu-create.github.io/P16ads/ （仓库根目录 `index.html`，数据已内嵌，直接打开即可）
- Claude 看板：https://claude.ai/artifact/25qHmdwquaqfwF6Gp5YdAn
- 数据范围：2026-10-20 至 2026-11-10（美西时间）
- 数据来源：公司 BigQuery 项目 `merach-452802`（Convbox、Meta、Google、Shopify 汇总表）

## 看板内容

**第一层：无氧系列（可切换 系列合计 / P15 / P16 / P17 / P18）**
- 核心指标：Shopify 实际订单与净销售、专投花费、综合投产比、付费广告归因（专投 / 其他广告带动）、非付费来源归因
- 谁带动了无氧：各渠道付费归因按广告类型拆分（无氧专投、品牌词搜索、其他产品广告、大促 / 通用、未匹配到名称），以及带动产品排行、全部流量来源、Campaign 明细
- 每日专投花费与实际订单

**第二层：P16 专投内容表现**
- 专投漏斗（展示 → 点击 → 进站 → 加购 → 结账 → 归因订单）
- 素材 × 人群 × 投放层级热力图
- 人群表现与同条件人群测试
- 素材表现、素材格式对比
- Meta / Google P16 专投 Campaign

## 目录结构

| 路径 | 说明 |
|---|---|
| `index.html` | 独立网页版：内嵌数据快照与运行层，可直接用浏览器或 GitHub Pages 打开 |
| `dashboard/index.html` | 看板页面（含计算逻辑与绘图代码），运行于 Claude 看板环境（依赖 `dash` 与 `d3`） |
| `dashboard/datasets/*.json` | 看板数据集定义（标题、说明、快照时间） |
| `data/*.csv` | 数据快照 |
| `queries/wy_*.sql` | 取数查询 |

## 数据集

| 数据集 | 内容 | 查询 |
|---|---|---|
| `sales_daily` | Shopify 实际销售，按日期 × SKU | `wy_3_sales_daily.sql` |
| `spend_daily` | 无氧专投花费（Meta + Google），按日期 × Campaign | `wy_4_spend_daily.sql` |
| `attr_campaigns` | 付费广告归因（Convbox，U 型，Campaign 层级） | `wy_1_attr_campaigns.sql` |
| `attr_sources` | 全部流量来源归因（Convbox 渠道报表，U 型） | `wy_2_attr_sources.sql` |
| `meta_ads` | P16 专投 Meta 广告明细（Campaign × Ad Set × 广告） | `wy_5` + `wy_6` + `wy_7` |

## 口径

- 产品对应：P15 = 3 个杠铃片商品（含 BOGOS 赠品）；P16 = 史密斯机（排除测试 SKU）；P17 = 3 个商品；P18 = 训练凳。
- 归因：统一使用 Convbox U 型归因。Convbox 统计成交件数，P15 买赠会使件数偏高、营收偏低。
- 广告类型（按 Campaign 名称归类）：含 P15–P18 为无氧专投；含 Brand 为品牌词搜索；含其他产品代号或品类为其他产品广告；其余为大促 / 通用；Convbox 中查不到名称的单列。
- 综合投产比 = 实际净销售 ÷ 专投花费；归因 ROAS = 专投广告归因营收 ÷ 专投花费。
- Convbox 数据位于 us-central1，广告平台数据位于 US，两者分开查询后合并。

## 刷新

看板为数据快照，打开时不查询 BigQuery。刷新时按 `queries/` 中的查询重新取数（截止到美西时间前一天），整理后替换 `data/` 中的快照，并重新生成根目录的 `index.html`。

---

© Cristobal Du Peiming (杜沛明) — All Rights Reserved / 知识产权所有
