from flask import Flask, render_template, request, redirect, url_for, g
import psycopg2
from flask.cli import with_appcontext
import click
import os

app = Flask(__name__)

DATABASE_URL = 'postgresql://admin:admin@database:5432/db'

# Function to establish a database connection
def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = psycopg2.connect(DATABASE_URL)
    return db

# Function to create the database table if not exists
def create_table():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS notes (
            id SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            content TEXT NOT NULL
        );
    ''')
    print('Database table notes created')
    conn.commit()

# Function to close the database connection when the app is closed
@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

# Initialize the database
def init_db():
    print('Initializing database..')
    with app.app_context():
        create_table()

# Custom CLI command to initialize the database (if you want to initialize via cli):
@click.command('init-db')
@with_appcontext
def init_db_command():
    """Initialize the database."""
    init_db()
    click.echo('Initialized the database.')

# Register the custom CLI command
app.cli.add_command(init_db_command)


# Route to display all notes
@app.route('/')
def index():
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM notes ORDER BY id DESC')
    notes = cursor.fetchall()
    return render_template('index.html', notes=notes)

# Route to add a new note
@app.route('/add', methods=['POST'])
def add_note():
    title = request.form['title']
    content = request.form['content']
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO notes (title, content) VALUES (%s, %s)', (title, content))
    conn.commit()
    return redirect(url_for('index'))

# initialize database within the program (not via cli):
init_db()

# Run the application
if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True, port=80)
