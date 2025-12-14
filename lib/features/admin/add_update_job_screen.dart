import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_language.dart';
import '../../data/models/job.model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../logic/blocs/job_management/job_management_bloc.dart';
import '../../logic/blocs/job_management/job_management_event.dart';
import '../../logic/blocs/job_management/job_management_state.dart';
import '../../utils/custom_snackbar.dart';
import '../../widgets/app_dropdown_button_formfield.dart';
import '../../widgets/app_text_form_field.dart';
import '../../utils/app_validators.dart';
import '../../widgets/chip_input_widget.dart';
import '../widgets/app_switch_button.dart';
import 'widgets/add_update_job_helper.dart';

class AddUpdateJobScreen extends StatefulWidget {
  final Job? job;
  const AddUpdateJobScreen({super.key, this.job});

  @override
  State<AddUpdateJobScreen> createState() => _AddUpdateJobScreenState();
}

class _AddUpdateJobScreenState extends State<AddUpdateJobScreen> {
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
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final jobLocationCtrl = TextEditingController();
  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final minAgeCtrl = TextEditingController();
  final maxAgeCtrl = TextEditingController();
  final minExperienceCtrl = TextEditingController();
  final examDateCtrl = TextEditingController();
  final resultDateCtrl = TextEditingController();
  final applicationLinkCtrl = TextEditingController();
  final advtNumberCtrl = TextEditingController();

  JobType selectedJobType = JobType.permanent;
  WorkMode selectedWorkMode = WorkMode.offline;
  ApplicationMode selectedApplicationMode = ApplicationMode.online;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? examDate;
  DateTime? resultDate;

  bool? isGenderSpecific;
  bool? isFemaleOnly;
  bool isActive = true;
  bool? isAgeRelaxationAllowed;
  bool? isExperienceRequired;

  List<String> qualificationsRequired = [];
  List<String> fieldOfStudyRequired = [];
  List<String> tags = [];
  List<String> keywords = [];

  Future<void> submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (startDate == null || endDate == null) return;

    // setState(() => isLoading = true);

    final job = Job(
      title: titleCtrl.text.trim(),
      department: departmentCtrl.text.trim(),
      organization: organizationCtrl.text.trim(),
      description: descriptionCtrl.text.trim(),
      category: categoryCtrl.text.trim(),
      vacancies: int.parse(vacancyCtrl.text),
      tags: tags,
      keywords: keywords,
      jobType: selectedJobType,
      workMode: selectedWorkMode,
      location: jobLocationCtrl.text.trim(),
      genderSpecific: isGenderSpecific ?? false,
      femaleOnly: isFemaleOnly ?? false,
      salaryMin: int.tryParse(minSalaryCtrl.text.trim()),
      salaryMax: int.tryParse(maxSalaryCtrl.text.trim()),
      payLevel: payLevelCtrl.text.trim(),
      minAge: int.tryParse(minAgeCtrl.text.trim()),
      maxAge: int.tryParse(maxAgeCtrl.text.trim()),
      ageRelaxationAllowed: isAgeRelaxationAllowed,
      experienceRequired: isExperienceRequired,
      minExperienceYears: int.tryParse(minExperienceCtrl.text.trim()),
      qualificationRequired: qualificationsRequired,
      fieldOfStudyRequired: fieldOfStudyRequired,
      applicationMode: selectedApplicationMode,
      applicationLink: applicationLinkCtrl.text.trim(),
      officialNotificationUrl: officialNotifCtrl.text.trim(),
      advtNumber: advtNumberCtrl.text.trim(),
      applicationStartDate: startDate!,
      applicationEndDate: endDate!,
      examDate: examDate,
      resultDate: resultDate,
      applicationFeeGeneral: int.parse(applicationFeeGeneralCtrl.text),
      applicationFeeObc: int.parse(applicationFeeObcCtrl.text),
      applicationFeeScSt: int.parse(applicationFeeScStCtrl.text),
      postedByAdminId: AuthRepository().currentUser!.uid,
      verified: isActive,
      isActive: isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.job == null) {
      BlocProvider.of<JobManagementBloc>(context).add(CreateJobEvent(job));
    } else {
      BlocProvider.of<JobManagementBloc>(context).add(
        UpdateJobEvent(
          widget.job!.id!,
          job.toJson(),
        ),
      );
    }
  }

  @override
  void initState() {
    if (widget.job != null) {
      titleCtrl.text = widget.job!.title;
      departmentCtrl.text = widget.job!.department;
      organizationCtrl.text = widget.job!.organization;
      categoryCtrl.text = widget.job!.category;
      descriptionCtrl.text = widget.job!.description;
      vacancyCtrl.text = widget.job!.vacancies.toString();
      payLevelCtrl.text = widget.job!.payLevel;
      applicationFeeGeneralCtrl.text =
          widget.job!.applicationFeeGeneral.toString();
      applicationFeeObcCtrl.text = widget.job!.applicationFeeObc.toString();
      applicationFeeScStCtrl.text = widget.job!.applicationFeeScSt.toString();
      officialNotifCtrl.text = widget.job!.officialNotificationUrl;
      startDateCtrl.text =
          DateFormat("dd MMM yyyy").format(widget.job!.applicationStartDate);
      endDateCtrl.text =
          DateFormat("dd MMM yyyy").format(widget.job!.applicationEndDate);
      jobLocationCtrl.text = widget.job!.location ?? "";
      minSalaryCtrl.text = widget.job!.salaryMin?.toString() ?? "";
      maxSalaryCtrl.text = widget.job!.salaryMax?.toString() ?? "";
      minAgeCtrl.text = widget.job!.minAge?.toString() ?? "";
      maxAgeCtrl.text = widget.job!.maxAge?.toString() ?? "";
      minExperienceCtrl.text = widget.job!.minExperienceYears?.toString() ?? "";
      examDateCtrl.text = widget.job!.examDate != null
          ? DateFormat("dd MMM yyyy").format(widget.job!.examDate!)
          : "";
      resultDateCtrl.text = widget.job!.resultDate != null
          ? DateFormat("dd MMM yyyy").format(widget.job!.resultDate!)
          : "";
      applicationLinkCtrl.text = widget.job!.applicationLink ?? "";
      advtNumberCtrl.text = widget.job!.advtNumber ?? "";

      selectedJobType = widget.job!.jobType;
      selectedWorkMode = widget.job!.workMode;
      selectedApplicationMode = widget.job!.applicationMode;

      startDate = widget.job!.applicationStartDate;
      endDate = widget.job!.applicationEndDate;
      examDate = widget.job!.examDate;
      resultDate = widget.job!.resultDate;

      isGenderSpecific = widget.job!.genderSpecific;
      isFemaleOnly = widget.job!.femaleOnly;
      isActive = widget.job!.isActive;
      isAgeRelaxationAllowed = widget.job!.ageRelaxationAllowed;
      isExperienceRequired = widget.job!.experienceRequired;

      qualificationsRequired = widget.job!.qualificationRequired;
      fieldOfStudyRequired = widget.job!.fieldOfStudyRequired;
      tags = widget.job!.tags;
      keywords = widget.job!.keywords;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context);
    final helper = AddUpdateJobHelper(
      context,
      AppColors(context),
    );

    return SafeArea(
      top: false,
      child: BlocConsumer<JobManagementBloc, JobManagementState>(
        listener: (context, state) {
          if (state is JobManagementErrorState) {
            CustomSnackbar.error(
              context: context,
              text: state.e.message,
            );
          }
          if (state is CreateJobSuccessState) {
            Navigator.of(context).pop();
            CustomSnackbar.success(
              context: context,
              text: "Job Posted successfully!",
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: ElevatedButton(
              onPressed: submitJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primary,
                foregroundColor: appColors.onPrimary,
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              child: state is JobManagementLoadingState
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "${widget.job == null ? AppLanguage.submit : AppLanguage.update} Job",
                    ),
            ),
            appBar: AppBar(
              title: Text(
                AppLanguage.addNewJob,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSwitchButton(
                        isActive: isActive,
                        onChange: (val) {
                          setState(() {
                            isActive = val;
                          });
                        },
                      ),
                      helper.buildSectionTitle("Basic Job Information"),
                      AppTextFormField(
                        controller: titleCtrl,
                        labelText: AppLanguage.jobTitle,
                        prefixIcon: Icons.work_outline,
                        validator: AppValidators.textRequired,
                        bottomPadding: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: departmentCtrl,
                              labelText: AppLanguage.department,
                              prefixIcon: Icons.account_tree_outlined,
                              validator: AppValidators.textRequired,
                              bottomPadding: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              controller: organizationCtrl,
                              labelText: AppLanguage.organisation,
                              prefixIcon: Icons.apartment_outlined,
                              validator: AppValidators.textRequired,
                              bottomPadding: 16,
                            ),
                          ),
                        ],
                      ),
                      AppTextFormField(
                        controller: descriptionCtrl,
                        labelText: AppLanguage.description,
                        maxLines: 4,
                        prefixIcon: Icons.description_outlined,
                        validator: AppValidators.textRequired,
                        bottomPadding: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: categoryCtrl,
                              labelText: AppLanguage.category,
                              prefixIcon: Icons.category_outlined,
                              validator: AppValidators.textRequired,
                              bottomPadding: 16,
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
                              bottomPadding: 16,
                            ),
                          ),
                        ],
                      ),
                      ChipInputWidget(
                        title: "Tags",
                        items: tags,
                      ),
                      ChipInputWidget(
                        title: "Keywords",
                        items: keywords,
                      ),
                      helper.buildSectionTitle("Job Type & Work Details"),
                      Row(
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
                              bottomPadding: 16,
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
                              bottomPadding: 16,
                            ),
                          ),
                        ],
                      ),
                      AppTextFormField(
                        controller: jobLocationCtrl,
                        labelText: "Job Location",
                        prefixIcon: Icons.location_on,
                        bottomPadding: 0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              controlAffinity: ListTileControlAffinity
                                  .leading, // checkbox on left
                              title: Text("Gender Specific"),
                              value: isGenderSpecific ?? false,
                              onChanged: (val) {
                                setState(() {
                                  isGenderSpecific = val;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              enabled: (isGenderSpecific ?? false),
                              contentPadding: EdgeInsets.all(0),
                              controlAffinity: ListTileControlAffinity
                                  .leading, // checkbox on left
                              title: Text("Female Only"),
                              value: isFemaleOnly ?? false,
                              onChanged: (val) {
                                setState(() {
                                  isFemaleOnly = val;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      helper.buildSectionTitle("Salary & Pay Details"),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: minSalaryCtrl,
                              labelText: "Min Salary",
                              prefixIcon: Icons.trending_down_rounded,
                              bottomPadding: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              controller: maxSalaryCtrl,
                              labelText: "Max Salary",
                              prefixIcon: Icons.trending_up_rounded,
                              bottomPadding: 16,
                            ),
                          ),
                        ],
                      ),
                      AppTextFormField(
                        controller: payLevelCtrl,
                        labelText: AppLanguage.payLevel,
                        prefixIcon: Icons.money_outlined,
                        validator: AppValidators.textRequired,
                        bottomPadding: 16,
                      ),
                      helper.buildSectionTitle("Eligibility Criteria"),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: minAgeCtrl,
                              labelText: "Min Age Limit",
                              prefixIcon: Icons.cake,
                              bottomPadding: 0,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              controller: maxAgeCtrl,
                              labelText: "Max Age Limit",
                              prefixIcon: Icons.cake,
                              bottomPadding: 0,
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        controlAffinity:
                            ListTileControlAffinity.leading, // checkbox on left
                        title: Text("Age Relaxation Allowed"),
                        value: isAgeRelaxationAllowed ?? false,
                        onChanged: (val) {
                          setState(() {
                            isAgeRelaxationAllowed = val;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              controlAffinity: ListTileControlAffinity
                                  .leading, // checkbox on left
                              title: Text("Experience Required"),
                              value: isExperienceRequired ?? false,
                              onChanged: (val) {
                                setState(() {
                                  isExperienceRequired = val;
                                  if (val == false) {
                                    minExperienceCtrl.clear();
                                  }
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: AppTextFormField(
                              controller: minExperienceCtrl,
                              labelText: "Experience in Years",
                              prefixIcon: Icons.work_history_outlined,
                              bottomPadding: 0,
                              validator: AppValidators.integerType,
                              keyboardType: TextInputType.number,
                              readOnly: !(isExperienceRequired ?? false),
                            ),
                          ),
                        ],
                      ),
                      ChipInputWidget(
                        title: "Qualifications",
                        items: qualificationsRequired,
                      ),
                      ChipInputWidget(
                        title: "Fields Of Study",
                        items: fieldOfStudyRequired,
                      ),
                      helper.buildSectionTitle("Application Process"),
                      AppDropdownButtonFormField(
                        value: null,
                        items:
                            ApplicationMode.values.map((v) => v.name).toList(),
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
                      AppTextFormField(
                        controller: applicationLinkCtrl,
                        labelText: "Application Link",
                        prefixIcon: Icons.link,
                        bottomPadding: 16,
                        validator: AppValidators.textRequired,
                      ),
                      AppTextFormField(
                        controller: officialNotifCtrl,
                        labelText: "Notification URL",
                        prefixIcon: Icons.link,
                        bottomPadding: 16,
                        validator: AppValidators.textRequired,
                      ),
                      AppTextFormField(
                        controller: advtNumberCtrl,
                        labelText: "ADVT Number",
                        prefixIcon: Icons.format_list_numbered_rounded,
                        bottomPadding: 16,
                      ),
                      helper.buildSectionTitle("Application Timeline"),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextFormField(
                                controller: startDateCtrl,
                                readOnly: true, // Makes the field non-editable
                                labelText: "Application Start Date",
                                prefixIcon: Icons.play_circle_outline,
                                validator: AppValidators.textRequired,
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
                                      startDateCtrl.text =
                                          DateFormat("dd MMM yyyy")
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: AppTextFormField(
                                controller: endDateCtrl,
                                readOnly: true, // Makes the field non-editable
                                labelText: "Application End Date",
                                prefixIcon: Icons.stop_circle_outlined,
                                validator: AppValidators.textRequired,
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
                                      endDateCtrl.text =
                                          DateFormat("dd MMM yyyy")
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              bottomPadding: 16,
                              controller: examDateCtrl,
                              readOnly: true, // Makes the field non-editable
                              labelText: "Exam Date",
                              prefixIcon: Icons.event_note_outlined,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2050),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    examDate = pickedDate;
                                    examDateCtrl.text =
                                        DateFormat("dd MMM yyyy")
                                            .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              bottomPadding: 16,
                              controller: resultDateCtrl,
                              readOnly: true, // Makes the field non-editable
                              labelText: "Result Date",
                              prefixIcon: Icons.event_available_outlined,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2050),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    resultDate = pickedDate;
                                    resultDateCtrl.text =
                                        DateFormat("dd MMM yyyy")
                                            .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      helper.buildSectionTitle("Application Fees"),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: applicationFeeGeneralCtrl,
                              labelText: "General",
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.currency_rupee,
                              validator: AppValidators.doubleTypeRequired,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              controller: applicationFeeObcCtrl,
                              labelText: "OBC",
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.currency_rupee,
                              validator: AppValidators.doubleTypeRequired,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      AppTextFormField(
                        controller: applicationFeeScStCtrl,
                        labelText: "SC/ST",
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.currency_rupee,
                        validator: AppValidators.doubleTypeRequired,
                        bottomPadding: 16,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
