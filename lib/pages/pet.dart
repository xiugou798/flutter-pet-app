import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'package:flex_color_picker/flex_color_picker.dart'; // 导入颜色选择器包

class PetPage extends StatefulWidget {
  @override
  _PetPageState createState() => _PetPageState();
}

// 事件记录类
class PetEvent {
  final String event;
  final double value;
  final DateTime date;

  PetEvent({required this.event, required this.value, required this.date});
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
  List<Map<String, dynamic>> pets = [];

  // 当前选中的宠物
  Map<String, dynamic>? selectedPet;

  // 记录的事件
  List<PetEvent> _eventRecords = [];

  // 备忘录内容
  List<String> _notes = [];

  // 初始化日期格式
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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
    setState(() {
      pets.add({
        'name': _nameController.text,
        'breed': _breedController.text,
        'gender': _gender,
        'color': _selectedColor,
        'birthday': _birthdayController.text,
        'adoptDate': _adoptDateController.text,
        'events': [],
      });
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

  // 添加事件记录
  void _addEventRecord() {
    setState(() {
      _eventRecords.add(PetEvent(
        event: '体重',
        value: 4.5,
        date: DateTime.now(),
      ));
    });
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
      appBar: AppBar(title: Text("宠物管理")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 选择宠物
              _buildPetSelection(),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<Map<String, dynamic>>(
          hint: Text("选择宠物"),
          value: selectedPet,
          onChanged: (Map<String, dynamic>? newPet) {
            setState(() {
              selectedPet = newPet;
            });
          },
          items: pets.map((pet) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: pet,
              child: Text(pet['name']),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        if (selectedPet == null) ...[
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
                  setState(() {
                    _gender = value;
                  });
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
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            controller: _adoptDateController,
            decoration: InputDecoration(
              labelText: '迎接家庭的日子',
              hintText: 'yyyy-MM-dd',
            ),
            keyboardType: TextInputType.datetime,
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              Color? color = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('选择宠物颜色'),
                  content: ColorPicker(
                    color: _selectedColor,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.of(context).pop();
                    },
                    showColorCode: true,
                    colorCodeHasColor: true,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: _selectedColor,
              child: Text("选择颜色", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addPet,
            child: Text("添加宠物"),
          ),
        ],
      ],
    );
  }

  // 展示宠物基本信息（优化样式）
  Widget _buildPetInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("宠物信息",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("名字: ${selectedPet?['name']}", style: TextStyle(fontSize: 16)),
          Text("种类: ${selectedPet?['breed']}", style: TextStyle(fontSize: 16)),
          Text("性别: ${selectedPet?['gender']}", style: TextStyle(fontSize: 16)),
          Text("生日: ${selectedPet?['birthday']}",
              style: TextStyle(fontSize: 16)),
          Text("迎接家庭的日子: ${selectedPet?['adoptDate']}",
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 记录宠物事件/提醒
  Widget _buildEventSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("选择需要记录的宠物事件：",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        // 可选择的事件列表
        ...['体重', '体温', '散步时间', '药', '接种疫苗'].map((event) {
          return ListTile(
            title: Text(event),
            trailing: Icon(Icons.add),
            onTap: _addEventRecord,
          );
        }).toList(),
      ],
    );
  }

  // 事件图表展示
  Widget _buildEventChart() {
    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 10,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 20),
                FlSpot(2, 40),
                FlSpot(4, 60),
                FlSpot(6, 80),
                FlSpot(8, 100),
              ],
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

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
}
