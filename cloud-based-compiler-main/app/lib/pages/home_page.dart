import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //String? _output = '';
  //final SyntaxHighlighterStyle _style = SyntaxHighlighterStyle.lightThemeStyle();

  final user = FirebaseAuth.instance.currentUser!;

  bool isNewFile = true;

  final TextEditingController _codeController = TextEditingController();

  final TextEditingController _inputController = TextEditingController();

  String? _language = 'py';

  final List<String> _languages = ['py', 'c', 'cpp'];
  final TextEditingController _outputController = TextEditingController();

  List<String> _fileNames = [];
  String? _selectedFileName;

  @override
  void dispose() {
    _codeController.dispose();
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _fetchFileNames() async {
    print("hhhhahdawdjkbawdjddddddddddddddddddddddddddddddddddddddddddd");
    String email = user.email!;
    String url = 'http://20.193.147.179:5000/files';
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded'
    };
    String data = 'userId=$email';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: data);

    setState(() {
      List<dynamic> files = json.decode(response.body)['files'];
      _fileNames = files.cast<String>();
    });
  }

  void _selectFile(String fileName) async {
    String email = user.email!;
    String url = 'http://20.193.147.179:5000/fetchcontent';
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded'
    };
    String data = 'userId=$email&fileName=$fileName';
    _selectedFileName = fileName;
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: data);

    if (response.statusCode == 200) {
      String content = json.decode(response.body)['content'];
      // print(content);
     
      setState(() {
        _codeController.text = content;
        _selectedFileName = fileName;
        isNewFile = false;
      });
    } else {
      // Handle error
      print('Failed to fetch file content: ${response.body}');
    }
  }

  void _clearCodeField() {
    setState(() {
      print("kys");
      _selectedFileName = null;
      isNewFile = true;
      _codeController.text = '';
      isNewFile = true; 
    });
  }

  void _deleteFile(String fileName) async {
    String email = user.email!;
    String url = 'http://20.193.147.179:5000/delete';
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded'
    };
    String data = 'userId=$email&fileName=$fileName';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: data);

    if (response.statusCode == 200) {
      // File deleted successfully, fetch updated file list
      _fetchFileNames();
    }
  }

  void _renameFile(String fileName) async {
    // Show dialog to enter new file name
    String? newFileName = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _textEditingController = TextEditingController();
        return AlertDialog(
          title: Text('Rename File'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: 'New File Name',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = user.email!;
                String url = 'http://20.193.147.179:5000/rename';
                Map<String, String> headers = {
                  'Content-type': 'application/x-www-form-urlencoded'
                };
                String data =
                    'userId=$email&fileName=$fileName&newFileName=${_textEditingController.text}';
                http.Response response = await http.post(Uri.parse(url),
                    headers: headers, body: data);

                if (response.statusCode == 200) {
                  // File renamed successfully, fetch updated file list
                  _fetchFileNames();
                  Navigator.pop(context, _textEditingController.text);
                }
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );

    if (newFileName != null && newFileName.isNotEmpty) {
     
      if (_selectedFileName == fileName) {
        _selectedFileName = newFileName;
      }
    }
  }

  void _clearSelectedFile() {
    setState(() {});
  }

  String _getAppBarTitle() {
    if (isNewFile) {
      return 'New File';
    } else if (_selectedFileName != null) {
      return _selectedFileName!;
    } else {
      return 'Editor';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFileNames();
  }

  void _clearOutput() {
    _outputController.clear();
  }

  Future<void> _compile() async {
    String email = user.email!;
    String code = Uri.encodeQueryComponent(_codeController.text);
    String inputValues = _inputController.text;

    if (_selectedFileName == null) {
     
      String? fileName = await showDialog(
        context: context,
        builder: (context) {
          TextEditingController _textEditingController =
              TextEditingController();
          return AlertDialog(
            title: Text('Enter File Name'),
            content: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'File Name',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _textEditingController.text);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );

      if (fileName != null && fileName.isNotEmpty) {
        _selectedFileName =
            '$fileName.$_language'; // Append the language extension
      } else {
        
        return;
      }
    }

    String url = 'http://20.193.147.179:5000/compile';
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded'
    };
    String data =
        'userId=$email&lang=$_language&code=$code&input_values=$inputValues&fileName=$_selectedFileName';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: data);

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (responseBody.containsKey('output')) {
      setState(() {
        _outputController.text = responseBody['output'];
      });
    } else {
      setState(() {
        _outputController.text = 'Error: Output not found';
      });
    }
  }

  void _openDrawer() {
    setState(() {});
  }

  void _closeDrawer() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue, // Set primary color
        hintColor: Color.fromRGBO(210, 168, 255, 1.0), // Set accent color
        textTheme: TextTheme(
          // Customize text styles
          headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 16),
        ),
      ),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(13, 17, 23, 1.0),
            appBar: AppBar(
              title: Text(_getAppBarTitle()), // Update app bar title
              actions: [
                IconButton(
                  onPressed: _clearCodeField, // Clear selected file
                  icon: Icon(Icons.file_copy), // New File button
                  tooltip: 'New File',
                ),
                IconButton(
                  onPressed: signUserOut,
                  icon: Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
              ],
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    color: Color.fromRGBO(42, 45, 50, 1),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _fileNames.length,
                      itemBuilder: (context, index) {
                        String fileName = _fileNames[index];
                        return ListTile(
                          title: Text(fileName),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('File Options'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteFile(fileName);
                                      },
                                      child: Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _renameFile(fileName);
                                      },
                                      child: Text('Rename'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            _selectFile(fileName);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Code',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input Values',
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _language,
                  onChanged: (String? value) {
                    setState(() {
                      _language = value;
                    });
                  },
                  items:
                      _languages.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: _compile,
                  child: Text('Compile'),
                ),
                if (_outputController.text != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: _outputController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Output',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: _clearOutput,
                          )),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
