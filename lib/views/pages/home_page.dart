import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talawa/controllers/activity_controller.dart';
import 'package:talawa/controllers/auth_controller.dart';
import 'package:talawa/model/activity.dart';
import 'package:talawa/utils/uidata.dart';
import 'package:talawa/views/widgets/common_drawer.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    Provider.of<AuthController>(context, listen: false).getUser();
    return Scaffold(
      appBar: new AppBar(
        title: Image(
          image: AssetImage(UIData.talawaLogoDark),
          height: 50,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: CommonDrawer(),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image(
              image: AssetImage(UIData.quitoBackground),
              fit: BoxFit.fill,
            ),
          ),
          activityList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(_context, UIData.addActivityPage);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget activityList() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Activities',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Consumer2<ActivityController, AuthController>(
            builder: (context, activityController, authController, child){
              return FutureBuilder<List<Activity>>(
              future: activityController.getActivitiesByUser(context, authController.currentUserId),
              builder: (_context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_context, index) {
                        Activity activity = snapshot.data[index];
                        return Column(
                          children: <Widget>[eventCard(activity)],
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text('No Activities',
                            style: TextStyle(color: Colors.grey)));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
            }
          )
        )
      ],
    );
  }

  Widget eventCard(Activity activity) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(_context, UIData.activityDetails,
              arguments: activity);
        },
        child: new Container(
          height: 135,
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        activity.title,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(DateFormat("MMMM d, y\nh:m aaa").format(activity.datetime),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                              activity.userCount > 9
                                  ? Text('+9',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0))
                                  : Text(activity.userCount.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0)),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
