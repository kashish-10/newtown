class TContact {
  int? _id;
  String? _number;
  String? _name;

  TContact(this._number, this._name);
  TContact.withId(this._id, this._number, this._name);

  //getters

  int get id => _id!;
  String get number => _number!;
  String get name => _name!;

  get displayName => null;

  @override
  String toString() {
    return 'Contact:{id: $_id, name: $_name, number: $_number}';
  }

  //Setters
  set number(String newNumber) => _number = newNumber;
  set name(String newName) => _name = newName;

  //converting contact obj to map obj
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['number'] = _number;
    map['name'] = _name;

    return map;
  }

  //Extract from map
  TContact.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _number = map['number'];
    _name = map['name'];
  }
}
