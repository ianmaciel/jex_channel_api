# jExperts Channel API

Unofficial DART API for jExperts Channel API.

## Usage

To use this library, add `jex_channel_api` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

# Build generated sources for Json serializable
`flutter pub run build_runner build`

### Example
``` dart
import 'package:jex_channel_api/jex_channel_api.dart';

void main() {
  JChannel channel = JChannel();
  ahgora.login('COMPANY_ID', 9999, 'USER_PASSWORD')
        .then(_loginCallback);
}

void _loginCallback() {
  if (result) {
    print('Login succeeded!');
    ahgora
      .getMonthlyReport(DateTime.now(), fiscalMonth: false)
      .then(_monthlyReportCallback);
  } else {
    print('Login failed!');
  }
}

void _monthlyReportCallback(MonthlyReport report) {
  print('Employee name: ${report.employee.name}');
  print('First day from this month: ${report.days.first.reference}');
}
```
