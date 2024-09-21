import 'package:flutter/material.dart';

class GoClock extends StatelessWidget {
  const GoClock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [


                Expanded(
                  flex: 3,
                  child: Transform.rotate(angle: 3.14,
                  child: Stack(children: [
                    Material(
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {},
                        child: Column(children: [
                          SizedBox(height: 20),
                          Row( children: [
                            SizedBox(width: 25),
                            Text(
                              'Ход: 1',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            SizedBox(width: 80),
                            Text(
                              '3x(00:30)',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ]),
                          SizedBox(height: 80),
                          Center(
                            child: Text(
                              '20:00:00',
                              style: TextStyle(
                                  fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 80),
                          Row(
                            children: [
                              SizedBox(width: 30,),
                              Text('Период: ',style: TextStyle(color: Colors.white,fontSize: 25),),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ]
                  ),
                ),
                ),
                Container(
                  color: Colors.black,
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.pause_circle,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(children: [
                    Material(
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {},
                        child: Column(children: [
                          SizedBox(height: 20),
                          Row( children: [
                            SizedBox(width: 25),
                            Text(
                              'Ход: 1',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            SizedBox(width: 80),
                            Text(
                              '3x(00:30)',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ]),
                          SizedBox(height: 80),
                          Center(
                            child: Text(
                              '20:00:00',
                              style: TextStyle(
                                  fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 80),
                          Row(
                            children: [
                              SizedBox(width: 30,),
                              Text('Период: ',style: TextStyle(color: Colors.white,fontSize: 25),),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                              Icon(Icons.circle,color: Colors.white,size: 20,),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
