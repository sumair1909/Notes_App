class Note {

	int _id;
	String _title;
	String _content;


	Note(this._title, [this._content]);

	Note.withId(this._id, this._title, [this._content]);

	int get id => _id;

	String get title => _title;

	String get content => _content;



	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}

	set content(String newcontent) {
		if (newcontent.length <= 255) {
			this._content = newcontent;
		}
	}

	

	
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['content'] = _content;


		return map;
	}

	
	Note.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._content = map['content'];

	}
}
