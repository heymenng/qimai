# 炁脉医学知识图谱 Neo4j Schema 设计 V1.0

> **定位**：将分散的医学知识转化为可查询、可推理的图数据库
> **用途**：AI临床决策的知识底层 + 研究分析工具
> **技术栈**：Neo4j + Cypher + Python (py2neo/neo4j-driver)
> **版本**：V1.0（Schema设计阶段）
> **更新**：2026年5月7日

---

## 一、图谱架构概览

### 1.1 核心实体（节点类型）

```
【节点标签（Node Labels）】

(:Patient)          - 患者
(:Symptom)          - 症状
(:Diagnosis)        - 诊断（含五维诊断）
(:Treatment)        - 治疗方案
(:Herb)             - 中药
(:Formula)          - 方剂
(:Master)           - 国医大师
(:Disease)          - 疾病
(:Organ)            - 脏腑/器官
(: Meridian)        - 经络
(:Test)             - 检测/化验
(:Dimension)        - 五维维度
(:Card)             - 54牌
(:Pattern)          - 协同模式
(:Case)             - 案例
```

### 1.2 核心关系（Relationship Types）

```
【关系类型（Relationship Types）】

(:Patient)-[:HAS_SYMPTOM]->(:Symptom)           患者有症状
(:Patient)-[:HAS_DIAGNOSIS]->(:Diagnosis)       患者有诊断
(:Patient)-[:RECEIVES]->(:Treatment)           患者接受治疗
(:Patient)-[:DOCUMENTED_IN]->(:Case)            患者记录在案例中

(:Symptom)-[:INDICATES]->(:Disease)            症状指示疾病
(:Symptom)-[:MAPS_TO]->(:Dimension)           症状映射到五维
(:Symptom)-[:LOCATED_AT]->(:Organ)            症状定位于脏腑
(:Symptom)-[:FLOWS_IN]->(:Meridian)           症状循行于经络

(:Diagnosis)-[:HAS_FIVE_DIMENSION]->(:Dimension) 诊断包含五维
(:Diagnosis)-[:FOLLOWS_GUIDELINE]->(:Guideline) 诊断遵循指南

(:Treatment)-[:USES_HERB]->(:Herb)              治疗使用中药
(:Treatment)-[:USES_FORMULA]->(:Formula)        治疗使用方剂
(:Treatment)-[:USES_CARD]->(:Card)             治疗使用54牌
(:Treatment)-[:FOR_DISEASE]->(:Disease)         治疗针对疾病

(:Herb)-[:BELONGS_TO]->(:Formula)              中药属于方剂
(:Herb)-[:HAS_PROPERTY]->(:Property)           中药有属性
(:Herb)-[:TARGETS]->(:Dimension)               中药靶向五维
(:Herb)-[:ENTERS]->(:Organ)                    中药入脏腑
(:Herb)-[:FLOWS_IN]->(:Meridian)               中药归经络

(:Formula)-[:CREATED_BY]->(:Master)             方剂由大师创建
(:Formula)-[:HAS_PATTERN]->(:Pattern)           方剂有协同模式
(:Formula)-[:TREATS]->(:Disease)                方剂治疗疾病

(:Disease)-[:AFFECTS]->(:Organ)                 疾病影响脏腑
(:Disease)-[:FLOWS_IN]->(:Meridian)             疾病循行经络
(:Disease)-[:HAS_SYMPTOM]->(:Symptom)           疾病有症状

(:Test)-[:MEASURES]->(:Dimension)               检测测量维度
(:Test)-[:INDICATES]->(:Disease)                检测指示疾病

(:Case)-[:HAS_TREATMENT]->(:Treatment)          案例包含治疗
(:Case)-[:HAS_DIAGNOSIS]->(:Diagnosis)          案例包含诊断
(:Case)-[:RESULTS_IN]->(:Outcome)               案例产生结果
```

---

## 二、节点属性详细设计

### 2.1 (:Patient) 患者节点

```cypher
(:Patient {
  id: "PT-1945-2026-035",           // 档案编号
  name: "戈父",                      // 姓名（脱敏）
  gender: "男",                      // 性别
  birth_year: 1945,                  // 出生年
  age: 70,                           // 当前年龄
  occupation: "退休",                 // 职业
  city: "杭州",                      // 城市
  case_category: "10-普通案例",       // 案例分类
  total_sessions: 95,                // 总调理次数
  archive_version: "V4.3"            // 档案版本
})
```

### 2.2 (:Symptom) 症状节点

```cypher
(:Symptom {
  id: "SYM-001",
  name: "甲状腺结节",                 // 症状名称
  category: "体征",                   // 分类：症状/体征
  severity_scale: "1-10",             // 严重程度量表
  description: "颈部可触及肿块"         // 描述
})
```

### 2.3 (:Dimension) 五维维度节点

```cypher
(:Dimension {
  id: "DIM-QI",                      // 维度ID
  name: "炁维",                       // 维度名称
  full_name: "炁（生命能量）",
  level_range: "1-10",                // 级别范围
  description: "生命能量状态，包括元气、宗气、营气、卫气"
})

// 五维节点实例
(:Dimension {id: "DIM-QI", name: "炁维"})
(:Dimension {id: "DIM-DU", name: "毒维"})
(:Dimension {id: "DIM-MAI", name: "脉维"})
(:Dimension {id: "DIM-XIE", name: "邪维"})
(:Dimension {id: "DIM-YIN", name: "瘾维"})
```

### 2.4 (:Diagnosis) 诊断节点

```cypher
(:Diagnosis {
  id: "DX-001",
  type: "五维诊断",                   // 诊断类型
  qi_level: 6,                        // 炁维级别
  du_level: 5,                        // 毒维级别
  mai_level: 5,                       // 脉维级别
  xie_level: 3,                       // 邪维级别
  yin_level: 0,                       // 瘾维级别
  keywords: "复命期炁虚，痰瘀互结",     // 诊断关键词
  date: "2026-03-26"                  // 诊断日期
})
```

### 2.5 (:Herb) 中药节点

```cypher
(:Herb {
  id: "HERB-128",                    // 中药ID
  name: "当归",                       // 药名
  pinyin: "Dang Gui",
  category: "补血药",                 // 功效分类
  nature: "甘、辛，温",               // 性味
  meridians: ["肝", "心", "脾"],      // 归经
  five_dimensions: ["炁维", "脉维"],   // 五维映射
  card_suit: "♥",                     // 54牌花色
  card_rank: "Q",                     // 54牌等级
  dosage_min: 6,                      // 最小剂量(g)
  dosage_max: 15,                     // 最大剂量(g)
  dosage_special: "",                 // 特殊煎煮法
  contraindications: ["湿盛中满", "大便溏泄"],  // 禁忌
  source: "554味数据库V2.0"            // 数据来源
})
```

### 2.6 (:Formula) 方剂节点

```cypher
(:Formula {
  id: "FORM-ZLC-001",                // 方剂ID
  name: "扶正消癥汤",                 // 方名
  master: "朱良春",                   // 创始人
  category: "肿瘤基础方",             // 分类
  efficacy: "益气养阴，清热解毒，软坚散结",  // 功效
  indications: ["肺癌", "胃癌", "肝癌", "乳腺癌"],  // 主治
  five_dimensions: {
    qi: ["黄芪", "党参", "生晒参"],
    du: ["龙葵", "白花蛇舌草", "半枝莲"],
    mai: ["牡蛎", "蜂房", "守宫"],
    xie: ["葶苈子"],
    yin: []
  },
  synergy_pattern: "毒-补平衡",        // 协同模式
  source: "国医大师经验方数据库V1.0"
})
```

### 2.7 (:Master) 国医大师节点

```cypher
(:Master {
  id: "MASTER-ZLC",
  name: "朱良春",
  title: "国医大师",
  specialty: "虫类药学家·疑难病克星",
  core_philosophy: "扶正消癥，虫蚁搜剔",
  style: "大剂量、虫类药",
  active_years: "1917-2015",
  source: "国医大师经验方数据库V1.0"
})
```

### 2.8 (:Disease) 疾病节点

```cypher
(:Disease {
  id: "DIS-001",
  name: "甲状腺结节",
  icd10: "E04.1",                     // ICD编码
  category: "内分泌疾病",
  severity: "良性/恶性待查",
  western_medicine: "Thyroid Nodule",
  tcm_pattern: "痰瘀互结",             // 中医辨证
  five_dimensions: {
    qi: "6级·炁虚",
    du: "5级·毒积",
    mai: "5级·脉滞",
    xie: "3级·邪微",
    yin: "无"
  },
  guidelines: ["ATA-2015", "ATA-2023"]  // 相关指南
})
```

### 2.9 (:Card) 54牌节点

```cypher
(:Card {
  id: "CARD-HK",                     // 牌ID
  suit: "♥",                         // 花色
  rank: "K",                         // 等级
  name: "红桃K",
  full_name: "强力补气",
  strategy: "大补元气",
  target_dimension: "炁维",
  herbs: ["人参", "黄芪", "紫河车"],
  indications: ["炁虚7级以上", "重症肌无力", "肿瘤后期"],
  contraindications: ["实热证", "感冒发热"]
})
```

### 2.10 (:Pattern) 协同模式节点

```cypher
(:Pattern {
  id: "PAT-001",
  name: "相须增效",
  english_name: "Mutual Enhancement",
  description: "两味药功效同类，合用后效果 > 单用之和",
  mechanism: "同靶点叠加或同通路放大",
  example: "黄芪+党参",
  five_dimension_feature: "同一维度内的强强联合",
  card_mapping: "♥K+♥Q"
})
```

### 2.11 (:Case) 案例节点

```cypher
(:Case {
  id: "CASE-001",
  case_id: "PT-1945-2026-035",
  category: "10-普通案例",
  subcategory: "01-代谢内分泌",
  version: "V4.3",
  create_date: "2026-03-26",
  total_sessions: 95,
  outcome: "改善",                    // 痊愈/改善/稳定/恶化/失访
  has_complete_five_dimensions: true,
  has_western_diagnosis: true,
  has_prescription: true,
  has_follow_up: true
})
```

---

## 三、关系属性详细设计

### 3.1 [:HAS_SYMPTOM] 关系

```cypher
(:Patient)-[:HAS_SYMPTOM {
  severity: 7,                       // 严重程度 1-10
  duration: "3个月",                  // 持续时间
  frequency: "持续",                  // 发作频率
  onset_date: "2026-01-15"           //  onset日期
}]->(:Symptom)
```

### 3.2 [:HAS_DIAGNOSIS] 关系

```cypher
(:Patient)-[:HAS_DIAGNOSIS {
  date: "2026-03-26",
  method: "望闻问切+仪器检测",
  confidence: "高"
}]->(:Diagnosis)
```

### 3.3 [:USES_HERB] 关系

```cypher
(:Treatment)-[:USES_HERB {
  dosage: 30,                        // 剂量(g)
  role: "君药",                      // 君臣佐使
  preparation: "先煎",               // 煎煮法
  duration: "30天"                   // 使用疗程
}]->(:Herb)
```

### 3.4 [:HAS_PATTERN] 关系

```cypher
(:Formula)-[:HAS_PATTERN {
  herb_pair: ["黄芪", "党参"],
  synergy_mechanism: "同靶点叠加",
  evidence_level: "大师经验",
  clinical_significance: "补气力提升220%"
}]->(:Pattern)
```

### 3.5 [:MAPS_TO] 关系

```cypher
(:Symptom)-[:MAPS_TO {
  level: 8,                          // 维度级别
  confidence: "高",
  evidence: "口苦+易怒+失眠"
}]->(:Dimension)
```

---

## 四、Cypher查询示例

### 4.1 基础查询

```cypher
// Q1: 查找某位大师的所有方剂
MATCH (m:Master {name: "朱良春"})-[:CREATED]->(f:Formula)
RETURN f.name, f.efficacy, f.indications

// Q2: 查找治疗甲状腺结节的所有方剂
MATCH (d:Disease {name: "甲状腺结节"})<-[:TREATS]-(f:Formula)
RETURN f.name, f.master, f.efficacy

// Q3: 查找某患者的五维诊断
MATCH (p:Patient {id: "PT-1945-2026-035"})-[:HAS_DIAGNOSIS]->(d:Diagnosis)
RETURN d.qi_level, d.du_level, d.mai_level, d.xie_level, d.yin_level

// Q4: 查找某方剂的所有组成药物
MATCH (f:Formula {name: "扶正消癥汤"})-[:CONTAINS]->(h:Herb)
RETURN h.name, h.dosage, h.role
ORDER BY h.role
```

### 4.2 复杂查询

```cypher
// Q5: 查找所有使用"相须增效"模式的方剂
MATCH (f:Formula)-[:HAS_PATTERN]->(p:Pattern {name: "相须增效"})
MATCH (f)-[:CONTAINS]->(h:Herb)
RETURN f.name, p.name, collect(h.name) as herbs

// Q6: 查找某症状对应的所有经络和脏腑
MATCH (s:Symptom {name: "甲状腺肿大"})-[:LOCATED_AT]->(o:Organ)
MATCH (s)-[:FLOWS_IN]->(m:Meridian)
RETURN s.name, o.name, m.name

// Q7: 查找炁维8级以上的所有案例
MATCH (p:Patient)-[:HAS_DIAGNOSIS]->(d:Diagnosis)
WHERE d.qi_level >= 8
RETURN p.name, p.age, d.qi_level, d.keywords

// Q8: 查找某患者的治疗方案中所有药物的五维映射
MATCH (p:Patient {id: "PT-1945-2026-035"})-[:RECEIVES]->(t:Treatment)
MATCH (t)-[:USES_HERB]->(h:Herb)
RETURN h.name, h.five_dimensions, h.card_suit + h.card_rank as card

// Q9: 查找符合AACE糖尿病指南的所有案例
MATCH (p:Patient)-[:HAS_DIAGNOSIS]->(d:Diagnosis)
MATCH (d)-[:FOLLOWS_GUIDELINE]->(g:Guideline {name: "AACE-2023"})
RETURN p.name, p.age, d.keywords

// Q10: 查找某疾病的最常用药物组合
MATCH (d:Disease {name: "糖尿病"})<-[:FOR_DISEASE]-(t:Treatment)
MATCH (t)-[:USES_HERB]->(h:Herb)
WITH h, count(*) as frequency
ORDER BY frequency DESC
LIMIT 10
RETURN h.name, h.category, frequency
```

### 4.3 推理查询

```cypher
// Q11: 根据症状推荐五维维度（智能诊断辅助）
MATCH (s:Symptom)-[:MAPS_TO]->(d:Dimension)
WHERE s.name IN ["口苦", "易怒", "失眠"]
WITH d, count(*) as symptom_count
RETURN d.name, d.level_range, symptom_count
ORDER BY symptom_count DESC

// Q12: 根据五维缺口推荐54牌
MATCH (d:Dimension)<-[:TARGETS]-(c:Card)
WHERE d.name = "炁维"
WITH c, d
ORDER BY c.rank DESC
RETURN c.name, c.strategy, c.herbs
LIMIT 5

// Q13: 查找某大师的用药偏好（网络分析）
MATCH (m:Master {name: "朱良春"})-[:CREATED]->(f:Formula)
MATCH (f)-[:CONTAINS]->(h:Herb)
WITH h, count(*) as frequency
ORDER BY frequency DESC
LIMIT 10
RETURN h.name, h.category, frequency

// Q14: 药物-症状关联分析（发现新关联）
MATCH (h:Herb)<-[:USES_HERB]-(t:Treatment)-[:FOR_DISEASE]->(d:Disease)
MATCH (d)-[:HAS_SYMPTOM]->(s:Symptom)
WHERE h.name = "黄芪"
WITH s, count(*) as frequency
ORDER BY frequency DESC
LIMIT 10
RETURN s.name, frequency

// Q15: 查找某患者的完整治疗路径
MATCH path = (p:Patient {id: "PT-1945-2026-035"})-[:HAS_SYMPTOM]->(s:Symptom)
              -[:INDICATES]->(d:Disease)
              <-[:TREATS]-(f:Formula)
              -[:CONTAINS]->(h:Herb)
              -[:TARGETS]->(dim:Dimension)
RETURN path
```

---

## 五、Python导入脚本框架

### 5.1 依赖安装

```bash
pip install neo4j pandas openpyxl
```

### 5.2 连接配置

```python
# config.py
NEO4J_URI = "bolt://localhost:7687"
NEO4J_USER = "neo4j"
NEO4J_PASSWORD = "your_password"

# 数据库名称（Neo4j 4.0+）
NEO4J_DATABASE = "qimai"
```

### 5.3 导入脚本框架

```python
# import_to_neo4j.py

from neo4j import GraphDatabase
import pandas as pd
import json

class QiMaiKnowledgeGraph:
    def __init__(self, uri, user, password, database="qimai"):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        self.database = database
        
    def close(self):
        self.driver.close()
    
    def create_constraint(self):
        """创建唯一性约束"""
        constraints = [
            "CREATE CONSTRAINT patient_id IF NOT EXISTS FOR (p:Patient) REQUIRE p.id IS UNIQUE",
            "CREATE CONSTRAINT herb_id IF NOT EXISTS FOR (h:Herb) REQUIRE h.id IS UNIQUE",
            "CREATE CONSTRAINT formula_id IF NOT EXISTS FOR (f:Formula) REQUIRE f.id IS UNIQUE",
            "CREATE CONSTRAINT dimension_id IF NOT EXISTS FOR (d:Dimension) REQUIRE d.id IS UNIQUE",
            "CREATE CONSTRAINT card_id IF NOT EXISTS FOR (c:Card) REQUIRE c.id IS UNIQUE",
            "CREATE CONSTRAINT master_id IF NOT EXISTS FOR (m:Master) REQUIRE m.id IS UNIQUE",
            "CREATE CONSTRAINT disease_id IF NOT EXISTS FOR (d:Disease) REQUIRE d.id IS UNIQUE",
        ]
        
        with self.driver.session(database=self.database) as session:
            for constraint in constraints:
                try:
                    session.run(constraint)
                    print(f"✅ 创建约束: {constraint}")
                except Exception as e:
                    print(f"⚠️ 约束已存在或错误: {e}")
    
    def import_herbs(self, csv_file):
        """导入中药数据"""
        df = pd.read_csv(csv_file)
        
        query = """
        UNWIND $rows as row
        MERGE (h:Herb {id: row.id})
        SET h.name = row.name,
            h.pinyin = row.pinyin,
            h.category = row.category,
            h.nature = row.nature,
            h.meridians = split(row.meridians, "|"),
            h.five_dimensions = split(row.five_dimensions, "|"),
            h.card_suit = row.card_suit,
            h.card_rank = row.card_rank,
            h.dosage_min = toInteger(row.dosage_min),
            h.dosage_max = toInteger(row.dosage_max),
            h.contraindications = split(row.contraindications, "|"),
            h.source = row.source
        """
        
        with self.driver.session(database=self.database) as session:
            session.run(query, rows=df.to_dict('records'))
            print(f"✅ 导入 {len(df)} 个中药节点")
    
    def import_formulas(self, csv_file):
        """导入方剂数据"""
        df = pd.read_csv(csv_file)
        
        query = """
        UNWIND $rows as row
        MERGE (f:Formula {id: row.id})
        SET f.name = row.name,
            f.master = row.master,
            f.category = row.category,
            f.efficacy = row.efficacy,
            f.indications = split(row.indications, "|"),
            f.synergy_pattern = row.synergy_pattern,
            f.source = row.source
        """
        
        with self.driver.session(database=self.database) as session:
            session.run(query, rows=df.to_dict('records'))
            print(f"✅ 导入 {len(df)} 个方剂节点")
    
    def import_formula_herb_relations(self, csv_file):
        """导入方剂-中药关系"""
        df = pd.read_csv(csv_file)
        
        query = """
        UNWIND $rows as row
        MATCH (f:Formula {id: row.formula_id})
        MATCH (h:Herb {id: row.herb_id})
        MERGE (f)-[r:CONTAINS]->(h)
        SET r.dosage = toInteger(row.dosage),
            r.role = row.role,
            r.preparation = row.preparation
        """
        
        with self.driver.session(database=self.database) as session:
            session.run(query, rows=df.to_dict('records'))
            print(f"✅ 导入 {len(df)} 个方剂-中药关系")
    
    def import_cases(self, csv_file):
        """导入案例数据"""
        df = pd.read_csv(csv_file)
        
        query = """
        UNWIND $rows as row
        MERGE (c:Case {id: row.case_id})
        SET c.case_id = row.case_id,
            c.category = row.category,
            c.subcategory = row.subcategory,
            c.version = row.version,
            c.create_date = row.create_date,
            c.total_sessions = toInteger(row.total_sessions),
            c.outcome = row.outcome
        """
        
        with self.driver.session(database=self.database) as session:
            session.run(query, rows=df.to_dict('records'))
            print(f"✅ 导入 {len(df)} 个案例节点")
    
    def import_patients(self, csv_file):
        """导入患者数据"""
        df = pd.read_csv(csv_file)
        
        query = """
        UNWIND $rows as row
        MERGE (p:Patient {id: row.id})
        SET p.name = row.name,
            p.gender = row.gender,
            p.birth_year = toInteger(row.birth_year),
            p.age = toInteger(row.age),
            p.occupation = row.occupation,
            p.city = row.city,
            p.case_category = row.case_category,
            p.total_sessions = toInteger(row.total_sessions),
            p.archive_version = row.archive_version
        """
        
        with self.driver.session(database=self.database) as session:
            session.run(query, rows=df.to_dict('records'))
            print(f"✅ 导入 {len(df)} 个患者节点")
    
    def create_indexes(self):
        """创建索引以优化查询性能"""
        indexes = [
            "CREATE INDEX herb_name IF NOT EXISTS FOR (h:Herb) ON (h.name)",
            "CREATE INDEX herb_category IF NOT EXISTS FOR (h:Herb) ON (h.category)",
            "CREATE INDEX formula_name IF NOT EXISTS FOR (f:Formula) ON (f.name)",
            "CREATE INDEX disease_name IF NOT EXISTS FOR (d:Disease) ON (d.name)",
            "CREATE INDEX symptom_name IF NOT EXISTS FOR (s:Symptom) ON (s.name)",
            "CREATE INDEX dimension_name IF NOT EXISTS FOR (d:Dimension) ON (d.name)",
        ]
        
        with self.driver.session(database=self.database) as session:
            for index in indexes:
                try:
                    session.run(index)
                    print(f"✅ 创建索引: {index}")
                except Exception as e:
                    print(f"⚠️ 索引已存在或错误: {e}")

# 使用示例
if __name__ == "__main__":
    from config import NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD, NEO4J_DATABASE
    
    kg = QiMaiKnowledgeGraph(NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD, NEO4J_DATABASE)
    
    # 1. 创建约束
    kg.create_constraint()
    
    # 2. 创建索引
    kg.create_indexes()
    
    # 3. 导入数据（假设CSV文件已准备好）
    # kg.import_herbs("data/herbs.csv")
    # kg.import_formulas("data/formulas.csv")
    # kg.import_formula_herb_relations("data/formula_herb.csv")
    # kg.import_patients("data/patients.csv")
    # kg.import_cases("data/cases.csv")
    
    kg.close()
    print("✅ 知识图谱构建完成")
```

### 5.4 数据导出脚本（从Markdown到CSV）

```python
# extract_data.py
"""
从Markdown文档中提取结构化数据，导出为CSV供Neo4j导入
"""

import re
import pandas as pd
from pathlib import Path

def extract_herbs_from_database(md_file):
    """从554味药数据库提取中药数据"""
    herbs = []
    
    with open(md_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 匹配中药条目
    pattern = r'【(\d+)\s+(.+?)】\n\s+性味：(.+?)\n\s+归经：(.+?)\n\s+核心功效：(.+?)\n\s+五维维度：(.+?)\n\s+54牌对应：(.+?)\n\s+适用脉级：(.+?)\n\s+适用场景：(.+?)\n\s+配伍示例：(.+?)\n\s+禁忌：(.+?)\n\s+剂量参考：(.+?)'
    
    matches = re.findall(pattern, content, re.DOTALL)
    
    for match in matches:
        herb_id, name, nature, meridians, efficacy, dimensions, card, level, scenario, examples, contraindications, dosage = match
        herbs.append({
            'id': f'HERB-{herb_id.zfill(3)}',
            'name': name.strip(),
            'nature': nature.strip(),
            'meridians': meridians.strip(),
            'efficacy': efficacy.strip(),
            'five_dimensions': dimensions.strip(),
            'card': card.strip(),
            'level': level.strip(),
            'source': '554味数据库V2.0'
        })
    
    return pd.DataFrame(herbs)

def extract_formulas_from_database(md_file):
    """从国医大师数据库提取方剂数据"""
    formulas = []
    
    with open(md_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 匹配方剂条目
    pattern = r'【方(\d+)】(.+?)\n\n```\n【组成】\n(.+?)\n\n【功效】(.+?)\n\n【主治】(.+?)\n\n【五维映射】\n(.+?)\n\n【加减】\n(.+?)\n\n【使用注意】\n(.+?)\n```'
    
    # 简化匹配（实际需要更复杂的解析）
    # 这里仅作示例
    
    return pd.DataFrame(formulas)

# 使用示例
if __name__ == "__main__":
    # 提取中药数据
    herbs_df = extract_herbs_from_database("理论知识/命功医学体系/554味常用药五维归经数据库_V2.0.md")
    herbs_df.to_csv("data/herbs.csv", index=False)
    print(f"✅ 提取 {len(herbs_df)} 个中药")
    
    # 提取方剂数据
    formulas_df = extract_formulas_from_database("理论知识/命功医学体系/国医大师经验方数据库_V1.0.md")
    formulas_df.to_csv("data/formulas.csv", index=False)
    print(f"✅ 提取 {len(formulas_df)} 个方剂")
```

---

## 六、部署指南

### 6.1 Neo4j安装

```bash
# Docker方式（推荐）
docker run -d \
  --name qimai-neo4j \
  -p 7474:7474 -p 7687:7687 \
  -v $PWD/neo4j/data:/data \
  -v $PWD/neo4j/logs:/logs \
  -v $PWD/neo4j/import:/var/lib/neo4j/import \
  -e NEO4J_AUTH=neo4j/your_password \
  neo4j:5.13.0

# 访问 http://localhost:7474
```

### 6.2 数据库初始化

```cypher
// 创建数据库（Neo4j 4.0+ Enterprise Edition）
CREATE DATABASE qimai IF NOT EXISTS;

// 切换到qimai数据库
:use qimai;

// 创建约束
CREATE CONSTRAINT patient_id FOR (p:Patient) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT herb_id FOR (h:Herb) REQUIRE h.id IS UNIQUE;
CREATE CONSTRAINT formula_id FOR (f:Formula) REQUIRE f.id IS UNIQUE;

// 创建索引
CREATE INDEX herb_name FOR (h:Herb) ON (h.name);
CREATE INDEX formula_name FOR (f:Formula) ON (f.name);
CREATE INDEX disease_name FOR (d:Disease) ON (d.name);
```

### 6.3 性能优化

```cypher
// 内存配置（neo4j.conf）
dbms.memory.heap.initial_size=2G
dbms.memory.heap.max_size=4G
dbms.memory.pagecache.size=4G

// 查询优化
// 使用EXPLAIN分析查询计划
EXPLAIN MATCH (p:Patient)-[:HAS_DIAGNOSIS]->(d:Diagnosis)
WHERE d.qi_level >= 8
RETURN p.name;

// 使用PROFILE查看实际执行
PROFILE MATCH (f:Formula)-[:CONTAINS]->(h:Herb)
WHERE h.name = "黄芪"
RETURN f.name;
```

---

## 七、使用场景

### 7.1 临床决策支持

```cypher
// 场景：新患者症状输入，推荐五维诊断
MATCH (s:Symptom)
WHERE s.name IN ["口苦", "易怒", "失眠", "甲状腺肿大"]
MATCH (s)-[:MAPS_TO]->(d:Dimension)
WITH d, count(*) as symptom_count, collect(s.name) as symptoms
RETURN d.name, d.description, symptom_count, symptoms
ORDER BY symptom_count DESC;

// 场景：根据五维缺口推荐方剂
MATCH (d:Dimension)
WHERE d.name IN ["炁维", "毒维", "脉维"]
MATCH (f:Formula)-[:TARGETS]->(d)
WHERE d.name = "炁维" AND d.level >= 6
WITH f, count(*) as dimension_match
ORDER BY dimension_match DESC
RETURN f.name, f.master, f.efficacy, dimension_match
LIMIT 5;
```

### 7.2 研究分析

```cypher
// 场景：某大师的用药网络分析
MATCH (m:Master {name: "朱良春"})-[:CREATED]->(f:Formula)
MATCH (f)-[:CONTAINS]->(h:Herb)
WITH h, count(*) as frequency
ORDER BY frequency DESC
LIMIT 20
RETURN h.name, h.category, frequency;

// 场景：疾病-症状-药物关联挖掘
MATCH (d:Disease {name: "糖尿病"})-[:HAS_SYMPTOM]->(s:Symptom)
MATCH (s)<-[:HAS_SYMPTOM]-(p:Patient)
MATCH (p)-[:RECEIVES]->(t:Treatment)
MATCH (t)-[:USES_HERB]->(h:Herb)
WITH h, count(*) as frequency
ORDER BY frequency DESC
LIMIT 10
RETURN h.name, frequency;
```

### 7.3 教学演示

```cypher
// 场景：展示某案例的完整治疗路径
MATCH path = (p:Patient {id: "PT-1945-2026-035"})-[:HAS_SYMPTOM]->(s:Symptom)
              -[:INDICATES]->(d:Disease)<-[:TREATS]-(f:Formula)
              -[:CONTAINS]->(h:Herb)-[:TARGETS]->(dim:Dimension)
RETURN path;

// 场景：对比两位大师的用药差异
MATCH (m1:Master {name: "朱良春"})-[:CREATED]->(f1:Formula)
MATCH (f1)-[:CONTAINS]->(h:Herb)
WITH m1, collect(DISTINCT h.name) as zhu_herbs

MATCH (m2:Master {name: "邓铁涛"})-[:CREATED]->(f2:Formula)
MATCH (f2)-[:CONTAINS]->(h:Herb)
WITH m2, collect(DISTINCT h.name) as deng_herbs, zhu_herbs

RETURN 
  zhu_herbs as 朱良春常用药,
  deng_herbs as 邓铁涛常用药,
  [x IN zhu_herbs WHERE x IN deng_herbs] as 共同用药;
```

---

## 八、维护与扩展

### 8.1 数据更新策略

```
【增量更新流程】

1. 新案例生成
   - 病案生成后自动提取结构化数据
   - 导出为CSV格式

2. 数据验证
   - 检查数据完整性
   - 验证关系一致性

3. 批量导入
   - 使用Neo4j Bulk Import工具
   - 或使用Python脚本逐条导入

4. 索引更新
   - 更新统计信息
   - 重建索引（如需要）

5. 备份
   - 定期备份数据库
   - 导出为Cypher脚本
```

### 8.2 扩展计划

| 阶段 | 内容 | 时间节点 |
|------|------|---------|
| V1.0 | 基础Schema + 554味药 + 18个方剂 | 2026-05 |
| V1.1 | 添加525个案例 + 症状网络 | 2026-06 |
| V1.2 | 添加检测指标 + 指南关联 | 2026-07 |
| V2.0 | 图神经网络(GNN)推理 | 2026-Q3 |
| V2.1 | 实时查询API | 2026-Q4 |

---

## 九、附录

### 9.1 数据字典

| 实体 | 属性 | 类型 | 说明 |
|------|------|------|------|
| Patient | id | String | 档案编号PT-XXXX |
| Patient | age | Integer | 年龄 |
| Herb | dosage_min | Integer | 最小剂量(g) |
| Herb | five_dimensions | List | 五维映射数组 |
| Formula | indications | List | 主治疾病数组 |
| Diagnosis | qi_level | Integer | 炁维级别1-10 |

### 9.2 相关文件

| 文件 | 路径 | 用途 |
|------|------|------|
| 554味药数据库 | 理论知识/命功医学体系/554味常用药五维归经数据库_V2.0.md | 中药节点数据源 |
| 国医大师数据库 | 理论知识/命功医学体系/国医大师经验方数据库_V1.0.md | 方剂节点数据源 |
| 方剂协同库 | 理论知识/命功医学体系/方剂协同机制解析库_V1.0.md | 关系数据源 |
| 病案库 | 病案库/ | 案例节点数据源 |

---

**最后更新**：2026年5月7日
**创建者**：灵觉/Prome
**状态**：🟡 Schema设计完成，待技术资源到位后部署
**下一步**：
1. 准备Neo4j环境
2. 从Markdown提取结构化数据
3. 执行数据导入
4. 验证查询功能