import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_container.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/contact_submission.dart';
import '../providers/legal_provider.dart';

/// Contact Us page
class ContactUsPage extends ConsumerStatefulWidget {
  const ContactUsPage({super.key});

  @override
  ConsumerState<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _phoneController = TextEditingController();

  ContactCategory _selectedCategory = ContactCategory.general;

  @override
  void initState() {
    super.initState();
    
    // Listen for form submission success
    ref.listenManual(isContactFormSubmittedProvider, (previous, next) {
      if (next && mounted) {
        // Clear form
        _clearForm();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CommonText.bodyMedium(
              context.translate('contact_form_submitted_successfully'),
              color: context.onPrimary,
            ),
            backgroundColor: context.primary,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Reset provider state
        ref.read(legalNotifierProvider.notifier).resetState();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLegalLoadingProvider);
    final error = ref.watch(legalErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: CommonText.titleMedium(
          context.translate('contact_us'),
          color: context.onSurface,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                CommonContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.headlineSmall(
                        context.translate('get_in_touch'),
                        color: context.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      CommonText.bodyMedium(
                        context.translate('contact_us_description'),
                        color: context.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Contact Form
                CommonContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      CommonText.labelMedium(
                        '${context.translate('name')} *',
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        controller: _nameController,
                        hintText: context.translate('enter_your_name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('name_required');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email field
                      CommonText.labelMedium(
                        '${context.translate('email')} *',
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        controller: _emailController,
                        hintText: context.translate('enter_your_email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('email_required');
                          }
                          if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                            return context.translate('invalid_email');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Phone field (optional)
                      CommonText.labelMedium(
                        context.translate('phone_optional'),
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        controller: _phoneController,
                        hintText: context.translate('enter_your_phone'),
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Category dropdown
                      CommonText.labelMedium(
                        '${context.translate('category')} *',
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ContactCategory>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: context.translate('select_category'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.primary, width: 2),
                          ),
                        ),
                        items: ContactCategory.values.map((category) {
                          return DropdownMenuItem<ContactCategory>(
                            value: category,
                            child: CommonText.bodyMedium(
                              category.displayName,
                              color: context.onSurface,
                            ),
                          );
                        }).toList(),
                        onChanged: (ContactCategory? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Subject field
                      CommonText.labelMedium(
                        '${context.translate('subject')} *',
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        controller: _subjectController,
                        hintText: context.translate('enter_subject'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('subject_required');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Message field
                      CommonText.labelMedium(
                        '${context.translate('message')} *',
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        controller: _messageController,
                        hintText: context.translate('enter_your_message'),
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.translate('message_required');
                          }
                          if (value.trim().length < 10) {
                            return context.translate('message_too_short');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Error message
                      if (error != null) ...[
                        CommonContainer(
                          padding: const EdgeInsets.all(12),
                          backgroundColor: context.errorContainer,
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: context.onErrorContainer),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CommonText.bodyMedium(
                                  error,
                                  color: context.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: CommonButton(
                          text: context.translate('send_message'),
                          onPressed: isLoading ? null : _submitForm,
                          isLoading: isLoading,
                          backgroundColor: context.primary,
                          textColor: context.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Additional contact info
                CommonContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.titleMedium(
                        context.translate('other_ways_to_reach_us'),
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 16),
                      
                      // Email support
                      Row(
                        children: [
                          Icon(Icons.email_outlined, color: context.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.bodyMedium(
                                context.translate('email_support'),
                                color: context.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              CommonText.bodySmall(
                                'support@gigafaucet.com',
                                color: context.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Response time
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined, color: context.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.bodyMedium(
                                context.translate('response_time'),
                                color: context.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              CommonText.bodySmall(
                                context.translate('response_time_description'),
                                color: context.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final submission = ContactSubmission(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        category: _selectedCategory,
        createdAt: DateTime.now(),
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
      );

      ref.read(legalNotifierProvider.notifier).submitContactForm(submission);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
    _phoneController.clear();
    setState(() {
      _selectedCategory = ContactCategory.general;
    });
  }
}