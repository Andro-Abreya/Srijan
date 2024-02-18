class AppointmentInfo {
  final String speciality;
  final String dName;
  final String dQual;
  final String dImage;
  final bool hasChatEnabled;
  final String id;
  final String name;
  final String description;
  final String location;
  final String link;
  final List<dynamic> attendeeEmails;
  final bool shouldNotifyAttendees;
  final bool hasConferencingSupport;
  final int startTimeInEpoch;
  final int endTimeInEpoch;

  AppointmentInfo({
    required this.speciality,
    required this.dName,
    required this.dQual,
    required this.dImage,
    required this.hasChatEnabled,
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.link,
    required this.attendeeEmails,
    required this.shouldNotifyAttendees,
    required this.hasConferencingSupport,
    required this.startTimeInEpoch,
    required this.endTimeInEpoch,
  });

  AppointmentInfo.fromMap(Map data)
      : dName = data['name'] ?? '',
        dQual = data['qualification'] ?? '',
        dImage = data['imageUrl'] ?? '',
        hasChatEnabled = data['rate'] ?? '',
        speciality = data['speciality'] ?? '',
        id = data['id'] ?? '',
        name = data['name'] ?? '',
        description = data['desc'],
        location = data['loc'],
        link = data['link'],
        attendeeEmails = data['emails'] ?? '',
        shouldNotifyAttendees = data['should_notify'],
        hasConferencingSupport = data['has_conferencing'],
        startTimeInEpoch = data['start'],
        endTimeInEpoch = data['end'];

  toJson() {
    return {
      'id': id,
      'name': name,
      'desc': description,
      'loc': location,
      'link': link,
      'emails': attendeeEmails,
      'should_notify': true,
      'has_conferencing': true,
      'start': startTimeInEpoch,
      'end': endTimeInEpoch,
      'dName': dName,
      'dQual': dQual,
      'dImage': dImage,
      'speciality': speciality,
      'hasChatEnabled': hasChatEnabled,
    };
  }
}
