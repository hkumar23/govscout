import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/job.model.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Save Job
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share Job
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _sectionTitle("Job Description"),
            _sectionText(job.description),
            _sectionTitle("Job Overview"),
            _buildOverview(),
            _sectionTitle("Important Dates"),
            _buildDates(),
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
            const SizedBox(height: 80),
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
          job.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          job.organization,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _chip(job.category),
            _chip(job.department),
            if (job.location?.isNotEmpty ?? false) _chip(job.location!),
          ],
        ),
      ],
    );
  }

  // ================= OVERVIEW =================

  Widget _buildOverview() {
    return _infoCard([
      _infoRow("Vacancies", job.vacancies.toString()),
      _infoRow("Job Type", job.jobType.name.toUpperCase()),
      _infoRow("Work Mode", job.workMode.name.toUpperCase()),
      _infoRow("Pay Level", job.payLevel),
      Chip(
        label: Text("Female Only"),
        color: WidgetStatePropertyAll<Color>(Colors.blue.withAlpha(50)),
      ),
    ]);
  }

  // ================= DATES =================

  Widget _buildDates() {
    return _infoCard([
      _infoRow(
        "Application Start",
        _formatDate(job.applicationStartDate),
      ),
      _infoRow(
        "Application End",
        _formatDate(job.applicationEndDate),
      ),
      if (job.examDate != null)
        _infoRow("Exam Date", _formatDate(job.examDate!)),
      if (job.resultDate != null)
        _infoRow("Result Date", _formatDate(job.resultDate!)),
    ]);
  }

  // ================= SALARY =================

  Widget _buildSalary() {
    String salaryText = "Not Disclosed";

    if (job.salaryMin != null || job.salaryMax != null) {
      salaryText =
          "₹${job.salaryMin ?? 0} - ₹${job.salaryMax ?? "As per rules"}";
    }

    return _infoCard([
      _infoRow("Salary", salaryText),
      _infoRow("Pay Level", job.payLevel),
    ]);
  }

  // ================= ELIGIBILITY =================

  Widget _buildEligibility() {
    return _infoCard([
      if (job.minAge != null)
        _infoRow(
          "Age Limit",
          "${job.minAge} - ${job.maxAge ?? "As per rules"}",
        ),
      _infoRow(
        "Age Relaxation",
        job.ageRelaxationAllowed == true ? "Yes" : "No",
      ),
      if (job.qualificationRequired.isNotEmpty)
        _infoRow(
          "Qualification",
          job.qualificationRequired.join(", "),
        ),
      if (job.fieldOfStudyRequired.isNotEmpty)
        _infoRow(
          "Field",
          job.fieldOfStudyRequired.join(", "),
        ),
      if (job.experienceRequired == true)
        _infoRow(
          "Experience",
          "${job.minExperienceYears ?? 0} Years",
        ),
    ]);
  }

  // ================= APPLICATION =================

  Widget _buildApplicationDetails() {
    return _infoCard([
      _infoRow(
        "Application Mode",
        job.applicationMode.name.toUpperCase(),
      ),
      // if (job.applicationLink != null) _infoRow("Apply Link", "Available"),
      _infoRow(
        "Notification",
        "View Official Notification",
        onTap: () async {
          final notificationUrl = Uri.parse(job.officialNotificationUrl);
          launchUrl(
            notificationUrl,
            mode: LaunchMode.inAppBrowserView,
          );
        },
      ),
      if (job.advtNumber != null) _infoRow("Advt No.", job.advtNumber!),
    ]);
  }

  // ================= FEES =================

  Widget _buildFees() {
    return _infoCard([
      if (job.applicationFeeGeneral != null)
        _infoRow("General", "₹${job.applicationFeeGeneral}"),
      if (job.applicationFeeObc != null)
        _infoRow("OBC", "₹${job.applicationFeeObc}"),
      if (job.applicationFeeScSt != null)
        _infoRow("SC/ST", "₹${job.applicationFeeScSt}"),
    ]);
  }

  bool _hasFees() {
    return job.applicationFeeGeneral != null ||
        job.applicationFeeObc != null ||
        job.applicationFeeScSt != null;
  }

  // ================= BOTTOM BAR =================

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Open applicationLink or officialNotificationUrl
          },
          child: const Text("Apply Now"),
        ),
      ),
    );
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
