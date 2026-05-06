# Breakout 10 — Django + Salesforce

Alex Picon, CPSC 5240, May 6, 2026

---

## Part 1: Salesforce

What Salesforce did right was bet on a delivery model the rest of the industry dismissed. In 1999, enterprise CRM meant a million-dollar Siebel install, on-prem servers, and a long upgrade cycle. Marc Benioff's bet was that a browser and an internet connection were enough — no install, no hardware, monthly subscription. Siebel called them "an ant at the picnic" and Salesforce had a multi-year head start in a category they were defining. They reinforced that with three plays: the "No Software" guerrilla marketing (including showing up to protest Siebel's own conference), Dreamforce as an annual cultural moment, and the 1-1-1 philanthropy pledge made when there was nothing to give yet. Then in 2005 they shipped AppExchange and turned the product into a platform other companies could build on, which is what actually locked customers in. Acquisitions (ExactTarget, Tableau, MuleSoft, Slack) extended the surface without abandoning the SaaS thesis, and the multi-tenant cloud architecture on top of Oracle let them scale economically while keeping each customer isolated through metadata, Apex, and Visualforce.

If I could go back and talk to Benioff, I'd push him on two things. First, fix developer ergonomics earlier. Apex and Visualforce are a moat, but they're also the reason the Salesforce talent pool is permanently thin — every new engineer learns JavaScript and Python before Apex, so customers pay a premium for scarce Salesforce devs. Going harder on Lightning Web Components and standards-based JavaScript years sooner would have widened the pipeline of people willing to build on the platform. Second, get ahead of the trust story before regulators force it. The 2019 zero-effective-tax-rate headline and the Backpage.com lawsuit both hurt the brand more than they had to, and the steady "Salesforce is too expensive" complaint from mid-market customers has been free advertising for HubSpot. Published acceptable-use enforcement, simpler pricing tiers, and clear AI data-handling commitments would have made it harder for competitors to position themselves as the friendlier alternative.

---

## Part 2: Speaker Feedback

The lecture on how Salesforce became dominant was useful because it tied the dominance back to specific moves instead of waving at "good execution." The structure was clean: brief history, the SaaS pivot, the marketing and platform plays (No Software, Dreamforce, 1-1-1, AppExchange), then the architecture (multi-tenant cloud on Oracle, metadata-driven runtime, Apex + Visualforce) and the language stack (Java, Apex, JavaScript/LWC, SQL, HTML/CSS, Aura). Pairing the business strategy with the technical stack on the same deck is the right call for a software engineering class — it makes the connection between business model and architecture explicit. The "Languages" slide in particular was a payoff: it shows why a Salesforce engineer's day-to-day looks different from a generic web developer's, and why the proprietary surface is both a moat and a hiring constraint.

The thing I'd add is one slide on failure modes. The Salesforce playbook worked in 1999 because cloud was a real differentiator; in 2026 it isn't, so a SaaS startup copying this strategy today needs a different wedge. A side-by-side with HubSpot's microservices stack or Dynamics' Microsoft-ecosystem play would also help, because right now the architecture slide reads like "this is how SaaS works" instead of "this was Salesforce's 1999 answer." Last thing — the acquisitions list (Heroku, Tableau, Slack) was set up but not graded. A quick scorecard of which acquisitions paid off and which are still question marks would turn it from a list into a decision-making framework. Overall it was one of the more concrete strategy-meets-architecture lectures of the quarter.

---

## Part 3: Python/Django Lab

### a. Steps 1–4 — done

Setup ran on macOS instead of Ubuntu, so I skipped the `apt` step and used `python3 -m venv venv` directly. Everything else from steps 1–4 worked.

| Step | What I did | Result |
|---|---|---|
| 1. Environment | Created `Breakout10/`, set up venv, installed Django 6.0.5 and gunicorn, opened in VS Code | ✅ |
| 2. Project + App | `django-admin startproject mysite`, then `python manage.py startapp main` inside `mysite/` | ✅ |
| 3. MVC | Added `Message` model in `main/models.py`, registered it in `admin.py`, wrote the `home` view exactly as in the spec, wired URL routing in `mysite/urls.py`. Ran `makemigrations` and `migrate` | ✅ |
| 4. GitHub | `.gitignore` and `requirements.txt` are in the repo root, ready for `git init` → `commit` → `push` | ✅ |

To run it locally:

```bash
cd Breakout10
source venv/bin/activate
cd mysite
python manage.py runserver
# http://127.0.0.1:8000/        → message list
# http://127.0.0.1:8000/about/  → About page
# http://127.0.0.1:8000/admin/  → admin
```

Seeded three sample `Message` rows from the Django shell to confirm the home view actually loops over real DB data instead of returning a hardcoded string.

### b. About page

Added a second URL (`/about/`) mapped to a new `about` view that renders `main/templates/main/about.html`. The page describes the project, maps each layer (Model, View, Template, URL routing) onto a real file in the repo, and has a small nav back to Home and Admin.

| File | Purpose |
|---|---|
| `screenshots/home.png` | `/` rendering the seeded Message list |
| `screenshots/about.png` | `/about/` rendering the styled About page |

### c. Extra credit

(See separate write-up if I get to the Render deploy.)
