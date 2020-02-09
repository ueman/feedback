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