class Note {
  // Creating the Instances of Model Class
  int _id;
  String _title;
  int _priority;
  String _description;
  String _date;
  Note(this._title, this._date, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._description,
      [this._priority]);
  // Creating get the instances
  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get date => _date;
  String get description => _description;
  //Setting new Values added into the Instances
  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  /*Now I am converting Note/class objects into Map object
  I am using Map objects to add data into Database
*/
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //Now I am add and updating So I Check it
    if (id != null) {
      map['id'] = _id;
    }

    map['priority'] = _priority;
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    return map;
  }

  //Now retrieve data by converting map int Note/Class Objects
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
