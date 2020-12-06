import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:token_app/token_vm.dart';

class Token_V extends StatefulWidget {
  @override
  _Token_VState createState() => _Token_VState();
}

class _Token_VState extends State<Token_V> {
  TextEditingController usernameController =
      TextEditingController(text: "student");
  TextEditingController passwordController =
      TextEditingController(text: "projectINS");
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<Token_VM>.reactive(
      viewModelBuilder: () => Token_VM(),
      builder: (BuildContext context, Token_VM model, Widget child) {
        return Builder(
          builder: (context) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;

            return Scaffold(
              appBar: AppBar(
                title: Text("Auth 2.0"),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username",
                            ),
                            controller: usernameController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                            ),
                            controller: passwordController,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              String error = await model.login(
                                  usernameController.text,
                                  passwordController.text);
                              if (error != "") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(error),
                                ));
                              }
                            },
                          ),
                        ),
                        if (model.token != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Token Received: ${model.token}"),
                          ),
                        if (model.res != null) model.res,
                        if (model.resources != null)
                          ...model.resources
                              .map(
                                (String res) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      model.fetchResource(res);
                                    },
                                    child: Text(res),
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
