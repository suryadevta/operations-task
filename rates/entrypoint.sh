#!/bin/sh
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USERNAME < rates.sql
gunicorn -b :3000 wsgi