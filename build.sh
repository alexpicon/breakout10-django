#!/usr/bin/env bash
set -o errexit

pip install -r requirements.txt

cd mysite
python manage.py collectstatic --noinput
python manage.py migrate
python manage.py shell <<'PY'
from main.models import Message
if not Message.objects.exists():
    Message.objects.create(text='Hello from Django MVC, deployed on Render!')
    Message.objects.create(text='Built for CPSC 5240 — Breakout #10')
    Message.objects.create(text='Visit /about/ to learn more')
PY
