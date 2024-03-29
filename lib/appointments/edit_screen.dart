import 'package:flutter/material.dart';
import 'package:genesis_flutter/appointments/color.dart';
import 'package:genesis_flutter/appointments/storage.dart';
import 'package:google_meet_sdk/google_meet_sdk.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final GoogleMeetEventInfo event;

  const EditScreen({super.key, required this.event});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Storage storage = Storage();
  CalendarClient calendarClient = CalendarClient();

  TextEditingController? textControllerDate;
  TextEditingController? textControllerStartTime;
  TextEditingController? textControllerEndTime;
  TextEditingController? textControllerTitle;
  TextEditingController? textControllerDesc;
  TextEditingController? textControllerLocation;
  TextEditingController? textControllerAttendee;

  FocusNode? textFocusNodeTitle;
  FocusNode? textFocusNodeDesc;
  FocusNode? textFocusNodeLocation;
  FocusNode? textFocusNodeAttendee;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  String? eventId;
  String? currentTitle;
  String? currentDesc;
  String? currentLocation;
  String? currentEmail;
  String errorString = '';
  List<String> attendeeEmails = [];

  bool isEditingDate = false;
  bool isEditingStartTime = false;
  bool isEditingEndTime = false;
  bool isEditingBatch = false;
  bool isEditingTitle = false;
  bool isEditingEmail = false;
  bool isEditingLink = false;
  bool isErrorTime = false;
  bool shouldNofityAttendees = false;
  bool hasConferenceSupport = false;

  bool isDataStorageInProgress = false;
  bool isDeletionInProgress = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        textControllerDate?.text = DateFormat.yMMMMd().format(selectedDate);
      });
    }
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        textControllerStartTime?.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        textControllerStartTime?.text = selectedStartTime.format(context);
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
        textControllerEndTime?.text = selectedEndTime.format(context);
      });
    } else {
      setState(() {
        textControllerEndTime?.text = selectedEndTime.format(context);
      });
    }
  }

  String? _validateTitle(String value) {
    if (value.isNotEmpty) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Title can\'t be empty';
      }
    } else {
      return 'Title can\'t be empty';
    }

    return null;
  }

  String? _validateEmail(String value) {
    if (value.isNotEmpty) {
      value = value.trim();

      if (value.isEmpty) {
        return 'Can\'t add an empty email';
      } else {
        final regex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        final matches = regex.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return null;
          }
        }
      }
    } else {
      return 'Can\'t add an empty email';
    }

    return 'Invalid email';
  }

  @override
  void initState() {
    DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(widget.event.startTimeInEpoch);
    DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(widget.event.endTimeInEpoch);

    selectedStartTime = TimeOfDay.fromDateTime(startTime);
    selectedEndTime = TimeOfDay.fromDateTime(endTime);
    currentTitle = widget.event.name;
    currentDesc = widget.event.description;
    currentLocation = widget.event.location;
    eventId = widget.event.id;
    hasConferenceSupport = widget.event.hasConferencingSupport;

    for (var element in widget.event.attendeeEmails) {
      attendeeEmails.add(element);
    }

    String dateString = DateFormat.yMMMMd().format(startTime);
    String startString = DateFormat.jm().format(startTime);
    String endString = DateFormat.jm().format(endTime);

    textControllerDate = TextEditingController(text: dateString);
    textControllerStartTime = TextEditingController(text: startString);
    textControllerEndTime = TextEditingController(text: endString);
    textControllerTitle = TextEditingController(text: currentTitle);
    textControllerDesc = TextEditingController(text: currentDesc);
    textControllerLocation = TextEditingController(text: currentLocation);
    textControllerAttendee = TextEditingController();

    textFocusNodeTitle = FocusNode();
    textFocusNodeDesc = FocusNode();
    textFocusNodeLocation = FocusNode();
    textFocusNodeAttendee = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'Edit Event',
          style: TextStyle(
            color: CustomColor.darkBlue,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            onPressed: isDeletionInProgress
                ? null
                : () async {
                    setState(() {
                      isDeletionInProgress = true;
                      isDataStorageInProgress = true;
                    });
                    await calendarClient
                        .delete(eventId!, true)
                        .whenComplete(() async {
                      await storage
                          .deleteEvent(id: eventId!)
                          .whenComplete(() => Navigator.of(context).pop())
                          .catchError((e) => debugPrint(e));
                    });

                    setState(() {
                      isDeletionInProgress = false;
                      isDataStorageInProgress = false;
                    });
                  },
            // color: Colors.white,
            child: isDeletionInProgress
                ? const SizedBox(
                    height: 28,
                    width: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : const Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You can edit the event details on this page. You can also choose to notify the attendees about this change.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Text(
                    //   'You will have access to modify or remove the event afterwards.',
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontFamily: 'Raleway',
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //     letterSpacing: 0.5,
                    //   ),
                    // ),
                    const SizedBox(height: 16.0),
                    RichText(
                      text: const TextSpan(
                        text: 'Select Date',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.seaBlue,
                      controller: textControllerDate,
                      textCapitalization: TextCapitalization.characters,
                      onTap: () => _selectDate(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: September 10, 2020',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText:
                            isEditingDate && textControllerDate?.text != null
                                ? textControllerDate!.text.isNotEmpty
                                    ? null
                                    : 'Date can\'t be empty'
                                : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Start Time',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.seaBlue,
                      controller: textControllerStartTime,
                      onTap: () => _selectStartTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: 09:30 AM',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingStartTime &&
                                textControllerStartTime?.text != null
                            ? textControllerStartTime!.text.isNotEmpty
                                ? null
                                : 'Start time can\'t be empty'
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'End Time',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      cursorColor: CustomColor.seaBlue,
                      controller: textControllerEndTime,
                      onTap: () => _selectEndTime(context),
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: 11:30 AM',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingEndTime &&
                                textControllerEndTime?.text != null
                            ? textControllerEndTime!.text.isNotEmpty
                                ? null
                                : 'End time can\'t be empty'
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Title',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: true,
                      cursorColor: CustomColor.seaBlue,
                      focusNode: textFocusNodeTitle,
                      controller: textControllerTitle,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          isEditingTitle = true;
                          currentTitle = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeTitle?.unfocus();
                        FocusScope.of(context).requestFocus(textFocusNodeDesc);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: Birthday party of John',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        errorText: isEditingTitle
                            ? _validateTitle(currentTitle ?? "")
                            : null,
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Description',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: true,
                      maxLines: null,
                      cursorColor: CustomColor.seaBlue,
                      focusNode: textFocusNodeDesc,
                      controller: textControllerDesc,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          currentDesc = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeDesc?.unfocus();
                        FocusScope.of(context)
                            .requestFocus(textFocusNodeLocation);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'eg: Some information about this event',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Location',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: true,
                      cursorColor: CustomColor.seaBlue,
                      focusNode: textFocusNodeLocation,
                      controller: textControllerLocation,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          currentLocation = value;
                        });
                      },
                      onSubmitted: (value) {
                        textFocusNodeLocation?.unfocus();
                        FocusScope.of(context)
                            .requestFocus(textFocusNodeAttendee);
                      },
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.seaBlue, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: CustomColor.darkBlue, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          top: 16,
                          right: 16,
                        ),
                        hintText: 'Place of the event',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        text: 'Attendees',
                        style: TextStyle(
                          color: CustomColor.darkCyan,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemCount: attendeeEmails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                attendeeEmails[index],
                                style: const TextStyle(
                                  color: CustomColor.neonGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    attendeeEmails.removeAt(index);
                                  });
                                },
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: true,
                            cursorColor: CustomColor.seaBlue,
                            focusNode: textFocusNodeAttendee,
                            controller: textControllerAttendee,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                currentEmail = value;
                              });
                            },
                            onSubmitted: (value) {
                              textFocusNodeAttendee?.unfocus();
                            },
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: CustomColor.seaBlue, width: 1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: CustomColor.darkBlue, width: 2),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 16,
                                bottom: 16,
                                top: 16,
                                right: 16,
                              ),
                              hintText: 'Enter attendee email',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              errorText: isEditingEmail
                                  ? _validateEmail(currentEmail ?? "")
                                  : null,
                              errorStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: CustomColor.seaBlue,
                            size: 35,
                          ),
                          onPressed: () {
                            setState(() {
                              isEditingEmail = true;
                            });
                            if (_validateEmail(currentEmail ?? "") == null) {
                              setState(() {
                                textFocusNodeAttendee?.unfocus();
                                attendeeEmails.add(currentEmail ?? "");

                                textControllerAttendee?.text = '';
                                currentEmail = null;
                                isEditingEmail = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: attendeeEmails.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notify attendees',
                                style: TextStyle(
                                  color: CustomColor.darkCyan,
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Switch(
                                value: shouldNofityAttendees,
                                onChanged: (value) {
                                  setState(() {
                                    shouldNofityAttendees = value;
                                  });
                                },
                                activeColor: CustomColor.seaBlue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        // elevation: 0,
                        // focusElevation: 0,
                        // highlightElevation: 0,
                        // color: CustomColor.seaBlue,
                        onPressed: isDataStorageInProgress
                            ? null
                            : () async {
                                setState(() {
                                  isErrorTime = false;
                                  isDataStorageInProgress = true;
                                });

                                textFocusNodeTitle?.unfocus();
                                textFocusNodeDesc?.unfocus();
                                textFocusNodeLocation?.unfocus();
                                textFocusNodeAttendee?.unfocus();

                                if (currentTitle != null) {
                                  int startTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedStartTime.hour,
                                    selectedStartTime.minute,
                                  ).millisecondsSinceEpoch;

                                  int endTimeInEpoch = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedEndTime.hour,
                                    selectedEndTime.minute,
                                  ).millisecondsSinceEpoch;
                                  if (endTimeInEpoch - startTimeInEpoch > 0) {
                                    if (_validateTitle(currentTitle ?? "") ==
                                        null) {
                                      await calendarClient
                                          .modify(
                                              id: eventId!,
                                              title: currentTitle ?? "",
                                              description: currentDesc ?? '',
                                              location: currentLocation ?? "",
                                              attendeeEmailList: attendeeEmails,
                                              shouldNotifyAttendees:
                                                  shouldNofityAttendees,
                                              hasConferenceSupport:
                                                  hasConferenceSupport,
                                              startTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      startTimeInEpoch),
                                              endTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      endTimeInEpoch))
                                          .then((eventData) async {
                                        String eventId = eventData!['id'] ?? "";
                                        String eventLink =
                                            eventData['link'] ?? "";

                                        List<String> emails = [];

                                        for (int i = 0;
                                            i < attendeeEmails.length;
                                            i++) {
                                          emails.add(attendeeEmails[i]);
                                        }

                                        GoogleMeetEventInfo eventInfo =
                                            GoogleMeetEventInfo(
                                          id: eventId,
                                          name: currentTitle ?? "",
                                          description: currentDesc ?? '',
                                          location: currentLocation ?? "",
                                          link: eventLink,
                                          attendeeEmails: emails,
                                          shouldNotifyAttendees:
                                              shouldNofityAttendees,
                                          hasConferencingSupport:
                                              hasConferenceSupport,
                                          startTimeInEpoch: startTimeInEpoch,
                                          endTimeInEpoch: endTimeInEpoch,
                                        );

                                        await storage
                                            .updateEventData(eventInfo)
                                            .whenComplete(() =>
                                                Navigator.of(context).pop())
                                            .catchError(
                                              (e) => debugPrint(e),
                                            );
                                      }).catchError(
                                        (e) {
                                          debugPrint(e);
                                        },
                                      );

                                      setState(() {
                                        isDataStorageInProgress = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEditingTitle = true;
                                        isEditingLink = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isErrorTime = true;
                                      errorString =
                                          'Invalid time! Please use a proper start and end time';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isEditingDate = true;
                                    isEditingStartTime = true;
                                    isEditingEndTime = true;
                                    isEditingBatch = true;
                                    isEditingTitle = true;
                                    isEditingLink = true;
                                  });
                                }
                                setState(() {
                                  isDataStorageInProgress = false;
                                });
                              },
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: isDataStorageInProgress
                              ? const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'MODIFY',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isErrorTime,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorString,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
