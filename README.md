# feeback

A simple Flutter package for getting better feedback

## Getting Started

Just wrap your app in a `BetterFeedback` widget and supply
an `onFeedback` function. The function gets called when 
the user submits his feedback. To show the feedback view just
call `BetterFeedback.of(context).show();`

```dart
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    BetterFeedback(
      child: MyApp(
        key: GlobalKey(),
      ),
      onFeedback: alertFeedbackFunction,
    ),
  );
}
```

## Sample
![Example](img/example.png "Example")

## Additional notes
You can combine this with [device_info](https://pub.dev/packages/device_info) to 
get additional information about the users environment to better debug his issues. 

## FAQ
- Why does the content of my Scaffold change (gets repositioned upwards) while I'm
    writing my feedback?
    - Probably because Scaffold.[resizeToAvoidBottomInset](https://api.flutter.dev/flutter/material/Scaffold/resizeToAvoidBottomInset.html) 
      is set to true. You could set it to false while the user provides feedback.