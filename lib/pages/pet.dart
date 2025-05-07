import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:pet_app/theme/color.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/http.dart';

class PetPage extends StatefulWidget {
  @override
  _PetPageState createState() => _PetPageState();
}

// 事件记录类
class PetEvent {
  final String petName;
  final String event;
  final dynamic value; // double、Duration 或 String
  final DateTime date;

  PetEvent({
    required this.petName,
    required this.event,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'pet_name': petName,
        'event': event,
        'value': value is Duration
            ? (value as Duration).inMinutes
            : value.toString(),
        'date': date.toIso8601String(),
      };

  factory PetEvent.fromMap(Map<String, dynamic> m) {
    final valStr = m['value'] as String;
    dynamic val;
    if (m['event'] == '体重' || m['event'] == '体温') {
      val = double.tryParse(valStr) ?? 0.0;
    } else if (m['event'] == '散步时间') {
      val = Duration(minutes: int.tryParse(valStr) ?? 0);
    } else {
      val = valStr;
    }
    return PetEvent(
      petName: m['pet_name'] as String,
      event: m['event'] as String,
      value: val,
      date: DateTime.parse(m['date'] as String),
    );
  }
}

/// 单例数据库提供者
class DBProvider {
  DBProvider._();

  static final DBProvider instance = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // final path = join(await getDatabasesPath(), 'pet_events.db');
    _database = await openDatabase(
      'pet_events.db',
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE pet_events(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pet_name TEXT,
            event TEXT,
            value TEXT,
            date TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  Future<void> insertEvent(PetEvent e) async {
    final db = await database;
    await db.insert('pet_events', e.toMap());
  }

  Future<List<PetEvent>> getEventsByPet(String petName) async {
    final db = await database;
    final res = await db.query('pet_events',
        where: 'pet_name = ?', whereArgs: [petName], orderBy: 'date ASC');
    return res.map((m) => PetEvent.fromMap(m)).toList();
  }
}

class _PetPageState extends State<PetPage> {
  // 控制宠物信息输入
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _adoptDateController = TextEditingController();

  // 性别选择
  String? _gender;

  // 宠物颜色
  Color _selectedColor = Colors.black;

  // 存储宠物数据
  List pets = [];

  // 当前选中的宠物
  Map<String, dynamic>? selectedPet;

  // String? _currentPetName;
  String? _currentPetId;

  int selectedPetIndex = 0;

  // 记录的事件
  List<PetEvent> _eventRecords = [];

  // 备忘录内容
  List<String> _notes = [];

  // 用于记录当前图表展示的事件类型
  String? _chartEventType;

  // 初始化日期格式
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _loadEventRecords(); // 加载数据库中的事件
  }

  /// 从 SQLite 中读取所有事件记录
  Future<void> _loadEventRecords() async {
    if (_currentPetId == null) return;
    final events = await DBProvider.instance.getEventsByPet(_currentPetId!);
    setState(() {
      _eventRecords = events;
      _chartEventType = null;
    });
  }

  Future<void> getData() async {
    try {
      final response = await HttpService().get("/api/user_pet/list");
      print(response.data['data']['list']);
      setState(() {
        pets = response.data['data']['list'];
        if (pets.isNotEmpty) {
          selectedPet = pets[0];
          _currentPetId = pets[0]?['id'].toString();
        }
      });

      // var globalState = Provider.of<GlobalState>(context, listen: false);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('获取数据失败！')),
      );
    }
  }

  Future<void> updateData() async {
    try {
      final response = await HttpService().get("/api/user_pet/list");
      print(response.data['data']['list']);
      setState(() {
        pets = response.data['data']['list'];
        if (pets.isNotEmpty) {
          selectedPet = pets[0];
        }
      });

      // var globalState = Provider.of<GlobalState>(context, listen: false);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('更新数据失败！')),
      );
    }
  }

  Future<void> addData(pet) async {
    try {
      print(pet);
      final response =
          await HttpService().post("/api/user_pet/create", data: pet);
      if (response.data['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('添加成功！')),
        );
        updateData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('添加失败！')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('添加失败！')),
      );
    }
  }

  Future<void> updatePetData(pet) async {
    try {
      print(pet);
      final response =
          await HttpService().post("/api/user_pet/update", data: pet);
      print(response);
      if (response.data['code'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('修改成功！')),
        );
        // updateData();
        _loadEventRecords(); // 加载数据库中的事件
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('修改失败！')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('网络错误！')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _birthdayController.dispose();
    _adoptDateController.dispose();
    super.dispose();
  }

  // 添加宠物，包含校验
  void _addPet() {
    if (_nameController.text.isEmpty ||
        _breedController.text.isEmpty ||
        _gender == null ||
        _birthdayController.text.isEmpty ||
        _adoptDateController.text.isEmpty) {
      _showErrorDialog("所有字段都是必填项！");
      return;
    }

    addData({
      'pet_name': _nameController.text,
      'pet_type': _breedController.text,
      'pet_sex': _gender,
      'pet_color': "#" + _selectedColor.hex,
      'pet_birthday': _birthdayController.text,
      'pet_comeday': _adoptDateController.text,
      // 'events': [],
    });
    _nameController.clear();
    _breedController.clear();
    _birthdayController.clear();
    _adoptDateController.clear();
    setState(() {
      _gender = null;
      _selectedColor = Colors.black;
    });
  }

  // 显示错误提示框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("输入错误"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("确定"),
            ),
          ],
        );
      },
    );
  }

  // 弹出对话框记录任意类型的事件值
  Future<void> _addEventRecord(String eventType) async {
    if (_currentPetId == null) return;
    dynamic value;
    if (eventType == '散步时间') {
      final time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time == null) return;
      value = Duration(hours: time.hour, minutes: time.minute);
    } else if (eventType == '药' || eventType == '接种疫苗') {
      final ctrl = TextEditingController();
      final txt = await showDialog<String>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('输入 $eventType'),
          content: TextField(controller: ctrl),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(c, ctrl.text), child: Text('确定'))
          ],
        ),
      );
      if (txt == null || txt.isEmpty) return;
      value = txt;
    } else {
      final ctrl = TextEditingController();
      final num = await showDialog<double>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('记录 $eventType'),
          content: TextField(
              controller: ctrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(c, double.tryParse(ctrl.text)),
                child: Text('确定'))
          ],
        ),
      );
      if (num == null) return;
      value = num;
    }
    final now = DateTime.now();
    final e = PetEvent(
        petName: _currentPetId!, event: eventType, value: value, date: now);
    await DBProvider.instance.insertEvent(e);
    await _loadEventRecords();
    setState(() => _chartEventType = eventType);
  }

  // 添加备忘录
  void _addNote(String note) {
    setState(() {
      _notes.add(note);
    });
  }

  // 删除备忘录
  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          height: 60,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("宠物管理"),
              ),
              Align(
                alignment: Alignment.center,
                child: pets.isEmpty ? null : _buildPetSelection(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.add_box,
                    color: AppColor.secondary,
                  ),
                  onPressed: () {
                    _showAddPetDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (pets.isEmpty)
                // 没有宠物
                _buildNoPet()
              else
                SizedBox(height: 20),

              // 展示宠物基本信息
              if (selectedPet != null) _buildPetInfo(),

              SizedBox(height: 20),
              // 记录宠物事件
              if (selectedPet != null) _buildEventSelection(),

              SizedBox(height: 20),
              // 事件图表展示
              if (_eventRecords.isNotEmpty) _buildEventChart(),

              SizedBox(height: 20),
              // 备忘录
              _buildMemoSection(),
            ],
          ),
        ),
      ),
    );
  }

  // 宠物选择下拉框
  Widget _buildPetSelection() {
    return DropdownButton<Map<String, dynamic>>(
      hint: Text('选择宠物'),
      value: selectedPet,
      onChanged: (newPet) {
        setState(() {
          selectedPet = newPet;
          _currentPetId = newPet?['id'].toString();
        });
        _loadEventRecords();
      },
      items: pets.map((pet) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: pet,
          child: Text(pet['pet_name']),
        );
      }).toList(),
    );
  }

  Color parseColor(String colorCode) {
    String hex = colorCode.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // 添加不透明alpha值（若为6位）
    }
    return Color(int.parse(hex, radix: 16));
  }

  // 展示宠物基本信息（优化样式）
  Widget _buildPetInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: parseColor(selectedPet?['pet_color']),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          // 原有信息展示
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("宠物信息",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("名字: ${selectedPet?['pet_name']}",
                  style: TextStyle(fontSize: 16)),
              Text("种类: ${selectedPet?['pet_type']}",
                  style: TextStyle(fontSize: 16)),
              Text("性别: ${selectedPet?['pet_sex']}",
                  style: TextStyle(fontSize: 16)),
              Text("生日: ${selectedPet?['pet_birthday']}",
                  style: TextStyle(fontSize: 16)),
              Text("迎接家庭的日子: ${selectedPet?['pet_comeday']}",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          // 右上角编辑按钮
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppColor.primary),
                  onPressed: _showEditPetDialog,
                ),
                // TODO 删除弹窗
                IconButton(
                  icon: Icon(Icons.delete, color: AppColor.primary),
                  onPressed: _showDeletePetDialog,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }


// 2. 新增：弹窗编辑宠物信息
  void _showEditPetDialog() {
    // 先预填当前值
    _nameController.text = selectedPet?['pet_name'] ?? '';
    _breedController.text = selectedPet?['pet_type'] ?? '';
    _gender = selectedPet?['pet_sex'];
    _birthdayController.text = selectedPet?['pet_birthday'] ?? '';
    _adoptDateController.text = selectedPet?['pet_comeday'] ?? '';
    _selectedColor = parseColor(selectedPet?['pet_color'] ?? '#FF000000');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('编辑宠物信息'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '宠物名字'),
                    ),
                    TextField(
                      controller: _breedController,
                      decoration: InputDecoration(labelText: '宠物种类'),
                    ),
                    Row(
                      children: [
                        Text('性别: '),
                        Radio<String>(
                          value: 'Male',
                          groupValue: _gender,
                          onChanged: (v) {
                            setState(() => _gender = v);
                            setStateDialog(() {});
                          },
                        ),
                        Text('公'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (v) {
                            setState(() => _gender = v);
                            setStateDialog(() {});
                          },
                        ),
                        Text('母'),
                      ],
                    ),
                    // 生日选择
                    TextField(
                      controller: _birthdayController,
                      decoration: InputDecoration(labelText: '宠物生日'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? d = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.tryParse(_birthdayController.text) ??
                                  DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          _birthdayController.text = _dateFormat.format(d);
                          setStateDialog(() {});
                        }
                      },
                    ),
                    // 迎接日选择
                    TextField(
                      controller: _adoptDateController,
                      decoration: InputDecoration(labelText: '迎接家庭的日子'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? d = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.tryParse(_adoptDateController.text) ??
                                  DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          _adoptDateController.text = _dateFormat.format(d);
                          setStateDialog(() {});
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    // 颜色选择
                    GestureDetector(
                      onTap: () async {
                        Color? c = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('选择宠物颜色'),
                            content: ColorPicker(
                              color: _selectedColor,
                              onColorChanged: (col) {
                                setState(() => _selectedColor = col);
                                setStateDialog(() {});
                              },
                              showColorCode: true,
                              colorCodeHasColor: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, _selectedColor),
                                child: Text('确定'),
                              ),
                            ],
                          ),
                        );
                        if (c != null) {
                          setState(() => _selectedColor = c);
                          setStateDialog(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: _selectedColor,
                        child:
                            Text('选择颜色', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    // 更新本地选中数据并提交到服务器

                    setState(() {
                      selectedPet?['pet_name'] = _nameController.text;
                      selectedPet?['pet_type'] = _breedController.text;
                      selectedPet?['pet_sex'] = _gender;
                      selectedPet?['pet_birthday'] = _birthdayController.text;
                      selectedPet?['pet_comeday'] = _adoptDateController.text;
                      selectedPet?['pet_color'] = '#${_selectedColor.hex}';
                    });
                    updatePetData(selectedPet);
                    Navigator.of(context).pop();
                  },
                  child: Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // 删除宠物确认弹窗
  void _showDeletePetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除宠物 "${selectedPet?['pet_name']}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final petId = selectedPet?['id'];
              if (petId != null) {
                try {
                  final resp = await HttpService().post(
                    "/api/user_pet/delete",
                    data: {'id': petId},
                  );
                  if (resp.data['code'] == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('删除成功！')),
                    );
                    setState(() {
                      pets.clear();
                      getData();
                    });
                  } else {
                    // throw Exception('删除失败');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('删除失败，请重试')),
                  );
                }
              }
            },
            child: Text('删除', style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
  }

  // 事件选择列表传递事件类型参数
  Widget _buildEventSelection() {
    final events = ['体重', '体温', '散步时间', '药', '接种疫苗'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选择需要记录的宠物事件：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...events.map((event) {
          return ListTile(
            title: Text(event),
            // 点击条目查看历史
            onTap: () => _viewEventRecords(event),
            // 图标按钮区域
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 查看图表
                IconButton(
                  icon: Icon(Icons.show_chart),
                  onPressed: () {
                    setState(() {
                      _chartEventType = event;
                    });
                  },
                ),
                // 添加新记录
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addEventRecord(event),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // 查看某一事件类型的历史记录
  void _viewEventRecords(String eventType) {
    final list = _eventRecords.where((e) => e.event == eventType).toList();
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text('$eventType 历史'),
              content: Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: list.map((e) {
                    final v = e.value is Duration
                        ? '${(e.value as Duration).inHours}h ${(e.value as Duration).inMinutes % 60}m'
                        : e.value.toString();
                    return ListTile(
                      title: Text(v),
                      subtitle: Text(DateFormat('MM/dd HH:mm').format(e.date)),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c), child: Text('关闭'))
              ],
            ));
  }

  /// 修改：根据所选事件类型动态渲染折线图
  Widget _buildEventChart() {
    if (_chartEventType == null) return SizedBox.shrink();
    final list =
        _eventRecords.where((e) => e.event == _chartEventType).toList();
    if (list.isEmpty) return SizedBox.shrink();
    switch (_chartEventType) {
      case '体重':
      case '体温':
        final spots = list
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value as double))
            .toList();
        return _buildLineChart(spots);
      case '散步时间':
        final spots = list
            .asMap()
            .entries
            .map((e) => BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(
                      toY: (e.value.value as Duration).inMinutes.toDouble())
                ]))
            .toList();
        return _buildBarChart(spots);
      default:
        return _buildListChart(list);
    }
  }

  Widget _buildLineChart(List<FlSpot> spots) => Container(
      height: 200,
      child: LineChart(LineChartData(
        lineBarsData: [LineChartBarData(spots: spots, isCurved: true)],
        titlesData: FlTitlesData(show: true),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      )));

  Widget _buildBarChart(List<BarChartGroupData> groups) => Container(
      height: 200,
      child: BarChart(BarChartData(
        barGroups: groups,
        titlesData: FlTitlesData(show: true),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      )));

  Widget _buildListChart(List<PetEvent> list) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map((e) => ListTile(
                  title: Text(e.value.toString()),
                  subtitle: Text(DateFormat('MM/dd HH:mm').format(e.date)),
                ))
            .toList(),
      );

  // 备忘录部分
  Widget _buildMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("备忘录",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ..._notes.map((note) {
          return ListTile(
            title: Text(note),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                int index = _notes.indexOf(note);
                _deleteNote(index);
              },
            ),
          );
        }).toList(),
        TextField(
          decoration: InputDecoration(hintText: "添加新备忘录"),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _addNote(value);
            }
          },
        ),
        Container(
          height: 100,
        )
      ],
    );
  }

  Widget _buildNoPet() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 480,
      child: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Text("您还没有宠物，请添加宠物噢^_^",
              style: TextStyle(
                  color: AppColor.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "添加宠物",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              _showAddPetDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showAddPetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // 使用 StatefulBuilder 来更新弹窗内的状态
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '宠物名字'),
                    ),
                    TextField(
                      controller: _breedController,
                      decoration: InputDecoration(labelText: '宠物种类'),
                    ),
                    Row(
                      children: [
                        Text('性别: '),
                        Radio<String>(
                          value: 'Male',
                          groupValue: _gender,
                          onChanged: (value) {
                            // 更新父组件状态和弹窗内状态
                            setState(() {
                              _gender = value;
                            });
                            setStateDialog(() {});
                          },
                        ),
                        Text('公'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                            setStateDialog(() {});
                          },
                        ),
                        Text('母'),
                      ],
                    ),
                    TextField(
                      controller: _birthdayController,
                      decoration: InputDecoration(
                        labelText: '宠物生日',
                        hintText: 'yyyy-MM-dd',
                      ),
                      readOnly: true, // 禁止手动输入
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _birthdayController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                    TextField(
                      controller: _adoptDateController,
                      decoration: InputDecoration(
                        labelText: '迎接家庭的日子',
                        hintText: 'yyyy-MM-dd',
                      ),
                      readOnly: true, // 禁止手动输入
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _adoptDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        // 调用颜色选择器弹窗，并使用 StatefulBuilder 更新内部状态
                        Color? color = await showDialog(
                          context: context,
                          builder: (_) {
                            return StatefulBuilder(
                              builder: (context, setStateColor) {
                                return AlertDialog(
                                  title: Text('选择宠物颜色'),
                                  content: ColorPicker(
                                    color: _selectedColor,
                                    onColorChanged: (color) {
                                      setState(() {
                                        _selectedColor = color;
                                      });
                                      // 同时更新颜色弹窗的状态
                                      setStateColor(() {});
                                    },
                                    showColorCode: true,
                                    colorCodeHasColor: true,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(_selectedColor);
                                      },
                                      child: Text("确定"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                        if (color != null) {
                          setState(() {
                            _selectedColor = color;
                          });
                          setStateDialog(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: _selectedColor,
                        child:
                            Text("选择颜色", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _addPet();
                        Navigator.of(context).pop(); // 成功添加后关闭弹窗
                      },
                      child: Text("添加宠物"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
