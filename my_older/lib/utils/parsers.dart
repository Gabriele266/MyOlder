/// Reads a bool starting from a string
bool stringToBool(String source) {
  final sourceLw = source.toLowerCase();

  if (sourceLw == 'true' ||
      sourceLw == 'yes' ||
      sourceLw == 'y' ||
      sourceLw == 'si') return true;
  return false;
}
