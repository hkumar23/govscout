import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';

enum JobType {
  permanent,
  contract,
  apprentice,
  internship,
  temporary,
}

enum WorkMode {
  online,
  offline,
  hybrid,
}

enum ApplicationMode {
  online,
  offline,
  both,
}

class Job {
  final String? id;
  final String title; // “Junior Engineer – PWD”
  final String department; // SSC, UPSC, Railways, Bank, PSU
  final String organization; // Indian Railways, SBI, DRDO
  final String category; // Defence, Banking, Teaching, Medical

  final String description;
  final int vacancies;
  final JobType jobType; // Permanent, Contract, Apprentice
  final WorkMode workMode; // Online, Offline, Hybrid
  final String? location; // State / Region
  final int? salaryMin;
  final int? salaryMax;
  final String payLevel; // 7th Pay Commission Level

  final int? minAge;
  final int? maxAge;
  final bool? ageRelaxationAllowed;
  final List<String> qualificationRequired; // 10th, 12th, ITI, Diploma, BTech
  final List<String> fieldOfStudyRequired; // IT, Civil, Mechanical
  final bool? experienceRequired;
  final int? minExperienceYears;

  final DateTime? applicationStartDate;
  final DateTime? applicationEndDate;
  final DateTime? examDate;
  final DateTime? resultDate;

  final ApplicationMode applicationMode; // Online / Offline
  final String? applicationLink;
  final String officialNotificationUrl;
  final String? officialWebsiteLink;
  final String? advtNumber;

  final int? applicationFeeGeneral;
  final int? applicationFeeObc;
  final int? applicationFeeScSt;

  final List<String> tags; // “Diploma”, “Female”, “Delhi”, “2025”
  final List<String> keywords;

  final List<String> savedByUserIds;
  final List<String> appliedByUserIds;
  final int viewsCount;

  final bool genderSpecific;
  final bool femaleOnly;

  final String postedByAdminId;
  final bool verified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  final Map<String, dynamic>? additionalData;

  Job({
    this.id,
    required this.title,
    required this.department,
    required this.organization,
    required this.category,
    required this.description,
    required this.vacancies,
    required this.jobType,
    required this.workMode,
    this.location,
    this.salaryMin,
    this.salaryMax,
    required this.payLevel,
    this.minAge,
    this.maxAge,
    this.ageRelaxationAllowed,
    this.qualificationRequired = const [],
    this.fieldOfStudyRequired = const [],
    this.experienceRequired,
    this.minExperienceYears,
    this.applicationStartDate,
    this.applicationEndDate,
    this.examDate,
    this.resultDate,
    required this.applicationMode,
    this.applicationLink,
    required this.officialNotificationUrl,
    this.officialWebsiteLink,
    this.advtNumber,
    this.applicationFeeGeneral,
    this.applicationFeeObc,
    this.applicationFeeScSt,
    this.tags = const [],
    this.keywords = const [],
    this.savedByUserIds = const [],
    this.appliedByUserIds = const [],
    this.viewsCount = 0,
    required this.genderSpecific,
    required this.femaleOnly,
    required this.postedByAdminId,
    required this.verified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.additionalData,
  });

  factory Job.fromJson(Map<String, dynamic> json, String jobId) {
    return Job(
      id: jobId,
      title: json[AppConstants.title],
      department: json[AppConstants.department],
      organization: json[AppConstants.organization],
      category: json[AppConstants.category],
      description: json[AppConstants.description],
      vacancies: json[AppConstants.vacancies] ?? 0,
      jobType: JobType.values.firstWhere(
        (e) => e.name.toString() == json[AppConstants.jobType],
        orElse: () => JobType.permanent,
      ),
      workMode: WorkMode.values.firstWhere(
        (e) => e.name.toString() == json[AppConstants.workMode],
        orElse: () => WorkMode.offline,
      ),
      location: json[AppConstants.location],
      salaryMin: json[AppConstants.salaryMin],
      salaryMax: json[AppConstants.salaryMax],
      payLevel: json[AppConstants.payLevel],
      minAge: json[AppConstants.minAge],
      maxAge: json[AppConstants.maxAge],
      ageRelaxationAllowed: json[AppConstants.ageRelaxationAllowed] ?? false,
      qualificationRequired:
          List<String>.from(json[AppConstants.qualificationRequired] ?? []),
      fieldOfStudyRequired:
          List<String>.from(json[AppConstants.fieldOfStudyRequired] ?? []),
      experienceRequired: json[AppConstants.experienceRequired],
      minExperienceYears: json[AppConstants.minExperienceYears],
      applicationStartDate: json[AppConstants.applicationStartDate] != null
          ? (json[AppConstants.applicationStartDate] as Timestamp).toDate()
          : null,
      applicationEndDate: json[AppConstants.applicationEndDate] != null
          ? (json[AppConstants.applicationEndDate] as Timestamp).toDate()
          : null,
      examDate: json[AppConstants.examDate] != null
          ? (json[AppConstants.examDate] as Timestamp).toDate()
          : null,
      resultDate: json[AppConstants.resultDate] != null
          ? (json[AppConstants.resultDate] as Timestamp).toDate()
          : null,
      applicationMode: ApplicationMode.values.firstWhere(
        (e) => e.name.toString() == json[AppConstants.applicationMode],
        orElse: () => ApplicationMode.online,
      ),
      applicationLink: json[AppConstants.applicationLink],
      officialNotificationUrl: json[AppConstants.officialNotificationUrl] ?? '',
      officialWebsiteLink: json[AppConstants.officialWebsiteLink],
      advtNumber: json[AppConstants.advtNumber],
      applicationFeeGeneral: json[AppConstants.applicationFeeGeneral],
      applicationFeeObc: json[AppConstants.applicationFeeObc],
      applicationFeeScSt: json[AppConstants.applicationFeeScSt],
      tags: List<String>.from(json[AppConstants.tags] ?? []),
      keywords: List<String>.from(json[AppConstants.keywords] ?? []),
      savedByUserIds:
          List<String>.from(json[AppConstants.savedByUserIds] ?? []),
      appliedByUserIds:
          List<String>.from(json[AppConstants.appliedByUserIds] ?? []),
      viewsCount: json[AppConstants.viewsCount] ?? 0,
      genderSpecific: json[AppConstants.genderSpecific] ?? false,
      femaleOnly: json[AppConstants.femaleOnly] ?? false,
      postedByAdminId: json[AppConstants.postedByAdminId],
      verified: json[AppConstants.verified],
      isActive: json[AppConstants.isActive],
      createdAt: (json[AppConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (json[AppConstants.updatedAt] as Timestamp).toDate(),
      additionalData:
          Map<String, dynamic>.from(json[AppConstants.additionalData] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.title: title,
      AppConstants.department: department,
      AppConstants.organization: organization,
      AppConstants.category: category,
      AppConstants.description: description,
      AppConstants.vacancies: vacancies,
      AppConstants.jobType: jobType.name,
      AppConstants.workMode: workMode.name,
      AppConstants.location: location,
      AppConstants.salaryMin: salaryMin,
      AppConstants.salaryMax: salaryMax,
      AppConstants.payLevel: payLevel,
      AppConstants.minAge: minAge,
      AppConstants.maxAge: maxAge,
      AppConstants.ageRelaxationAllowed: ageRelaxationAllowed,
      AppConstants.qualificationRequired: qualificationRequired,
      AppConstants.fieldOfStudyRequired: fieldOfStudyRequired,
      AppConstants.experienceRequired: experienceRequired,
      AppConstants.minExperienceYears: minExperienceYears,
      AppConstants.applicationStartDate: applicationStartDate != null
          ? Timestamp.fromDate(applicationStartDate!)
          : null,
      AppConstants.applicationEndDate: applicationEndDate != null
          ? Timestamp.fromDate(applicationEndDate!)
          : null,
      AppConstants.examDate:
          examDate != null ? Timestamp.fromDate(examDate!) : null,
      AppConstants.resultDate:
          resultDate != null ? Timestamp.fromDate(resultDate!) : null,
      AppConstants.applicationMode: applicationMode.name,
      AppConstants.applicationLink: applicationLink,
      AppConstants.officialNotificationUrl: officialNotificationUrl,
      AppConstants.officialWebsiteLink: officialWebsiteLink,
      AppConstants.advtNumber: advtNumber,
      AppConstants.applicationFeeGeneral: applicationFeeGeneral,
      AppConstants.applicationFeeObc: applicationFeeObc,
      AppConstants.applicationFeeScSt: applicationFeeScSt,
      AppConstants.tags: tags,
      AppConstants.keywords: keywords,
      AppConstants.savedByUserIds: savedByUserIds,
      AppConstants.appliedByUserIds: appliedByUserIds,
      AppConstants.viewsCount: viewsCount,
      AppConstants.genderSpecific: genderSpecific,
      AppConstants.femaleOnly: femaleOnly,
      AppConstants.postedByAdminId: postedByAdminId,
      AppConstants.verified: verified,
      AppConstants.isActive: isActive,
      AppConstants.createdAt: Timestamp.fromDate(createdAt),
      AppConstants.updatedAt: Timestamp.fromDate(updatedAt),
      AppConstants.additionalData: additionalData,
    };
  }
}
