import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:pet_app/theme/color.dart';

import '../utils/http.dart'; // 导入颜色选择器包

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
  List pets = [];

  // 当前选中的宠物
  Map<String, dynamic>? selectedPet;

  int selectedPetIndex = 0;

  // 记录的事件
  List<PetEvent> _eventRecords = [];

  // 备忘录内容
  List<String> _notes = [];

  // 初始化日期格式
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await HttpService().get("/api/user_pet/list");
      print(response.data['data']['list']);
      setState(() {
        pets = response.data['data']['list'];
        if(pets.isNotEmpty){
          selectedPet = pets[0];
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
        if(pets.isNotEmpty){
          selectedPet = pets[0];
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

  Future<void> addData(pet) async {
    try {
      print(pet);
      final response = await HttpService().post("/api/user_pet/create", data: pet);
      if(response.data['code'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('添加成功！')),
        );
        updateData();
      }else{
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
                child: pets.isEmpty ? null: _buildPetSelection(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.add_box,color: AppColor.secondary,),
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
    return Container(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<Map<String, dynamic>>(
            hint: Text("选择宠物"),
            value: selectedPet,
            onChanged: (Map<String, dynamic>? newPet) {
              setState(() {
                selectedPet = newPet;
                selectedPetIndex = pets.indexOf(newPet!);
              });
            },
            items: pets.map((pet) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: pet,
                child: Text(pet['pet_name']),
              );
            }).toList(),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("宠物信息",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("名字: ${selectedPet?['pet_name']}", style: TextStyle(fontSize: 16)),
          Text("种类: ${selectedPet?['pet_type']}", style: TextStyle(fontSize: 16)),
          Text("性别: ${selectedPet?['pet_sex']}", style: TextStyle(fontSize: 16)),
          Text("生日: ${selectedPet?['pet_birthday']}",
              style: TextStyle(fontSize: 16)),
          Text("迎接家庭的日子: ${selectedPet?['pet_comeday']}",
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
          Text("您还没有宠物，请添加宠物噢^_^",style: TextStyle(
        color: AppColor.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w600
      )),
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
                          _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
                          _adoptDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
                                        Navigator.of(context).pop(_selectedColor);
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
                        child: Text("选择颜色", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
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
