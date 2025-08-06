import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/meeting_provider.dart';
import '../../widgets/common/custom_bottom_navigation.dart';
import 'add_meeting_screen.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MeetingProvider>(context, listen: false).loadMeetings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Reuniones'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddMeetingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MeetingProvider>(
        builder: (context, meetingProvider, child) {
          if (meetingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
              ),
            );
          }

          if (meetingProvider.meetings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      size: 64,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No hay reuniones registradas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Registra tus reuniones para hacer seguimiento\nde tus conexiones profesionales',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddMeetingScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Primera Reunión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => meetingProvider.loadMeetings(),
            color: AppTheme.primaryGreen,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: meetingProvider.meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetingProvider.meetings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  AppTheme.primaryGreen.withOpacity(0.1),
                              backgroundImage: meeting.participantAvatar != null
                                  ? NetworkImage(meeting.participantAvatar!)
                                  : null,
                              child: meeting.participantAvatar == null
                                  ? Text(
                                      meeting.participantName.isNotEmpty
                                          ? meeting.participantName[0]
                                              .toUpperCase()
                                          : 'U',
                                      style: const TextStyle(
                                        color: AppTheme.primaryGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meeting.participantName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (meeting.participantCompany != null)
                                    Text(
                                      meeting.participantCompany!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: meeting.whoProposed == 'me'
                                    ? AppTheme.primaryGreen.withOpacity(0.1)
                                    : AppTheme.accentOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                meeting.whoProposedText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: meeting.whoProposed == 'me'
                                      ? AppTheme.primaryGreen
                                      : AppTheme.accentOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${meeting.meetingDate.day}/${meeting.meetingDate.month}/${meeting.meetingDate.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            if (meeting.location != null) ...[
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  meeting.location!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (meeting.topicsDiscussed != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Temas tratados:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meeting.topicsDiscussed!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddMeetingScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }
}
