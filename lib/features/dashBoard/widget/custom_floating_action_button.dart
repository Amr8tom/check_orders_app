import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../auth/select_branch_screen/provider/auth_provider.dart";

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      child: Icon(Icons.remove_circle),
      onPressed: () async {
        Provider.of<AuthProvider>(context, listen: false).logOutFromScreen();
      },
    );
  }
}
