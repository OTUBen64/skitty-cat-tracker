# Skitty – Cat Feeding Tracker

**Course Major Project – Proposal (Phase 1)**  
**Student:** Ben Walsh (Solo project with instructor approval)  
**Date:** Sept 21, 2025  

---

## Project Overview
Skitty is a Flutter mobile app designed to prevent double-feeding or missed feedings for a household cat. The app provides a shared, real-time feeding log, reminders, and insights for family members.  

Core functionality includes:  
- Multiple screens and navigation (Home, History, Statistics, Settings, Onboarding)  
- Dialogs, pickers, snackbars, and notifications  
- Local data storage with potential cloud sync  
- A simple HTTP request for app configuration/help content  

Extra enhancements (if time permits):  
- Push notifications via Firebase  
- Cloud syncing across devices  
- Barcode scanning for food items  
- Geolocation-based reminders  

---

## Responsibilities
- **Ben Walsh (solo)**: Full-stack development (requirements, UI/UX, Flutter codebase, testing, documentation, demo).

---

## Deliverables for Proposal Stage
- Full written proposal (see `/docs/Skitty_Project_Proposal.docx`)  
- UML/architecture design (included in proposal)  
- UI mockups (Figma & Word version)  
- Slack channel creation: `#skitty-app-ben`  

---

## Tech Stack
- **Flutter (Dart)** with Riverpod, go_router  
- Local storage: sqflite / hive  
- Notifications: local_notifications, FCM (optional)  
- Charts: fl_chart  
- HTTP: http package  

---

## Milestones
- **W3:** Proposal, scaffold project, set up navigation  
- **W5:** Storage + Feed flow, History screen, local notifications  
- **W8:** Statistics, settings, polish, tests  
- **W9:** Feature freeze, QA, refactor  
- **Final:** Extra enhancements + demo  

