import 'package:flutter/material.dart';
import 'package:memorize/models/graph_data.dart';
import 'package:memorize/modules/cards_page.dart';
import 'package:memorize/modules/details.dart';
import 'package:memorize/modules/error_page.dart';
import 'package:memorize/modules/new_memory.dart';
import 'package:memorize/modules/progress_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memorize/routing/app_state.dart';

import 'models/memory_adapter.dart';
import 'modules/homepage.dart';
import 'modules/loading_page.dart';
import 'modules/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    //initializing the phone
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Navigation();
        }

        return LoadingPage();
      },
    );
  }
}

AppState theAppState = AppState();

class Navigation extends StatefulWidget {
  AppState _appState = theAppState;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._appState.addListener(() {
      setState(() {});
    });
    return MaterialApp(
        title: 'Memorize',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget._appState.currentUser != null
            ? Scaffold(
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: isHomePage
                    ? Container(
                        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            widget._appState.newMemoryAdapter = true;
                          },
                        ),
                      )
                    : null,
                endDrawer: Drawer(),
                appBar: AppBar(
                  title: Text('Memorize'),
                  leading: !isHomePage
                      ? IconButton(
                          onPressed: () {
                            widget._appState.managePop();
                          },
                          icon: Icon(Icons.arrow_back),
                        )
                      : null,
                ),
                body: Navigator(
                  onPopPage: (route, result) {
                    if (widget._appState.memory != null) {
                      widget._appState.memory = null;
                      return true;
                    }
                    return true;
                  },
                  pages: [
                    MaterialPage(
                        key: ValueKey('HomePage'),
                        child: SafeArea(
                            child: HomePage(
                          appState: widget._appState,
                        ))),
                    if (widget._appState.memoryAdapter != null)
                      MaterialPage(
                        key: ValueKey('DetailsPage'),
                        child: DetailPage(
                          appState: widget._appState,
                        ),
                      ),
                    if (widget._appState.newMemoryAdapter)
                      MaterialPage(
                          key: ValueKey('NewMemory'),
                          child: NewMemoryPage(
                            appState: widget._appState,
                          )),
                    if (widget._appState.memory != null)
                      MaterialPage(
                        key: ValueKey('CardsPage'),
                        child: CardsPage(
                          appState: widget._appState,
                        ),
                      ),
                    if (widget._appState.graphData != null)
                      MaterialPage(
                        key: ValueKey('ProgressPage'),
                        child: ProgressPage(appState: widget._appState),
                      )
                  ],
                ),
              )
            : LoginPage(
                appState: widget._appState,
              ));
  }

  bool get isHomePage => widget._appState.memoryAdapter == null && !widget._appState.newMemoryAdapter;

  void displayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Memory Collection'),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: Text("Add excel File")),
                TextButton(
                  onPressed: () {},
                  child: Text('Add manual entries'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
