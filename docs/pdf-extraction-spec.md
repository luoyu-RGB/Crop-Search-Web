# PDF 资料抽取规范（第二阶段）

本文件规定《课程设计资料.pdf》逐页转写的字段、JSON 结构和校验规则。
转写结果保存在 `data/extracted/page-NN.json`，一份 JSON 对应 PDF 的一页。

来源资料：《中国非粮生物柴油植物》，扫描版，共 19 页，页码印刷为 11～29。
每页版式：左上为作物标题区，右栏与下方为图片（一页通常 3～5 张图），底部为含油率及化学组分数据表。

---

## 一、页面文件对应关系

| PDF 物理页 | 印刷页码 | 切片文件 |
|---:|---:|---|
| 1 | 11 | `work/chunks/page-01-text-top.png`、`page-01-text-bottom.png`、`page-01-table-left.png`、`page-01-table-right.png` |
| 2 | 12 | 同上规律 |
| … | … | … |
| 19 | 29 | 同上规律 |

切片说明：

- `-text-top`：左栏上半（作物名、英文名/拉丁学名、科属、特征、分布开头）。
- `-text-bottom`：左栏下半（分布结尾、栽培、用途）。
- `-table-left`：数据表左半（采集单位、测试单位、测试部位、产地、含油率、碘值、酸值、皂化值）。
- `-table-right`：数据表右半（C12:0 至 C20:1 各脂肪酸组分）。
- 如某页左栏内容被图片挤占、切片不完整，可再读取整页 `work/pages/page-NN.png`。

---

## 二、JSON 结构

```json
{
  "page": 1,
  "printedPage": "11",
  "section": "苏铁科 CYCADACEAE",
  "verified": false,
  "crops": [
    {
      "chineseName": "苏铁",
      "aliasText": "铁树",
      "englishName": null,
      "latinName": "Cycas revoluta Thunb.",
      "family": "苏铁科",
      "familyLatin": "CYCADACEAE",
      "genus": "苏铁属",
      "features": "……",
      "distribution": "……",
      "cultivation": "……",
      "uses": "……",
      "distributionPoints": [
        {
          "province": "广西",
          "locality": "桂林市广西植物研究所",
          "latitude": "25°04′58″N",
          "longitude": "110°17′58″E",
          "altitude": "159 m",
          "date": "2010-11-09",
          "collectors": "吴磊、吴望辉、农冬新",
          "collectionNo": "4001101117"
        }
      ],
      "images": [
        { "order": 1, "description": "雄球花（花序）特写", "isCover": false },
        { "order": 2, "description": "种子（橘红色）", "isCover": false },
        { "order": 3, "description": "植株全形与雄球花", "isCover": true }
      ],
      "chemistry": [
        {
          "collectionUnit": "GXIB",
          "testUnit": "SCBG",
          "testPart": "种仁",
          "origin": "广西桂林",
          "oilContent": 10.65,
          "iodineValue": 71.29,
          "acidValue": 1.25,
          "saponificationValue": 234.13,
          "fattyAcids": {
            "C12:0": null,
            "C14:0": 0.26,
            "C16:0": 5.38,
            "C16:1": 0.12,
            "C18:0": 2.45,
            "C18:1": 30.36,
            "C18:2": 50.55,
            "C18:3": 4.03,
            "C20:0": 2.31,
            "C20:1": 0.22
          }
        }
      ]
    }
  ]
}
```

---

## 三、字段规则

### 1. 名称类

- `chineseName`：作物中文名，不含括号内别名。
- `aliasText`：标题括号内的别名原文；没有填 `null`。多个别名用 `、` 分隔。
- `englishName`：资料中若有英文名则填写，否则 `null`（本书多数作物只有拉丁学名）。
- `latinName`：完整拉丁学名，含命名人缩写，按原文照抄。
- `family` / `genus`：中文科名、属名，例如“苏铁科”“苏铁属”。
- `familyLatin`：标题栏中的拉丁科名，全大写，例如 `CYCADACEAE`；没有则 `null`。

### 2. 文本类（`features` / `distribution` / `cultivation` / `uses`）

- 按原文完整转写，保留数字、单位和标点。
- **不要**改写、概括或翻译。
- `distribution` 保留采集地叙述原文；结构化的采集地点另记入 `distributionPoints`。
- `uses` 若原文分散在“用途”“其他”等段落，合并写入。
- 原文换行处直接连写，不保留硬换行。

### 3. 采集点 `distributionPoints`

- 一项对应原文“分布”段落中的一个采集记录（通常以省名开头）。
- 无法识别的字段填 `null`，不要猜测。
- `collectionNo` 为采集号（如 `4001101117`），原样保留数字串，注意不要漏位。

### 4. 图片 `images`

- 按页面阅读顺序编号，`order` 从 1 开始。
- `description` 用简短中文描述图片内容，例如“叶与果实”“树干”“花序特写”。
- 与该作物主图（通常是页面最大的那张）对应的记录 `isCover` 设为 `true`，其余为 `false`。

### 5. 化学数据 `chemistry`

- 一行表格数据对应一个对象。
- `collectionUnit` / `testUnit` 为缩写代码，原样照抄（例如 `GXIB`、`SCBG`、`JSU`、`SCU`、`ICS`）。
- `testPart` 常见为“种仁”“种子”“果仁”等。
- 数值字段一律用 **数字**，不带百分号和单位：`10.65`、`0.26`。
- **表格中的空白单元格一律填 `null`**，不要填 `0`、`"无"`、`""`。
- 表格中明确印出的 `0` 必须填 `0`，与空白区分。
- 数值最多保留两位小数，按原文，不做四舍五入或换算。

### 6. 顶层字段

- `page`：PDF 物理页码（1～19）。
- `printedPage`：页面印刷页码，字符串（例如 `"11"`）。
- `section`：该页页眉的科名（含拉丁名），例如 `"苏铁科 CYCADACEAE"`；没有则 `null`。
- `verified`：转写者填 `false`，人工校对通过后由流程改为 `true`。

---

## 四、必须遵守的转写纪律

1. **绝对不许编造**：图片看不清、数字模糊时，把该字段填 `null`，并在该 crop 的 `uncertain` 数组里写明字段名（例如 `"uncertain": ["iodineValue"]`）。
2. **化学数据是重点**：`C18:1`、`C18:2`、`C18:3` 等列名容易与数值错位，必须逐列对齐后再写入。
3. **数字逐字符核对**：特别注意 `0` 与 `6`、`1` 与 `7`、小数点位置、以及 `10.65` 与 `1.065` 这类量级差别。
4. **拉丁学名逐字母照抄**，保留大小写、空格、缩写点号与命名人。
5. **一页可能有多个作物**：`crops` 是数组，按页面上出现的顺序排列。
6. 无法确定的整段内容填 `null`，不要留空字符串 `""`。
7. 不添加任何原文没有的解释性文字。

---

## 五、校验规则（脚本自动检查）

| 检查项 | 规则 |
|---|---|
| JSON 合法性 | 必须能被标准 JSON 解析 |
| 必填字段 | `page`、`crops`；每个作物必须有 `chineseName` |
| 文本完整性 | `features` / `distribution` / `cultivation` / `uses` 若为字符串则长度 ≥ 5 |
| 数值类型 | `oilContent`、`iodineValue`、`acidValue`、`saponificationValue`、各脂肪酸必须为数字或 `null` |
| 数值范围 | 所有百分数类数值需在 `0`～`100`；`iodineValue` ≤ `300`；`saponificationValue` ≤ `400` |
| 组分数 | `fattyAcids` 必须包含 10 个固定键：`C12:0`、`C14:0`、`C16:0`、`C16:1`、`C18:0`、`C18:1`、`C18:2`、`C18:3`、`C20:0`、`C20:1` |
| 页码 | `page` 与文件名 `page-NN.json` 一致 |
| 命名 | `latinName` 不得与其它作物的 `latinName` 完全相同 |
| 表格行数 | 每页 `chemistry` 行数应等于该页数据表行数 |

校验脚本：`work/validate_extract.py`，用法：

```powershell
python work\validate_extract.py
```
