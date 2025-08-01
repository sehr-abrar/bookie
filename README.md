# Moodie

## Table of Contents
- [Overview](#overview)
- [Product Spec](#product-spec)
- [Wireframes](#wireframes)
- [Schema](#schema)

---

## Overview

### Description
**Moodie** is a lightweight mood journaling app that helps users reflect on their emotional well-being with daily check-ins. Users can log how they're feeling using emoji or sliders, add a short journal entry, and view previous logs to track their emotional trends over time. Moodie encourages mindfulness and self-awareness in a minimal, aesthetic experience.

### App Evaluation

- **Category:** Health & Wellness / Lifestyle  
- **Mobile:** Uses persistent local storage (UserDefaults), emoji/sliders for mood input, and optionally push notifications and charts  
- **Story:** Offers a simple, effective way to support mental health and daily mindfulness practices  
- **Market:** Broad appeal for students, professionals, and anyone interested in journaling or mood tracking  
- **Habit:** Designed to be a daily-use app, forming a reflection habit with low effort  
- **Scope:** The MVP is simple to build (journal entry, storage, view past entries), with optional features to scale up later

---

## Product Spec

### 1. User Stories

#### ✅ Required Must-have Stories
- User can select their mood for the day (via emoji or slider)
- User can write a short note about their day
- User can save the entry and it persists across app launches
- User can view a scrollable list of past mood entries
- User can delete a mood entry

#### ✨ Optional Nice-to-have Stories
- User receives a daily reminder notification to log their mood
- User sees a "quote of the day" on the home screen
- User can view a visual summary (bar graph or calendar) of moods over time
- User can protect their journal with a passcode lock

---

### 2. Screen Archetypes

- **Home Screen**
  - Shows welcome text and today's mood status
  - Button to log today's mood
  - Optional: Daily quote

- **Add Entry Screen**
  - Select mood via emoji/slider
  - Text field for notes
  - Save button

- **Entries List Screen**
  - Scrollable list of mood entries
  - Each item shows date, mood emoji, and journal snippet
  - Swipe to delete

- **Stats Screen (Optional)**
  - Visual summary of past moods using a chart or calendar

- **Settings Screen (Optional)**
  - Toggle for daily reminder
  - Set or change passcode lock

---

### 3. Navigation

#### Tab Navigation (Tab to Screen)
- Home
- Entries
- Stats (optional)
- Settings (optional)

#### Flow Navigation (Screen to Screen)
- Home Screen  
  - ➡️ Add Entry Screen  
  - ➡️ Entries List Screen  
  - ➡️ Settings Screen (optional)

- Add Entry Screen  
  - ➡️ Save ➡️ Back to Home or Entries  

- Entries List  
  - ➡️ Entry Detail (optional modal)

- Stats Screen  
  - No further navigation (optional screen)

---

## Digital nWireframes

---

## Schema

### Models

### Networking

(No external APIs required unless adding quote of the day. If using local notifications or chart libraries, no backend requests are needed.)

