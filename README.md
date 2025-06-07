# CourseTutor API

A simple Ruby on Rails API-only application to manage **Courses** and their **Tutors**.

- A **Course** can have many tutors.
- A **Tutor** belongs to exactly one course.

---

## Features

- Create courses along with associated tutors in a single API call.
- List all courses with their tutors.
- Validation and associations enforced at the model level.
- Fully tested with RSpec, FactoryBot, and Shoulda Matchers.

---

## Tech Stack

- Ruby on Rails (API mode)
- SQLite3 (default database)
- RSpec for testing
- FactoryBot for test data
- Shoulda Matchers for concise model specs

---

## Getting Started

### Prerequisites

- Ruby 3.2.6
- Rails 8.0.2
- Bundler

---

### Setup

```bash
# Clone repo
git clone https://github.com/rajneeshsharma9/course-hub.git
cd course-hub

# Install dependencies
bundle install

# Set up database
rails db:create db:migrate

# Run tests (optional but recommended)
bundle exec rspec
