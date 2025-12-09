import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/edit_profile_vm.dart';
import 'package:kinolive_mobile/presentation/viewmodels/profile/profile_vm.dart';
import 'package:kinolive_mobile/presentation/widgets/general/labeled_text_field.dart';
import 'package:kinolive_mobile/presentation/widgets/general/primary_button.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EditProfileForm extends HookConsumerWidget {
  final VoidCallback? onChanged;
  
  const EditProfileForm({super.key, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileVmProvider);
    final editState = ref.watch(editProfileVmProvider);
    final profile = editState.profile ?? profileState.profile;

    final localeInitialized = useState(false);
    useEffect(() {
      initializeDateFormatting('en', null).then((_) {
        localeInitialized.value = true;
      });
      return null;
    }, []);

    final firstNameController = useTextEditingController(
      text: profile?.firstName ?? '',
    );
    final lastNameController = useTextEditingController(
      text: profile?.lastName ?? '',
    );
    final phoneNumberController = useTextEditingController(
      text: profile?.phoneNumber ?? '',
    );
    
    final dateOfBirthController = useTextEditingController();
    
    useEffect(() {
      if (profile?.dateOfBirth != null) {
        if (localeInitialized.value) {
          final formatted = DateFormat('d MMMM yyyy', 'en').format(profile!.dateOfBirth!);
          dateOfBirthController.text = formatted.split(' ').map((word) {
            if (word.length > 0) {
              return word[0].toUpperCase() + word.substring(1).toLowerCase();
            }
            return word;
          }).join(' ');
        } else {
          dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(profile!.dateOfBirth!);
        }
      } else {
        dateOfBirthController.text = '';
      }
      return null;
    }, [profile?.dateOfBirth, localeInitialized.value]);

    useEffect(() {
      void listener() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onChanged?.call();
        });
      }
      
      firstNameController.addListener(listener);
      lastNameController.addListener(listener);
      phoneNumberController.addListener(listener);
      dateOfBirthController.addListener(listener);
      
      return () {
        firstNameController.removeListener(listener);
        lastNameController.removeListener(listener);
        phoneNumberController.removeListener(listener);
        dateOfBirthController.removeListener(listener);
      };
    }, [firstNameController, lastNameController, phoneNumberController, dateOfBirthController]);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dateOfBirth = useState<DateTime?>(profile?.dateOfBirth);
    final selectedImage = useState<File?>(null);
    final imagePicker = useMemoized(() => ImagePicker());

    useEffect(() {
      if (selectedImage.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onChanged?.call();
        });
      }
      return null;
    }, [selectedImage.value]);

    Future<void> onUpdate() async {
      if (!formKey.currentState!.validate()) return;

      DateTime? parsedDate;
      if (dateOfBirthController.text.isNotEmpty) {
        try {
          parsedDate = DateFormat('d MMMM yyyy', 'en').parse(dateOfBirthController.text);
        } catch (e) {
          try {
            parsedDate = DateFormat('yyyy-MM-dd').parse(dateOfBirthController.text);
          } catch (e2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid date format', textAlign: TextAlign.center),
              ),
            );
            return;
          }
        }
      }

      if (selectedImage.value != null) {
        try {
          final uploadPhoto = ref.read(uploadProfilePhotoProvider);
          await uploadPhoto(selectedImage.value!);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading photo: $e', textAlign: TextAlign.center),
            ),
          );
          return;
        }
      }

      await ref.read(editProfileVmProvider.notifier).updateProfile(
            firstName: firstNameController.text.trim().isEmpty
                ? null
                : firstNameController.text.trim(),
            lastName: lastNameController.text.trim().isEmpty
                ? null
                : lastNameController.text.trim(),
            phoneNumber: phoneNumberController.text.trim().isEmpty
                ? null
                : phoneNumberController.text.trim(),
            dateOfBirth: parsedDate,
          );
      
    }

    Future<void> selectDate() async {
      final picked = await showDatePicker(
        context: context,
        locale: const Locale('en', 'GB'),
        initialDate: dateOfBirth.value ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Theme.of(context).colorScheme.primary,
                  ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        dateOfBirth.value = picked;
        final formatted = DateFormat('d MMMM yyyy', 'en').format(picked);
        dateOfBirthController.text = formatted.split(' ').map((word) {
          if (word.length > 0) {
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }
          return word;
        }).join(' ');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onChanged?.call();
        });
      }
    }

    String? validateDate(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        DateFormat('d MMMM yyyy', 'en').parse(value);
        return null;
      } catch (e) {
        try {
          DateFormat('yyyy-MM-dd').parse(value);
          return null;
        } catch (e2) {
          return 'Invalid date format';
        }
      }
    }

    String? validateName(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      if (value.trim().length < 2) return 'Name must be at least 2 characters';
      if (value.trim().length > 256) return 'Name must be at most 256 characters';
      return null;
    }

    String? validatePhone(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 7) return 'Phone number looks too short';
      return null;
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Profile Picture Section
          Center(
            child: GestureDetector(
              onTap: () async {
                final source = await showModalBottomSheet<ImageSource>(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library, color: Colors.white),
                          title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context, ImageSource.gallery),
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt, color: Colors.white),
                          title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
                          onTap: () => Navigator.pop(context, ImageSource.camera),
                        ),
                        if (profile?.profilePhotoUrl != null || selectedImage.value != null)
                          ListTile(
                            leading: const Icon(Icons.delete, color: Colors.red),
                            title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                            onTap: () async {
                              Navigator.pop(context);
                              selectedImage.value = null;
                              
                              final currentProfile = editState.profile ?? profileState.profile;
                              if (currentProfile != null) {
                                final updatedProfile = currentProfile.copyWith(profilePhotoUrl: null);
                                ref.read(editProfileVmProvider.notifier).setInitialProfile(updatedProfile);
                              }
                              
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                onChanged?.call();
                              });
                              
                              try {
                                final deletePhoto = ref.read(deleteProfilePhotoProvider);
                                await deletePhoto();
                                await ref.read(profileVmProvider.notifier).load();
                                final serverProfile = ref.read(profileVmProvider).profile;
                                if (serverProfile != null) {
                                  ref.read(editProfileVmProvider.notifier).setInitialProfile(serverProfile);
                                }
                              } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error deleting photo: $e', textAlign: TextAlign.center),
                                ),
                              );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                );

                if (source != null) {
                  try {
                    final pickedFile = await imagePicker.pickImage(source: source);
                      if (pickedFile != null) {
                        selectedImage.value = File(pickedFile.path);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          onChanged?.call();
                        });
                      }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error picking image: $e', textAlign: TextAlign.center),
                      ),
                    );
                  }
                }
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: selectedImage.value != null
                        ? FileImage(selectedImage.value!)
                        : (profile?.profilePhotoUrl != null
                            ? NetworkImage(profile!.profilePhotoUrl!)
                            : null) as ImageProvider?,
                    child: selectedImage.value == null && profile?.profilePhotoUrl == null
                        ? const ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // First Name
          LabeledTextField(
            label: 'First Name',
            controller: firstNameController,
            hint: 'Enter your first name',
            validator: validateName,
            bottomSpacing: 24,
          ),

          // Last Name
          LabeledTextField(
            label: 'Last Name',
            controller: lastNameController,
            hint: 'Enter your last name',
            validator: validateName,
            bottomSpacing: 24,
          ),

          // Phone Number
          LabeledTextField(
            label: 'Mobile Number',
            controller: phoneNumberController,
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: validatePhone,
            bottomSpacing: 24,
          ),

          // Date of Birth
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date of Birth',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: dateOfBirthController,
                readOnly: true,
                onTap: selectDate,
                decoration: InputDecoration(
                  hintText: 'Select date of birth (e.g., 19 December 2006)',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
                validator: validateDate,
              ),
              const SizedBox(height: 24),
            ],
          ),

          const SizedBox(height: 16),

          // Update Button
          PrimaryButton(
            text: 'Update',
            onPressed: editState.status == EditProfileStatus.loading ? null : onUpdate,
            loading: editState.status == EditProfileStatus.loading,
          ),
        ],
      ),
    );
  }
}

