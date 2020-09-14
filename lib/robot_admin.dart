import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RobotAdmin extends StatefulWidget {
  RobotAdmin({Key key}) : super(key: key);

  RobotAdminState createState() => RobotAdminState();
}

class RobotAdminState extends State<RobotAdmin> {
  var isSelectedInscription = [false, true, false];
  var isSelectedJury = [false, true, false];
  var isSelectedChallonge = [false, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            floating: true,
            pinned: true,
            // Display a placeholder widget to visualize the shrinking size.
            flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
              "assets/kit-sumobot.jpg",
              fit: BoxFit.cover,
            )),
            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 400,
          ),
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                  ),
                  Text(
                    "Robot 1",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    "de Louis DESPLANCHE",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Avancement",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Container(height: 20),
                        Row(
                          children: [
                            ToggleButtons(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Icon(Icons.check),
                                Icon(Icons.cancel),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  for (int buttonIndex = 0;
                                      buttonIndex <
                                          isSelectedInscription.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelectedInscription[index] = true;
                                    } else {
                                      isSelectedInscription[buttonIndex] =
                                          false;
                                    }
                                  }
                                });
                              },
                              isSelected: isSelectedInscription,
                            ),
                            Container(width: 10),
                            Text("Validation de l'inscription")
                          ],
                        ),
                        Container(height: 20),
                        Row(
                          children: [
                            ToggleButtons(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Icon(Icons.check),
                                Icon(Icons.cancel),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  for (int buttonIndex = 0;
                                      buttonIndex < isSelectedJury.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelectedJury[index] = true;
                                    } else {
                                      isSelectedJury[buttonIndex] = false;
                                    }
                                  }
                                });
                              },
                              isSelected: isSelectedJury,
                            ),
                            Container(width: 10),
                            Text("Validation par le jury")
                          ],
                        ),
                        Container(height: 20),
                        Row(
                          children: [
                            ToggleButtons(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Icon(Icons.check),
                                Icon(Icons.cancel),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  for (int buttonIndex = 0;
                                      buttonIndex < isSelectedChallonge.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelectedChallonge[index] = true;
                                    } else {
                                      isSelectedChallonge[buttonIndex] = false;
                                    }
                                  }
                                });
                              },
                              isSelected: isSelectedChallonge,
                            ),
                            Container(width: 10),
                            Text("Validation challonge")
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      child: Text("Supprimer le robot"),
                      textColor: Colors.white,
                      onPressed: () {
                        /*...*/
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
