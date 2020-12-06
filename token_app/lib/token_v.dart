import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:token_app/token_vm.dart';

class Token_V extends StatefulWidget {
  @override
  _Token_VState createState() => _Token_VState();
}

class _Token_VState extends State<Token_V> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                  // if (model.isBusy)
                  //   Container(
                  //     height: height,
                  //     width: width,
                  //     child: Opacity(
                  //       opacity: 0.5,
                  //       child: Center(
                  //         child: CircularProgressIndicator(),
                  //       ),
                  //     ),
                  //   ),
                  ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                        ),
                        controller: usernameController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        controller: passwordController,
                        obscureText: true,
                      ),
                      RaisedButton(
                        child: Text("Submit"),
                        onPressed: () async {
                          String error = await model.login(
                              usernameController.text, passwordController.text);
                          if (error != "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(error),
                            ));
                          }
                        },
                      ),
                      if (model.token != null)
                        Text("Token Received: ${model.token}"),
                      if (model.resources != null)
                        ...model.resources
                            .map(
                              (String res) => RaisedButton(
                                onPressed: () {
                                  model.fetchResource(res);
                                },
                                child: Text(res),
                              ),
                            )
                            .toList(),
                      if (model.res != null) model.res
                    ],
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
