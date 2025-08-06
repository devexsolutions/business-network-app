import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/meeting_model.dart';
import '../../providers/meeting_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/user_selector.dart';

class AddMeetingScreen extends StatefulWidget {
  const AddMeetingScreen({Key? key}) : super(key: key);

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _topicsController = TextEditingController();

  User? _selectedUser;
  DateTime? _selectedDate;
  String _whoProposed = 'me';
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveMeeting() async {
    if (!_formKey.currentState!.validate() ||
        _selectedUser == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final meetingProvider =
          Provider.of<MeetingProvider>(context, listen: false);

      final newMeeting = MeetingModel(
        id: 0, // Will be assigned by the server
        participantId: _selectedUser!.id,
        participantName: _selectedUser!.name,
        participantCompany: _selectedUser!.company?.name,
        participantAvatar: _selectedUser!.avatar,
        whoProposed: _whoProposed,
        meetingDate: _selectedDate!,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        topicsDiscussed: _topicsController.text.trim().isEmpty
            ? null
            : _topicsController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await meetingProvider.addMeeting(newMeeting);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reunión registrada exitosamente'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar la reunión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Registrar Reunión'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Usuario selector
              const Text(
                'Usuario con el que me reuní *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: UserSelector(
                  selectedUser: _selectedUser,
                  onUserSelected: (user) {
                    setState(() {
                      _selectedUser = user;
                    });
                  },
                  hintText: 'Buscar y seleccionar usuario...',
                ),
              ),
              const SizedBox(height: 24),

              // Quien propuso
              const Text(
                '¿Quién propuso la reunión? *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Yo propuse la reunión'),
                      value: 'me',
                      groupValue: _whoProposed,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (value) {
                        setState(() {
                          _whoProposed = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('La otra persona propuso'),
                      value: 'them',
                      groupValue: _whoProposed,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (value) {
                        setState(() {
                          _whoProposed = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Fecha
              const Text(
                'Fecha de la reunión *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: AppTheme.primaryGreen),
                  title: Text(
                    _selectedDate == null
                        ? 'Seleccionar fecha'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(
                      color: _selectedDate == null
                          ? Colors.grey
                          : AppTheme.textPrimary,
                    ),
                  ),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 24),

              // Lugar
              const Text(
                'Lugar de la reunión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _locationController,
                label: 'Lugar de la reunión',
                hint: 'Ej: Oficina, Café Central, Zoom...',
                prefixIcon: Icons.location_on,
                maxLines: 1,
              ),
              const SizedBox(height: 24),

              // Temas tratados
              const Text(
                'Temas tratados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _topicsController,
                label: 'Temas tratados',
                hint: 'Describe los temas principales que se discutieron...',
                prefixIcon: Icons.topic,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isLoading ? 'Guardando...' : 'Registrar Reunión',
                  onPressed: _isLoading ? null : _saveMeeting,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
