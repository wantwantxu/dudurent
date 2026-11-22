import '../models/models.dart';

AppData createSampleData() => AppData(properties: [
      Property(
        id: 0,
        name: '静安区花园洋房 2栋 501室',
        tenant: '张强',
        tenantPhone: '139-8888-1234',
        rent: 8500,
        daysRented: 420,
        totalYield: 119000,
        deposit: 17000,
        status: '在租中',
        badgeColor: 'emerald',
        meters: [
          MeterItem(name: '电费止数', val: 1480, unit: '度', color: 'amber'),
          MeterItem(name: '水费止数', val: 125, unit: '吨', color: 'cyan'),
          MeterItem(name: '天然气止数', val: 86, unit: '方', color: 'purple'),
          MeterItem(name: '地暖用量', val: 320, unit: '吉焦', color: 'pink'),
        ],
        repairs: [
          RepairItem(
            id: 101,
            item: '水龙头渗水',
            desc: '厨房主水龙头关不紧',
            status: '已完成维修',
            cost: '¥80',
          ),
        ],
        appliances: [
          ApplianceItem(
            name: '大金 3匹变频空调',
            status: '完好',
            photo: 'ac',
          ),
          ApplianceItem(
            name: '西门子 450L 冰箱',
            status: '完好',
            photo: 'fridge',
          ),
        ],
      ),
      Property(
        id: 1,
        name: '陆家嘴金融大厦 18栋 1802室',
        tenant: '李娜',
        tenantPhone: '137-6666-8888',
        rent: 12000,
        daysRented: 310,
        totalYield: 124000,
        deposit: 24000,
        status: '有报修',
        badgeColor: 'amber',
        meters: [
          MeterItem(name: '电费止数', val: 2100, unit: '度', color: 'amber'),
          MeterItem(name: '水费止数', val: 180, unit: '吨', color: 'cyan'),
          MeterItem(name: '天然气止数', val: 110, unit: '方', color: 'purple'),
        ],
        repairs: [
          RepairItem(
            id: 102,
            item: '主卧空调不制冷',
            desc: '开机显示 E4 故障代码',
            status: '管家派单中',
            cost: '待核算',
          ),
        ],
        appliances: [
          ApplianceItem(
            name: '卡萨帝双开门冰箱',
            status: '完好',
            photo: 'fridge2',
          ),
        ],
      ),
      Property(
        id: 2,
        name: '徐汇区品质二居 6栋 301室',
        tenant: '王伟',
        tenantPhone: '135-2222-3333',
        rent: 6200,
        daysRented: 230,
        totalYield: 47120,
        deposit: 12400,
        status: '在租中',
        badgeColor: 'emerald',
        meters: [
          MeterItem(name: '电费止数', val: 920, unit: '度', color: 'amber'),
          MeterItem(name: '水费止数', val: 95, unit: '吨', color: 'cyan'),
          MeterItem(name: '天然气止数', val: 54, unit: '方', color: 'purple'),
        ],
        repairs: [],
        appliances: [
          ApplianceItem(
            name: '海尔滚筒洗衣机',
            status: '完好',
            photo: 'washer',
          ),
        ],
      ),
    ]);
