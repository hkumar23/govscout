import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../data/models/job.model.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/job_management/job_management_bloc.dart';
import '../../logic/blocs/job_management/job_management_event.dart';

class JobItem extends StatefulWidget {
  final Job job;
  final String currentUserId;

  const JobItem({
    super.key,
    required this.job,
    required this.currentUserId,
  });

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isSaved = widget.job.savedByUserIds.contains(widget.currentUserId);
    final appColors = AppColors(context);

    return InkWell(
      onTap: () {
        GoRouter.of(context).push(
          extra: {
            AppConstants.job: widget.job,
            // AppConstants.isAdminView:
            //     BlocProvider.of<AuthBloc>(context).isAdminView,
          },
          AppRoutes.jobDetails,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appColors.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ─── TITLE + SAVE ───
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.job.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    if (isSaved) {
                      setState(() {
                        widget.job.savedByUserIds.remove(widget.currentUserId);
                      });

                      BlocProvider.of<JobManagementBloc>(context).add(
                        UnsaveJobEvent(
                          widget.job.id!,
                          widget.currentUserId,
                        ),
                      );
                    } else {
                      setState(() {
                        widget.job.savedByUserIds.add(widget.currentUserId);
                      });
                      BlocProvider.of<JobManagementBloc>(context).add(
                        SaveJobEvent(
                          widget.job.id!,
                          widget.currentUserId,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 3),

            /// ─── ORGANIZATION ───
            Text(
              widget.job.organization,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),

            const SizedBox(height: 12),

            /// ─── INFO ROW ───
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                _infoChip(Icons.category, widget.job.category),
                if (widget.job.location?.isNotEmpty ?? false)
                  _infoChip(Icons.location_on, widget.job.location ?? "N/A"),
                if (widget.job.salaryMin != null ||
                    widget.job.salaryMax != null)
                  _infoChip(
                    Icons.currency_rupee,
                    "${widget.job.salaryMin ?? 'N/A'} - ${widget.job.salaryMax ?? 'N/A'}",
                  ),
                if (widget.job.femaleOnly)
                  _infoChip(Icons.female, "Female Only")
              ],
            ),

            const SizedBox(height: 10),

            /// ─── DEADLINE ───
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.redAccent),
                const SizedBox(width: 6),
                Text(
                  "Last date: ${_formatDate(widget.job.applicationEndDate)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ─── CHIP BUILDER ───
  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  /// ─── DATE FORMATTER ───
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
