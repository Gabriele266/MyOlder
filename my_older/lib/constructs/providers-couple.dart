import '../providers/safe-file-manager.dart';
import '../providers/user-file-manager.dart';

class ProvidersCouple {
  final SafeFileManager safeFileManager;
  final UserFileManager userFileManager;

  /// Represents a couple of providers to pass in a single object. 
  ProvidersCouple(this.safeFileManager, this.userFileManager);
}
