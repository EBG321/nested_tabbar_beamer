import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const List myData = [
  {
    "id": "1",
    "name": "Kenedey",
    "icon": "video_collection_outlined",
    "social_media": "youtube",
    "joined": "1961",
    "friends": [
      {
        "id": "a",
        "maqa": "Eyob",
      },
      {
        "id": "b",
        "maqa": "sis",
      },
      {
        "id": "c",
        "maqa": "lyd",
      },
    ]
  },
  {
    "id": "2",
    "name": "Trump",
    "icon": "music_note_outlined",
    "social_media": "tiktok",
    "joined": "2016",
    "friends": [
      {
        "id": "d",
        "maqa": "Eyob",
      },
      {
        "id": "e",
        "maqa": "sis",
      },
      {
        "id": "f",
        "maqa": "lyd",
      },
    ]
  },
  {
    "id": "3",
    "name": "Biden",
    "icon": "message",
    "social_media": "twitter",
    "joined": "2020",
    "friends": [
      {
        "id": "g",
        "maqa": "Eyob",
      },
      {
        "id": "h",
        "maqa": "sis",
      },
      {
        "id": "i",
        "maqa": "lyd",
      },
    ]
  },
  {
    "id": "4",
    "name": "Obama",
    "icon": "facebook_rounded",
    "social_media": "facebook",
    "joined": "2020",
    "friends": [
      {
        "id": "j",
        "maqa": "Eyobo",
      },
      {
        "id": "k",
        "maqa": "siso",
      },
      {
        "id": "l",
        "maqa": "lydo",
      },
    ]
  },
];

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
      locationBuilder: (routeInformation) =>
          SocialMediaLocation(routeInformation));
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: routerDelegate),
    );
  }
}

class SocialMediaTabbedView extends StatefulWidget {
  final Map choosenTab;
  const SocialMediaTabbedView({Key? key, required this.choosenTab})
      : super(key: key);

  @override
  _SocialMediaTabbedViewState createState() => _SocialMediaTabbedViewState();
}

class _SocialMediaTabbedViewState extends State<SocialMediaTabbedView>
    with SingleTickerProviderStateMixin {
  late final _tabController;
  @override
  void initState() {
    super.initState();

    var initialIndex = 0;

    for (var index = 0; index < myData.length; index++) {
      if (widget.choosenTab["name"] == myData[index]["name"]) {
        initialIndex = index;
      }
    }
    _tabController = TabController(
        length: myData.length, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(_onTabChanges);
  }

  void _onTabChanges() {
    for (var index = 0; index < myData.length; index++) {
      if (_tabController.index == index) {
        Beamer.of(context).update(
          state:
              BeamState.fromUri(Uri.parse('/${myData[index]["social_media"]}')),
          rebuild: false,
        );
      }
    }
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myData.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBar(
            bottom: TabBar(
                indicatorColor: Colors.red,
                controller: _tabController,
                tabs: List.generate(
                    myData.length,
                    (index) => Tab(
                          icon: const Icon(Icons.subscriptions_outlined),
                          text: myData[index]["social_media"],
                        ))),
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: List.generate(
                myData.length,
                (index) => SocialMediaPage(
                      sendData: myData[index],
                      selectedTab: myData[index]["friends"][0],
                    ))),
      ),
    );
  }
}

class SocialMediaLocation extends BeamLocation<BeamState> {
  SocialMediaLocation(BeamState routeInformation) : super(routeInformation);

  @override
  List get pathBlueprints => [
        '/:socialId/:friendId',
      ];
  Map letsee = myData[1];
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    print("😂😂😂😂😂");

    return [
      BeamPage(
          key: ValueKey("Home"),
          child: SocialMediaTabbedView(choosenTab: myData[0])),
      if (state.pathParameters.containsKey("socialId"))
        BeamPage(
          key: const ValueKey("Internet"),
          title: myData.firstWhere((social) =>
              social["social_media"] ==
              state.pathParameters["socialId"])["social_media"],
          child: SocialMediaTabbedView(
              choosenTab: myData.firstWhere((social) =>
                  social["social_media"] == state.pathParameters["socialId"])),
        ),
      if (state.pathParameters.containsKey("friendId"))
        BeamPage(
            child: SocialMediaPage(
          sendData: myData.firstWhere((social) =>
              social["social_media"] == state.pathParameters["socialId"]),
          selectedTab: myData
              .firstWhere(
                (social) =>
                    social["social_media"] == state.pathParameters["socialId"],
              )["friends"]
              .firstWhere(
                  (friend) => friend["id"] == state.pathParameters["friendId"]),
        ))
    ];
  }
}

class SocialMediaPage extends StatefulWidget {
  final selectedTab;
  final sendData;

  const SocialMediaPage({Key? key, this.sendData, this.selectedTab})
      : super(key: key);

  @override
  State<SocialMediaPage> createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage>
    with SingleTickerProviderStateMixin {
  late final _tabController;
  @override
  void initState() {
    super.initState();

    var initialIndex = 0;
    for (var index = 0; index < widget.sendData["friends"].length; index++) {
      if (widget.sendData["friends"][index]["id"] == widget.selectedTab["id"]) {
        initialIndex = index;
      }
    }
    _tabController = TabController(
        length: widget.sendData["friends"].length,
        vsync: this,
        initialIndex: initialIndex);
    _tabController.addListener(_onTabChanges);
  }

  void _onTabChanges() {
    for (var index = 0; index < widget.sendData["friends"].length; index++) {
      if (_tabController.index == index) {
        print(
            "😂😂😂😂😂${widget.sendData["friends"][index]["id"]} ${widget.selectedTab["id"]}");
        Beamer.of(context).update(
          state: BeamState.fromUri(Uri.parse(
              '/${widget.sendData["social_media"]}/${widget.sendData["friends"][index]["id"]}')),
          rebuild: false,
        );
      }
    }
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.sendData["friends"].length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(74),
          child: AppBar(
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              tabs: List.generate(
                widget.sendData["friends"].length,
                (index) => Tab(
                  text: widget.sendData["friends"][index]["id"],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: List.generate(
            widget.sendData["friends"].length,
            (index) => Center(
              child: Text("${widget.sendData["friends"][index]["maqa"]}"),
            ),
          ),
        ),
      ),
    );
  }
}
