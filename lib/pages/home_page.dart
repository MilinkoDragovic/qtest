import 'package:flutter/material.dart';
import 'package:q_test/api/api_provider.dart';
import 'package:q_test/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;
  int _page = 1;

  final int _limit = 20;
  var apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreFromApi();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q Test'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              right: 10.0,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildCommentsListView(),
    );
  }

  _loadMoreFromApi() async {
    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;

      final response = await apiProvider.fetchComments(_page, _limit);

      if (response.isEmpty) {
        setState(() {
          _hasNextPage = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await apiProvider.fetchComments(_page, _limit);

    setState(() {
      _isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      _isLoading = true;
    });

    await DBProvider.db.deleteAllComments();

    setState(() {
      _isLoading = false;
    });
  }

  _buildCommentsListView() {
    return RefreshIndicator(
      child: FutureBuilder(
        future: DBProvider.db.comments(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              controller: _scrollController,
              children: [
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: snapshot.data
                      .map<DataRow>(
                        (data) => DataRow(
                          cells: [
                            DataCell(Text(
                              data.id.toString(),
                            )),
                            DataCell(
                              Text(data.email),
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(data.name),
                                  content: Text(data.body),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Close'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),

                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all the comments.'),
                    ),
                  ),
              ],
            );
          }
        },
      ),
      onRefresh: () => _loadData(),
    );
  }
}
