import 'package:familiens_receptbok/app/app.dart';
import 'package:familiens_receptbok/bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  bootstrap(() => const ProviderScope(child: App()));
}
