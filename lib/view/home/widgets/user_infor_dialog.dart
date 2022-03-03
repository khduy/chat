import '../../../common_widgets/avatar.dart';
import '../../../model/user_model.dart';
import 'package:flutter/material.dart';

class InforDialog extends StatelessWidget {
  const InforDialog({
    Key? key,
    required this.user,
    required this.onSignOut,
  }) : super(key: key);

  final UserModel user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          color: theme.primaryColor,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 50 + 16,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: const EdgeInsets.only(top: 50),
                color: theme.backgroundColor,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text('@' + user.userName),
                    const SizedBox(height: 16),
                    Material(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? Colors.black12
                                : Colors.white12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Sign out',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          onSignOut();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Avatar(
                photoURL: user.photoUrl,
                radius: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
