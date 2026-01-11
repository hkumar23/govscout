import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:govscout/logic/blocs/job_management/job_management_event.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../data/models/job.model.dart';
import '../data/repositories/auth_repo.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/job_management/job_management_bloc.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserId = AuthRepository().currentUser!.uid;
    bool isJobSaved = widget.job.savedByUserIds.contains(currentUserId);
    bool isAdminView = BlocProvider.of<AuthBloc>(context).isAdminView!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          IconButton(
            icon: Icon(isJobSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              if (isJobSaved) {
                setState(() {
                  widget.job.savedByUserIds.remove(currentUserId);
                });

                BlocProvider.of<JobManagementBloc>(context).add(
                  UnsaveJobEvent(
                    widget.job.id!,
                    currentUserId,
                  ),
                );
              } else {
                setState(() {
                  widget.job.savedByUserIds.add(currentUserId);
                });
                BlocProvider.of<JobManagementBloc>(context).add(
                  SaveJobEvent(
                    widget.job.id!,
                    currentUserId,
                  ),
                );
              }
            },
          ),

          // IconButton(
          //   icon: const Icon(Icons.share),
          //   onPressed: () {
          //     // TODO: Share Job
          //   },
          // ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 16),
                  _sectionTitle("Job Description"),
                  _sectionText(widget.job.description),
                  _sectionTitle("Job Overview"),
                  _buildOverview(),
                  if (_hasDates()) ...[
                    _sectionTitle("Important Dates"),
                    _buildDates(),
                  ],
                  _sectionTitle("Salary & Pay"),
                  _buildSalary(),
                  _sectionTitle("Eligibility"),
                  _buildEligibility(),
                  _sectionTitle("Application Details"),
                  _buildApplicationDetails(),
                  if (_hasFees()) ...[
                    _sectionTitle("Application Fees"),
                    _buildFees(),
                  ],
                  if (_hasOtherDetails()) ...[
                    _sectionTitle("Other Details"),
                    _buildOtherDetails()
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
            if (!isAdminView &&
                (widget.job.applicationLink?.isNotEmpty ?? false))
              Align(
                alignment: isAdminView
                    ? Alignment.bottomCenter
                    : Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: isAdminView
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isAdminView)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            foregroundColor:
                                theme.colorScheme.onSecondaryContainer,
                            textStyle: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            GoRouter.of(context).push(
                              extra: widget.job,
                              AppRoutes.addUpdateJob,
                            );
                          },
                          child: const Text("Edit Job"),
                        ),
                      if (widget.job.applicationLink?.isNotEmpty ?? false)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.surface,
                            textStyle: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (widget.job.applicationLink == null) return;
                            final notificationUrl =
                                Uri.parse(widget.job.applicationLink!);
                            launchUrl(
                              notificationUrl,
                              mode: LaunchMode.inAppBrowserView,
                            );
                          },
                          child: const Text("Apply Now"),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.job.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.job.organization,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _chip(widget.job.category),
            _chip(widget.job.department),
            if (widget.job.location?.isNotEmpty ?? false)
              _chip(widget.job.location!),
          ],
        ),
      ],
    );
  }

  // ================= OVERVIEW =================
  Widget _buildOverview() {
    return _infoCard([
      _infoRow("Vacancies", widget.job.vacancies.toString()),
      _infoRow("Job Type", widget.job.jobType.name.toUpperCase()),
      _infoRow("Work Mode", widget.job.workMode.name.toUpperCase()),
      _infoRow("Pay Level", widget.job.payLevel),
      Chip(
        label: Text("Female Only"),
        color: WidgetStatePropertyAll<Color>(Colors.blue.withAlpha(50)),
      ),
    ]);
  }

  // ================= DATES =================
  Widget _buildDates() {
    return _infoCard([
      if (widget.job.applicationStartDate != null)
        _infoRow(
          "Application Start",
          _formatDate(widget.job.applicationStartDate!),
        ),
      if (widget.job.applicationEndDate != null)
        _infoRow(
          "Application End",
          _formatDate(widget.job.applicationEndDate!),
        ),
      if (widget.job.examDate != null)
        _infoRow("Exam Date", _formatDate(widget.job.examDate!)),
      if (widget.job.resultDate != null)
        _infoRow("Result Date", _formatDate(widget.job.resultDate!)),
    ]);
  }

  // ================= SALARY =================
  Widget _buildSalary() {
    String salaryText = "Not Disclosed";

    if (widget.job.salaryMin != null || widget.job.salaryMax != null) {
      salaryText =
          "₹${widget.job.salaryMin ?? 0} - ₹${widget.job.salaryMax ?? "As per rules"}";
    }

    return _infoCard([
      _infoRow("Salary", salaryText),
      _infoRow("Pay Level", widget.job.payLevel),
    ]);
  }

  // ================= ELIGIBILITY =================
  Widget _buildEligibility() {
    return _infoCard([
      if (widget.job.minAge != null)
        _infoRow(
          "Age Limit",
          "${widget.job.minAge} - ${widget.job.maxAge ?? "As per rules"}",
        ),
      _infoRow(
        "Age Relaxation",
        widget.job.ageRelaxationAllowed == true ? "Yes" : "No",
      ),
      if (widget.job.qualificationRequired.isNotEmpty)
        _infoRow(
          "Qualification",
          widget.job.qualificationRequired.join(", "),
        ),
      if (widget.job.fieldOfStudyRequired.isNotEmpty)
        _infoRow(
          "Field",
          widget.job.fieldOfStudyRequired.join(", "),
        ),
      if (widget.job.experienceRequired == true)
        _infoRow(
          "Experience",
          "${widget.job.minExperienceYears ?? 0} Years",
        ),
    ]);
  }

  // ================= APPLICATION =================
  Widget _buildApplicationDetails() {
    return _infoCard([
      _infoRow(
        "Application Mode",
        widget.job.applicationMode.name.toUpperCase(),
      ),
      // if (job.applicationLink != null) _infoRow("Apply Link", "Available"),
      _infoRow(
        "Notification",
        "View Official Notification",
        onTap: () async {
          final notificationUrl = Uri.parse(widget.job.officialNotificationUrl);
          launchUrl(
            notificationUrl,
            mode: LaunchMode.inAppBrowserView,
          );
        },
      ),
      if (widget.job.advtNumber != null)
        _infoRow("Advt No.", widget.job.advtNumber!),
    ]);
  }

  // ================= FEES =================
  Widget _buildFees() {
    return _infoCard([
      if (widget.job.applicationFeeGeneral != null)
        _infoRow("General", "₹${widget.job.applicationFeeGeneral}"),
      if (widget.job.applicationFeeObc != null)
        _infoRow("OBC", "₹${widget.job.applicationFeeObc}"),
      if (widget.job.applicationFeeScSt != null)
        _infoRow("SC/ST", "₹${widget.job.applicationFeeScSt}"),
    ]);
  }

  Widget _buildOtherDetails() {
    return _infoCard([
      if (widget.job.additionalData?[AppConstants.howToApply]?.isNotEmpty ??
          false)
        _infoRow("How to Apply?",
            widget.job.additionalData![AppConstants.howToApply]),
      if (widget.job.additionalData?[AppConstants.note]?.isNotEmpty ?? false)
        _infoRow("Note", widget.job.additionalData![AppConstants.note])
    ]);
  }

  bool _hasDates() {
    return widget.job.applicationStartDate != null ||
        widget.job.applicationEndDate != null ||
        widget.job.examDate != null ||
        widget.job.resultDate != null;
  }

  bool _hasFees() {
    return widget.job.applicationFeeGeneral != null ||
        widget.job.applicationFeeObc != null ||
        widget.job.applicationFeeScSt != null;
  }

  bool _hasOtherDetails() {
    return (widget.job.additionalData?[AppConstants.howToApply]?.isNotEmpty ??
            false) ||
        (widget.job.additionalData?[AppConstants.note]?.isNotEmpty ?? false);
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: const TextStyle(height: 1.5),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 6,
            child: InkWell(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: onTap == null ? null : Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }
}
