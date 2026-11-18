"""打印最近一个已结束的美西完整日（YYYY-MM-DD）。"""
import datetime
from zoneinfo import ZoneInfo
print((datetime.datetime.now(ZoneInfo('America/Los_Angeles')).date() - datetime.timedelta(days=1)).isoformat())
