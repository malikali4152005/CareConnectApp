class MessageModel {
final int? id;
final int fromUserId; // 0 for doctor, user id for patient – demo purpose
final String text;
final String timestamp;


MessageModel({this.id, required this.fromUserId, required this.text, required this.timestamp});


Map<String, dynamic> toMap() => {
'id': id,
'fromUserId': fromUserId,
'text': text,
'timestamp': timestamp,
};


factory MessageModel.fromMap(Map<String, dynamic> m) => MessageModel(
id: m['id'] as int?,
fromUserId: m['fromUserId'],
text: m['text'],
timestamp: m['timestamp'],
);
}