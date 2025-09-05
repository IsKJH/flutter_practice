import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;
  int _curruentBottomSheetMenuIndex = 0;
  List<String> _bottomSheetMenu = ["Top", "Quiz", "Categories", "Friends"];

  IconData getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Icons.wb_sunny_outlined;
      case 'clouds':
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white, fontSize: 16),
          child: Center(
            child: Container(
              color: Colors.lightBlue.shade400,
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 30,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                getWeatherIcon("clear"),
                                color: Colors.white,
                              ),
                              Text("오늘도 목표를 향해 한 걸음 더!"),
                            ],
                          ),
                          Text(
                            "개발뉴비 김햄찌",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightBlue.shade300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text("SPOON LAB QUIZ"),
                            Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.headphones,
                                ),
                                Text(
                                  "내용을 입력",
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlue.shade300),
                      child: Column(
                        children: [Text("내용을 입력")],
                      )),
                  Container(
                      width: double.infinity,
                      height: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlue.shade300),
                      child: Column(
                        children: [Text("내용을 입력")],
                      )),
                  Container(
                      width: double.infinity,
                      height: 300,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlue.shade200),
                      child: Column(
                        children: [Text("내용을 입력")],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (BuildContext context, ScrollController scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _isExpanded = notification.extent > 0.6;
              });
              return false;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 50,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  if (_isExpanded) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _bottomSheetMenu.asMap().entries.map((entry) {
                        int index = entry.key;
                        String menuItem = entry.value;
                        bool isSelected =
                            index == _curruentBottomSheetMenuIndex;

                        return TextButton(
                          onPressed: () {
                            setState(() {
                              _curruentBottomSheetMenuIndex = index;
                            });
                          },
                          child: Text(
                            menuItem,
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Column(
                          spacing: 10,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Live Quizzes",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                    onPressed: () {}, child: Text("전체 보기"))
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                leading: CircleAvatar(),
                                trailing: Icon(Icons.chevron_right),
                                title: Text("내용을 입력해주세요"),
                                subtitle: Text("vue js · 12 Quizzes",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                leading: CircleAvatar(),
                                trailing: Icon(Icons.chevron_right),
                                title: Text("자바스크립트 첫걸음"),
                                subtitle: Text("JavaSCript · 10 Quizzes",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          spacing: 10,
                          children: [
                            Row(
                              children: [
                                Text("Friends",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ListTile(
                              leading: CircleAvatar(),
                              title: Text("아기참새도화가야",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("325 points",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            ListTile(
                              leading: CircleAvatar(),
                              title: Text("엄근진오리",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("124 points",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            ListTile(
                              leading: CircleAvatar(),
                              title: Text("어떤과학의초전자오리",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("437 points",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ]);
  }
}
