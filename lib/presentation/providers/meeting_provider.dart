import 'package:flutter/material.dart';
import '../../data/models/meeting_model.dart';
import '../../data/repositories/meeting_repository.dart';

class MeetingProvider with ChangeNotifier {
  final MeetingRepository _repository = MeetingRepository();

  List<MeetingModel> _meetings = [];
  bool _isLoading = false;
  String? _error;

  List<MeetingModel> get meetings => _meetings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMeetings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _meetings = await _repository.getMeetings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addMeeting(MeetingModel meeting) async {
    try {
      final newMeeting = await _repository.createMeeting(
        participantId: meeting.participantId,
        whoProposed: meeting.whoProposed,
        meetingDate: meeting.meetingDate,
        location: meeting.location,
        topicsDiscussed: meeting.topicsDiscussed,
      );

      _meetings.add(newMeeting);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateMeeting(MeetingModel meeting) async {
    try {
      final updatedMeeting = await _repository.updateMeeting(
        meetingId: meeting.id,
        participantId: meeting.participantId,
        whoProposed: meeting.whoProposed,
        meetingDate: meeting.meetingDate,
        location: meeting.location,
        topicsDiscussed: meeting.topicsDiscussed,
      );

      final index = _meetings.indexWhere((m) => m.id == meeting.id);
      if (index != -1) {
        _meetings[index] = updatedMeeting;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteMeeting(int meetingId) async {
    try {
      await _repository.deleteMeeting(meetingId);
      _meetings.removeWhere((m) => m.id == meetingId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
