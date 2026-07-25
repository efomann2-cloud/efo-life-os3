List<bool> getBoolList(String key, int length) {
    final v = _state[key];
    if (v is List) {
      final list = v.map((e) => e == true).toList();
      if (list.length == length) return List<bool>.from(list);
    }
    return List<bool>.filled(length, false);
  }

  void setBoolListAt(String key, int length, int index, bool value) {
    final list = getBoolList(key, length);
    list[index] = value;
    setValue(key, list);
  }
