class ContactModel {
  int? status;
  List<Contact>? contacts;

  ContactModel({this.status, this.contacts});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      status: json['status'],
      contacts: json['resultSet'] != null
          ? List<Contact>.from(
              json['resultSet'].map((x) => Contact.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'resultSet': contacts != null
          ? List<dynamic>.from(contacts!.map((x) => x.toJson()))
          : null,
    };
  }
}

class Contact {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? fathersName;
  String? deleteStatus;
  String? createdAt;
  String? updatedAt;

  Contact({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.fathersName,
    this.deleteStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      fathersName: json['fathers_name'],
      deleteStatus: json['delete_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'fathers_name': fathersName,
      'delete_status': deleteStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
