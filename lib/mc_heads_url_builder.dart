class McHeadsUrlBuilder {
  String buildHead(String username, {int size = 256}) {
    final trimmedUsername = username.trim();
    return 'https://api.mcheads.org/head/$trimmedUsername/$size';
  }
}