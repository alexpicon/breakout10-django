# Breakout 10 - Django + Salesforce

Alex Picon, CPSC 5240, May 6, 2026

---

## Part 1: Salesforce

The biggest thing Salesforce got right was timing. In 1999 enterprise CRM meant a Siebel install that cost millions, lived on your own servers, and broke every time you tried to upgrade it. Marc Benioff said you don't need any of that, you just need a browser and a subscription. The competition didn't take it seriously and called Salesforce "an ant at the picnic," which gave them a couple of years to lock in customers in a category they were basically inventing. The marketing helped too. The "No Software" campaign was loud, Dreamforce turned into a yearly event people actually wanted to go to, and the 1-1-1 philanthropy pledge gave the brand a story before they had revenue to back it up. The acquisitions later on (ExactTarget, Tableau, MuleSoft, Slack) and the AppExchange in 2005 turned Salesforce from one product into a platform other companies could build on, which is what really kept customers from leaving.

If I could give Benioff advice today, I'd push him on two things. The first is developer experience. Apex and Visualforce are great for Salesforce because they keep customers locked in, but they're awful for engineers because nobody learns Apex unless they have to, and that means the talent pool stays small and expensive. Pushing harder and earlier on Lightning Web Components, or really anything that looks like normal JavaScript, would have made it way easier to hire. The second is the trust story. The 2019 zero-tax-rate headlines and the Backpage lawsuit hurt the brand more than they had to, and the "Salesforce is too expensive" complaint from smaller customers has basically been free marketing for HubSpot for years. If they had been more public about pricing, acceptable use, and what they do with customer data, competitors wouldn't have such an easy time selling against them.

---

## Part 2: Speaker Feedback

The lecture on how Salesforce became dominant was good because it actually explained the strategy instead of just saying they were innovative. The slides walked through the history first, then the SaaS pivot, then the marketing moves (No Software, Dreamforce, 1-1-1, AppExchange), and finally the architecture and language stack. I liked that the architecture slide and the languages slide were in the same deck as the business strategy. A lot of classes treat strategy and code like two different topics, and this one made the point that the multi-tenant cloud architecture and the Apex/Visualforce stack are the reason Salesforce could scale at all. The languages slide was probably my favorite, because it makes it obvious why a Salesforce engineer's job looks nothing like a normal web dev job.

What I'd add is some context on what doesn't carry over. The Salesforce playbook worked in 1999 because cloud was new. In 2026 it isn't, so a startup trying to copy this strategy today has to find a different angle. A comparison with HubSpot or Microsoft Dynamics would help here, since right now the architecture slide kind of reads as "this is how SaaS works" instead of "this is how Salesforce did SaaS in 1999." The other thing I'd want is a quick take on the acquisitions list (Heroku, Tableau, Slack). The slide listed them but didn't really say which ones paid off and which ones are still question marks, and that would be useful for thinking about M&A in general. Other than that, it was one of the better lectures of the quarter.

---

## Part 3: Python/Django Lab

### a. Steps 1-4 - done

I'm on macOS instead of Ubuntu so I skipped the `apt` step and just used `python3 -m venv venv` directly. Everything else worked.

| Step | What I did | Result |
|---|---|---|
| 1. Environment | Made `Breakout10/`, set up venv, installed Django 6.0.5 + gunicorn, opened in VS Code | OK |
| 2. Project + App | `django-admin startproject mysite`, then `python manage.py startapp main` inside it | OK |
| 3. MVC | Added the `Message` model in `main/models.py`, registered it in `admin.py`, wrote the `home` view from the spec, and wired up URL routing in `mysite/urls.py`. Ran `makemigrations` and `migrate` | OK |
| 4. GitHub | Added `.gitignore` and `requirements.txt`, then `git init` / `commit` / `push` to a public repo | OK |

To run it locally:

```bash
cd Breakout10
source venv/bin/activate
cd mysite
python manage.py runserver
# http://127.0.0.1:8000/        -> message list
# http://127.0.0.1:8000/about/  -> About page
# http://127.0.0.1:8000/admin/  -> admin
```

I seeded three sample `Message` rows from the Django shell so the home view actually has something to loop over instead of returning an empty page.

### b. About page

Added a second URL (`/about/`) that maps to a new `about` view. The view renders `main/templates/main/about.html`, which describes what each layer of the project does (Model, View, Template, URL routing) and points at the actual file for each one. There's a small nav bar at the top to jump back to Home or Admin.

| File | What it shows |
|---|---|
| `screenshots/home.png` | `/` showing the seeded Message list |
| `screenshots/about.png` | `/about/` showing the styled About page |

### c. Extra credit - Render deploy

Live URL: https://breakout10-django.onrender.com

| Page | URL | Status |
|---|---|---|
| Home (message list) | https://breakout10-django.onrender.com/ | 200 |
| About | https://breakout10-django.onrender.com/about/ | 200 |

Deployed screenshots are in `screenshots/deployed-home.png` and `screenshots/deployed-about.png`.

#### Steps I followed

1. **Prepped settings.py for production.** Added a check for the `RENDER` env var. When that's set I turn `DEBUG` off, lock `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS` to the hostname Render injects in `RENDER_EXTERNAL_HOSTNAME`, and let `SECRET_KEY` be overridden by an env var. Also added WhiteNoise to `MIDDLEWARE` and set `STATIC_ROOT` so the About page CSS would actually load in prod.
2. **Wrote `build.sh`.** It runs `pip install -r requirements.txt`, then `cd mysite && collectstatic --noinput && migrate`, then a small Python block that seeds three messages on first deploy so the home page isn't empty. Made it executable with `chmod +x build.sh`.
3. **Pushed to GitHub.** Made a public repo at `alexpicon/breakout10-django`, then `git init -b main`, `git add -A`, commit, push.
4. **Created the Render Web Service.** From the dashboard: **+ New** -> **Web Service**. The first time I tried, the GitHub tab didn't show my repo because Render's GitHub App only sees repos you specifically allow. I switched to the **Public Git Repository** tab and pasted the repo URL, which was way faster. Settings I used:
   - Name: `breakout10-django`
   - Language: Python 3
   - Branch: `main`
   - Region: Oregon (US West)
   - Build Command: `./build.sh`
   - Start Command: `cd mysite && gunicorn mysite.wsgi`
   - Instance Type: Free
5. **Waited for the build.** Took about 2 minutes. Logs showed pip installing, collectstatic copying 130 static files, migrations running, the seed block creating the messages, then gunicorn starting up. Green "Live" badge appeared.
6. **Verified.** Both `/` and `/about/` returned 200, and the home page showed the seeded messages including "Hello from Django MVC, deployed on Render!"

#### Stuff I had to deal with

- Render auto-filled the Build and Start commands wrong because it detected Django and guessed `pip install -r requirements.txt` and `gunicorn app:app`. Had to overwrite both.
- Free tier asks for a credit card even though it's free, which threw me off. Used a virtual card with a low limit so it can't get charged.
- Free tier instances spin down after 15 minutes of inactivity, so the first request after a while takes 50ish seconds to wake up. Fine for a demo, would not work for a real site.
