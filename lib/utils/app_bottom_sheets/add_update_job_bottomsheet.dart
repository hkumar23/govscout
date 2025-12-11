import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_language.dart';
import '../../data/models/job.model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../logic/blocs/job_management/job_management_bloc.dart';
import '../../logic/blocs/job_management/job_management_event.dart';
import '../../widgets/app_dropdown_button_formfield.dart';
import '../../widgets/app_text_form_field.dart';
import '../app_methods.dart';
import '../app_validators.dart';

abstract class AddUpdateJobBottomsheet {
  static void show(BuildContext context) {
    final appColors = AppColors(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: const SheetUI()),
      ),
    );
  }
}

class SheetUI extends StatefulWidget {
  const SheetUI({super.key});

  @override
  State<SheetUI> createState() => _SheetUIState();
}

class _SheetUIState extends State<SheetUI> {
  final _formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();
  final organizationCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final vacancyCtrl = TextEditingController();
  final payLevelCtrl = TextEditingController();
  final applicationFeeGeneralCtrl = TextEditingController();
  final applicationFeeObcCtrl = TextEditingController();
  final applicationFeeScStCtrl = TextEditingController();
  final officialNotifCtrl = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  JobType selectedJobType = JobType.permanent;
  WorkMode selectedWorkMode = WorkMode.offline;
  ApplicationMode selectedApplicationMode = ApplicationMode.online;

  DateTime? startDate;
  DateTime? endDate;

  bool? isGenderSpecific;
  bool? isFemaleOnly;
  bool? isActive;

  Future<void> submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (startDate == null || endDate == null) return;

    // setState(() => isLoading = true);

    final job = Job(
      title: titleCtrl.text.trim(),
      department: departmentCtrl.text.trim(),
      organization: organizationCtrl.text.trim(),
      category: categoryCtrl.text.trim(),
      description: descriptionCtrl.text.trim(),
      vacancies: int.parse(vacancyCtrl.text),
      jobType: selectedJobType,
      workMode: selectedWorkMode,
      payLevel: payLevelCtrl.text.trim(),
      applicationStartDate: startDate!,
      applicationEndDate: endDate!,
      applicationMode: selectedApplicationMode,
      officialNotificationUrl: officialNotifCtrl.text.trim(),
      applicationFeeGeneral: int.parse(applicationFeeGeneralCtrl.text),
      applicationFeeObc: int.parse(applicationFeeObcCtrl.text),
      applicationFeeScSt: int.parse(applicationFeeScStCtrl.text),
      genderSpecific: isGenderSpecific ?? false,
      femaleOnly: isFemaleOnly ?? false,
      postedByAdminId: AuthRepository().currentUser!.uid,
      verified: isActive ?? false,
      isActive: isActive ?? false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context);
    // BlocProvider.of<JobManagementBloc>(context).add(AddJobEvent(job));
    // setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          // controller: controller,
          children: [
            // Center(
            //   child: Container(
            //     width: 48,
            //     height: 5,
            //     decoration: BoxDecoration(
            //       color: Colors.grey[300],
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 45),
            _title(AppLanguage.addNewJob),
            const SizedBox(height: 24),
            AppTextFormField(
              controller: titleCtrl,
              labelText: "Job Title",
              prefixIcon: Icons.work_outline,
              validator: AppValidators.textRequired,
              bottomPadding: 16,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: departmentCtrl,
                      labelText: AppLanguage.department,
                      prefixIcon: Icons.account_tree_outlined,
                      validator: AppValidators.textRequired,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppTextFormField(
                      controller: organizationCtrl,
                      labelText: AppLanguage.organisation,
                      prefixIcon: Icons.apartment_outlined,
                      validator: AppValidators.textRequired,
                    ),
                  ),
                ],
              ),
            ),
            AppTextFormField(
              controller: descriptionCtrl,
              labelText: AppLanguage.description,
              maxLines: 4,
              prefixIcon: Icons.description_outlined,
              validator: AppValidators.textRequired,
              bottomPadding: 16,
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: categoryCtrl,
                      labelText: AppLanguage.category,
                      prefixIcon: Icons.category_outlined,
                      validator: AppValidators.textRequired,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppTextFormField(
                      controller: vacancyCtrl,
                      labelText: "Total ${AppLanguage.vacancies}",
                      prefixIcon: Icons.numbers,
                      validator: AppValidators.integerTypeRequired,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            AppTextFormField(
              controller: payLevelCtrl,
              labelText: AppLanguage.payLevel,
              prefixIcon: Icons.money_outlined,
              validator: AppValidators.textRequired,
              bottomPadding: 16,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: AppDropdownButtonFormField(
                      value: null,
                      items: JobType.values.map((v) => v.name).toList(),
                      labelText: "Job Type",
                      prefixIcon: Icons.badge_outlined,
                      onChanged: (v) => setState(() {
                        for (var jobType in JobType.values) {
                          if (jobType.name == v) {
                            selectedJobType = jobType;
                          }
                        }
                      }),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppDropdownButtonFormField(
                      value: null,
                      items: WorkMode.values
                          .map((jobType) => jobType.name)
                          .toList(),
                      labelText: "Work Mode",
                      prefixIcon: Icons.workspaces_outline,
                      onChanged: (v) => setState(() {
                        for (var workMode in WorkMode.values) {
                          if (workMode.name == v) {
                            selectedWorkMode = workMode;
                          }
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),

            AppDropdownButtonFormField(
              value: null,
              items: ApplicationMode.values.map((v) => v.name).toList(),
              labelText: "Application Mode",
              bottomPadding: 16,
              prefixIcon: Icons.how_to_reg_outlined,
              onChanged: (v) => setState(() {
                for (var appMode in ApplicationMode.values) {
                  if (appMode.name == v) {
                    selectedApplicationMode = appMode;
                  }
                }
              }),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: startDateController,
                      readOnly: true, // Makes the field non-editable
                      hintText: "Application Start Date",
                      prefixIcon: Icons.play_circle_outline,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                            startDateController.text =
                                DateFormat("dd MMM yyyy").format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppTextFormField(
                      controller: endDateController,
                      readOnly: true, // Makes the field non-editable
                      hintText: "Application End Date",
                      prefixIcon: Icons.stop_circle_outlined,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                            endDateController.text =
                                DateFormat("dd MMM yyyy").format(pickedDate);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _title("Application Fees"),
            AppTextFormField(
              controller: applicationFeeGeneralCtrl,
              labelText: "General",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee,
              validator: AppValidators.doubleTypeRequired,
              bottomPadding: 16,
            ),
            AppTextFormField(
              controller: applicationFeeObcCtrl,
              labelText: "OBC",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee,
              validator: AppValidators.doubleTypeRequired,
              bottomPadding: 16,
            ),
            AppTextFormField(
              controller: applicationFeeScStCtrl,
              labelText: "SC/ST",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee,
              validator: AppValidators.doubleTypeRequired,
              bottomPadding: 16,
            ),
            AppTextFormField(
              controller: officialNotifCtrl,
              labelText: "Notification URL",
              prefixIcon: Icons.link,
              bottomPadding: 16,
              validator: AppValidators.textRequired,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitJob,
              child: const Text("Submit Job"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
