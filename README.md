# Bookie

## Table of Contents
- [Overview](#overview)
- [Product Spec](#product-spec)
- [Wireframes](#wireframes)

---

## Overview

### Description
**Bookie** is a streamlined personal book tracking app designed to help users organize and manage their reading lists. Users can add books with details such as title, author, reading status (e.g., To Read, Reading, Completed), notes, and favorites. Bookie enables users to track their reading progress, rate books, and keep a clean, intuitive record of their reading habits — making it easier to stay motivated and discover patterns over time.

### App Evaluation

- **Category:** Productivity / Lifestyle / Book Tracking  
- **Mobile:** Persistent local storage (e.g., UserDefaults or Core Data), interactive list management, rating system, filters and sorting  
- **Story:** Provides a simple, elegant way for readers to track and reflect on their reading journeys  
- **Market:** Appeals to book lovers, students, and anyone who wants to organize their personal reading lists  
- **Habit:** Encourages regular updating and review of reading progress, supporting goal setting and habit formation  
- **Scope:** MVP includes adding/removing books, updating status, notes, favorites, and rating, with room to expand to recommendations or social sharing

---

## Product Spec

### 1. User Stories

#### ✅ Required Must-have Stories
- [x] User can add a book with details (title, author, optional image, synopsis)
- [x] User can mark book status (To Read, Reading, Completed)
- [x] User can add notes or personal ratings to each book
- [x] User can mark/unmark favorites
- [x] User can view a scrollable list of all books
- [x] User can edit or delete a book entry

#### ✨ Optional Nice-to-have Stories
- [x] User can filter or sort the list by status or favorites
- [ ] User can view statistics like number of books read or currently reading
- [ ] User can get book recommendations based on current list (future feature)
- [ ] User can export or back up their book list
- [ ] User can receive reminders to continue reading

---

### 2. Screen Archetypes

- **Home Screen**
  - Overview of current reading status
  - Quick access to add a new book
  - Highlights favorites or recently updated books

- **Add/Edit Book Screen**
  - Form for entering title, author, status, notes, and rating
  - Save or cancel buttons

- **Book List Screen**
  - Scrollable list of books
  - Each item shows title, status, favorite icon, and rating
  - Swipe to delete or edit

---

### 3. Navigation

#### Tab Navigation (Tab to Screen)
- Home
- Book List

#### Flow Navigation (Screen to Screen)
- Home Screen  
  - ➡️ Add Book Screen  
  - ➡️ Book List Screen  

- Book List Screen  
  - ➡️ Detail Screen (optional)  
  - ➡️ Edit Book Screen

- Add/Edit Book Screen  
  - ➡️ Save ➡️ Back to Home or Book List  

---

## Wireframes

Lo-Fi wireframes can be found [here](https://www.figma.com/design/Nwt05poG5B7ORKuaYSl76o/Untitled?node-id=0-1&t=KOHURlkRhEFCCe1k-1).

---

## Sprint Video 

[YouTube Walkthrough](https://youtube.com/shorts/OtBm11uGMG8?feature=share)
