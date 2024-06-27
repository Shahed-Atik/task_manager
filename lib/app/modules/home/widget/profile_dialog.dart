import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_event.dart';
import 'package:task_manager/app/shared/models/profile.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.profile});
  final Profile profile;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
                titleTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary))),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context
                              .read<AppBloc>()
                              .add(const AppLogoutRequested());
                        },
                        icon: const Icon(Icons.logout)),
                  ),
                  Center(
                    child: CircleAvatar(
                      maxRadius: 70,
                      child: Image.network(profile.image),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("First Name"),
              subtitle: Text(profile.firstName),
            ),
            ListTile(
              title: const Text("Last Name"),
              subtitle: Text(profile.lastName),
            ),
            ListTile(
              title: const Text("Maiden Name"),
              subtitle: Text(profile.maidenName),
            ),
            ListTile(
              title: const Text("Username"),
              subtitle: Text(profile.username),
            ),
            ListTile(
              title: const Text("Email"),
              subtitle: Text(profile.email),
            ),
            ListTile(
              title: const Text("BirthDate"),
              subtitle: Text(profile.birthDate),
            ),
            ListTile(
              title: const Text("Phone"),
              subtitle: Text(profile.phone),
            ),
            ListTile(
              title: const Text("Gender"),
              subtitle: Text(profile.gender),
            ),
            FractionallySizedBox(
                widthFactor: 0.9,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("cancel")))
          ],
        ),
      ),
    );
  }
}
