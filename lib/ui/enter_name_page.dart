import 'package:discourse/models/app_state.dart';
import 'package:discourse/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterNamePage extends StatelessWidget {
  void _submit(BuildContext context) {
    if (context.read<AppState>().name?.isNotEmpty ?? false) {
      Navigator.of(context).pushNamed('/pick-position');
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your name!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What\'s your name?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
                child: EnterNameField(onSubmit: () => _submit(context)),
              ),
              CustomButton(
                text: 'Continue',
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnterNameField extends StatelessWidget {
  final void Function() onSubmit;

  EnterNameField({this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: context.watch<AppState>().name),
      onChanged: (query) => context.read<AppState>().saveName(query),
      onEditingComplete: onSubmit ?? () {},
      onSubmitted: (_) => (onSubmit ?? () {})(),
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.orange,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: 'Enter your name',
        hintStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.all(20),
        border: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 4),
        ),
      ),
    );
  }
}
