import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/job.model.dart';
import '../widgets/job_item.dart';

class JobsFeedScreen extends StatelessWidget {
  const JobsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsData = [
      {
        "id": "job_001",
        "title": "Junior Engineer - PWD",
        "department": "State Govt",
        "organization": "Delhi Public Works Department",
        "category": "Engineering",
        "description":
            "Recruitment for Junior Engineer (Civil) for Delhi PWD Department.",
        "vacancies": 120,
        "jobType": "Permanent",
        "workMode": "Offline",
        "location": "Delhi",
        "salaryMin": 35400,
        "salaryMax": 112400,
        "payLevel": "Level 6",
        "minAge": 18,
        "maxAge": 27,
        "ageRelaxationAllowed": true,
        "qualificationRequired": ["Diploma", "BTech"],
        "fieldOfStudyRequired": ["Civil"],
        "experienceRequired": false,
        "minExperienceYears": 0,
        "applicationStartDate": Timestamp.now(),
        "applicationEndDate": Timestamp.now(),
        "examDate": Timestamp.now(),
        "resultDate": null,
        "applicationMode": "Online",
        "applicationLink": "https://pwd.delhi.gov.in",
        "officialNotificationPdfUrl":
            "https://pwd.delhi.gov.in/je_notification.pdf",
        "advtNumber": "PWD/JE/2025/01",
        "applicationFeeGeneral": 1000,
        "applicationFeeObc": 750,
        "applicationFeeScSt": 500,
        "tags": ["Delhi", "Diploma", "Civil", "2025"],
        "keywords": ["junior engineer", "pwd", "civil engineering"],
        "savedByUserIds": [],
        "appliedByUserIds": [],
        "viewsCount": 2450,
        "genderSpecific": false,
        "femaleOnly": false,
        "postedByAdminId": "admin_001",
        "verified": true,
        "isActive": true,
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now()
      },
      {
        "id": "job_002",
        "title": "Staff Nurse - AIIMS",
        "department": "Health मंत्रालय",
        "organization": "AIIMS Delhi",
        "category": "Medical",
        "description":
            "Staff Nurse recruitment for All India Institute of Medical Sciences.",
        "vacancies": 220,
        "jobType": "Permanent",
        "workMode": "Offline",
        "location": "Delhi",
        "salaryMin": 44900,
        "salaryMax": 142400,
        "payLevel": "Level 7",
        "minAge": 21,
        "maxAge": 35,
        "ageRelaxationAllowed": true,
        "qualificationRequired": ["BSc Nursing", "GNM"],
        "fieldOfStudyRequired": ["Nursing"],
        "experienceRequired": true,
        "minExperienceYears": 2,
        "applicationStartDate": Timestamp.now(),
        "applicationEndDate": Timestamp.now(),
        "examDate": Timestamp.now(),
        "resultDate": null,
        "applicationMode": "Online",
        "applicationLink": "https://aiims.edu/nurse",
        "officialNotificationPdfUrl":
            "https://aiims.edu/nurse_notification.pdf",
        "advtNumber": "AIIMS/NURSE/2025/02",
        "applicationFeeGeneral": 1500,
        "applicationFeeObc": 1200,
        "applicationFeeScSt": 800,
        "tags": ["Medical", "Nurse", "Delhi"],
        "keywords": ["staff nurse", "aiims nurse", "nursing job"],
        "savedByUserIds": [],
        "appliedByUserIds": [],
        "viewsCount": 4320,
        "genderSpecific": false,
        "femaleOnly": false,
        "postedByAdminId": "admin_002",
        "verified": true,
        "isActive": true,
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now()
      },
      {
        "id": "job_003",
        "title": "Constable (GD)",
        "department": "SSC",
        "organization": "Central Armed Police Forces",
        "category": "Defence",
        "description":
            "Recruitment for Constable (GD) in CAPF forces across India.",
        "vacancies": 26000,
        "jobType": "Permanent",
        "workMode": "Offline",
        "location": "Pan India",
        "salaryMin": 21700,
        "salaryMax": 69100,
        "payLevel": "Level 3",
        "minAge": 18,
        "maxAge": 23,
        "ageRelaxationAllowed": true,
        "qualificationRequired": ["10th"],
        "fieldOfStudyRequired": [],
        "experienceRequired": false,
        "minExperienceYears": 0,
        "applicationStartDate": Timestamp.now(),
        "applicationEndDate": Timestamp.now(),
        "examDate": Timestamp.now(),
        "resultDate": null,
        "applicationMode": "Online",
        "applicationLink": "https://ssc.nic.in",
        "officialNotificationPdfUrl": "https://ssc.nic.in/gd2025.pdf",
        "advtNumber": "SSC/GD/2025",
        "applicationFeeGeneral": 100,
        "applicationFeeObc": 100,
        "applicationFeeScSt": 0,
        "tags": ["Defence", "10th Pass", "CAPF"],
        "keywords": ["ssc gd", "constable gd", "defence job"],
        "savedByUserIds": [],
        "appliedByUserIds": [],
        "viewsCount": 18950,
        "genderSpecific": false,
        "femaleOnly": false,
        "postedByAdminId": "admin_001",
        "verified": true,
        "isActive": true,
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now(),
      }
    ];

    final jobs = jobsData.map((jobJson) {
      return Job.fromJson(jobJson, jobJson['id'] as String);
    }).toList();

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];

        return JobItem(
          job: job,
          // isSaved: job.savedByUserIds.contains(currentUserId),
          isSaved: false,
          onTap: () {
            // Open job detail screen
          },
          onSaveTap: () {
            // Save / Unsave job
          },
        );
      },
    );
  }
}
