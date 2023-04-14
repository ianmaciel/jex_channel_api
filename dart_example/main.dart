import 'package:jex_channel_api/jex_channel_api.dart';

const String pwd = 'abcde';

main() async {
  JExChannel jExChannel = JExChannel();

  bool result = await jExChannel.login('inm', pwd);
  if (result) {
    print('logged sussecfully\n');
  } else {
    print('error while trying to login.');
  }

  await jExChannel.getJexpToken();
  print('create appointment:');
  String createAppointment = await jExChannel.createAppointment();
  print('$createAppointment\n');

  print('get projects:');
  String projetos = await jExChannel.getProjectAjax();
  print('$projetos\n');
}
