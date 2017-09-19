---
title: "Flask Quick Start Guide"
date: 2017-09-10T15:47:02+08:00
tags: [ "Development" ]
categories: [ "Python" ]
draft: true
---

#Flask Quickstart
## Requirements
- Python
- Pip
- virtualenv
- Flask : a web development framework
- Werkzeug：a toolkit for WSGI
- Jinja2：renders templates

## virtualenv：multiple side-by-side installations of Python
- 安裝：pip install virtualenv
- 基本使用方式：

```
### 先建立專案資料夾
mkdir myproject
cd myproject
### 初始化
virtualenv env
### activate the corresponding environment
. venv/bin/activate
or
venv\scripts\activate
### 這時候再裝Flask
pip install Flask
### 回到實際環境
deactivate
### 若因為目錄搬移或更名 需重新locate
cd /path/to/your_project_new_dir
virtualenv --relocatable your_virtualenv_name
```


## 建立第一個app(記得啟動venv), save it as hello.py

```
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello_world():
    return 'Hello, World!'
```

# 執行
```
# Unix Like:
export FLASK_APP=hello.py
python -m flask run
 * Running on http://127.0.0.1:5000/

# Windows:
set FLASK_APP=hello.py
python -m flask run --host=0.0.0.0
* Running on http://127.0.0.1:5000/

# Debug Mode:
# export FLASK_DEBUG=1
```

## Routing
- beautiful URLs
- 程式範例：
```
    @app.route('/')
    def index():
        return 'Index Page'

    @app.route('/hello')
    def hello():
        return 'Hello, World'
```

## Variable Rules
- add variable parts to a URL
- ==string==     accepts any text without a slash (the default)
- ==int==     accepts integers
- ==float==     like int but for floating point values
- ==path==     like the default but also accepts slashes
- ==any==     matches one of the items provided
- ==uuid==     accepts UUID strings

```
@app.route('/user/<username>')
def show_user_profile(username):
# show the user profile for that user
return 'User %s' % username

@app.route('/post/<int:post_id>')
def show_post(post_id):
# show the post with the given id, the id is an integer
return 'Post %d' % post_id
```

## Unique URLs / Redirection Behavior 有斜線跟沒斜線的差異
- helps search engines avoid indexing the same page twice
- 有斜線當網址輸入/projects or /projects/ 都會看的到相同結果(will cause Flask to redirect to the canonical URL with the trailing slash)

```
@app.route('/projects/')
def projects():
return 'The project page'

## 沒斜線當輸入/about看的到結果，輸入/about/ 會顯示Not Found
@app.route('/about')
def about():
    return 'The about page'
```

## URL Building
- build a URL to a specific function using url_for() function
- 好處
    Reversing is often more descriptive than hard-coding the URLs. More importantly, it allows you to change URLs in one go, without having to remember to change URLs all over the place.
    URL building will handle escaping of special characters and Unicode data transparently for you, so you don’t have to deal with them.
    If your application is placed outside the URL root (say, in /myapplication instead of /), url_for() will handle that properly for you.

- examples:

```
>>> from flask import Flask, url_for
>>> app = Flask(__name__)
>>> @app.route('/')
... def index(): pass
...
>>> @app.route('/login')
... def login(): pass
...
>>> @app.route('/user/<username>')
... def profile(username): pass
...
>>> with app.test_request_context():
...  print url_for('index')
...  print url_for('login')
...  print url_for('login', next='/')
...  print url_for('profile', username='John Doe')
...
/
/login
/login?next=/
/user/John%20Doe
```

## HTTP Methods
- By default, a route only answers to GET requests
examples:

```
from flask import request
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        do_the_login()
    else:
        show_the_login_form()
```

- GET: The browser tells the server to just get the information stored on that page and send it. This is probably the most common method.
- HEAD: The browser tells the server to get the information, but it is only interested in the headers, not the content of the page. An application is supposed to handle that as if a GET request was received but to not deliver the actual content. In Flask you don’t have to deal with that at all, the underlying Werkzeug library handles that for you.
- POST: The browser tells the server that it wants to post some new information to that URL and that the server must ensure the data is stored and only stored once. This is how HTML forms usually transmit data to the server.
- PUT: Similar to POST but the server might trigger the store procedure multiple times by overwriting the old values more than once. Now you might be asking why this is useful, but there are some good reasons to do it this way. Consider that the connection is lost during transmission: in this situation a system between the browser and the server might receive the request safely a second time without breaking things. With POST that would not be possible because it must only be triggered once.
- DELETE: Remove the information at the given location.
- OPTIONS: Provides a quick way for a client to figure out which methods are supported by this URL. Starting with Flask 0.6, this is implemented for you automatically.

## Static Files
To generate URLs for static files, use the special 'static' endpoint name:
url_for('static', filename='style.css')
The file has to be stored on the filesystem as static/style.css.

## Rendering Templates
- 用python產生HTML一點也不有趣而且是個累贅，所以Flask使用Jinja2 template engine來處理HTML
- 也可避免自己要做HTML escaping來維持App的安全
- use the render_template method
- a simple example of how to render a template:

```
from flask import render_template
@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
```

- Here is an example template:

```
<!doctype html>
<title>Hello from Flask</title>
{% if name %}
  <h1>Hello {{ name }}!</h1>
{% else %}
  <h1>Hello, World!</h1>
{% endif %}
```

### Flask will look for templates in the templates folder. So if your application is a module, this folder is next to that module, if it’s a package it’s actually inside your package:

```
Case 1: a module:
/application.py
/templates
    /hello.html

Case 2: a package:
/application
    /__init__.py
    /templates
        /hello.html
```

## The Request Object
- request object most common operations

```
from flask import request
@app.route('/login', methods=['POST', 'GET'])
def login():
    error = None
    if request.method == 'POST':
        if valid_login(request.form['username'], request.form['password']):
            return log_the_user_in(request.form['username'])
    else:
        error = 'Invalid username/password'
```

    # the code below is executed if the request method was GET or the credentials were invalid return render_template('login.html', error=error)
    #To access parameters submitted in the URL (?key=value) you can use the args attribute:
    searchword = request.args.get('key', '')

## File Uploads
- set the enctype="multipart/form-data" attribute on your HTML form
- 上傳的檔案可儲存在memory或filesystem
- it also has a save() method that allows you to store that file on the filesystem

```
from flask import request

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['the_file']
        f.save('/var/www/uploads/uploaded_file.txt')
```

- 想取得檔案在client端為上傳之前的檔名可以存取 filename attribute，然而這是有可能被偽造的
- 如果你想使用client端為上傳之前的檔名，來存放到server上透過Werkzeug 提供的 secure_filename() function

```
from flask import request
from werkzeug.utils import secure_filename

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
if request.method == 'POST':
    f = request.files['the_file']
    f.save('/var/www/uploads/' + secure_filename(f.filename))
```

## Cookies
- Reading cookies:

```
from flask import request

@app.route('/')
def index():
    username = request.cookies.get('username')
    # use cookies.get(key) instead of cookies[key] to not get a
    # KeyError if the cookie is missing.
```

- Storing cookies:

```
from flask import make_response

@app.route('/')
def index():
    resp = make_response(render_template(...))
    resp.set_cookie('username', 'the username')
    return resp
```

## Redirects and Errors
- To redirect a user to another endpoint, use the redirect() function
- To abort a request early with an error code, use the abort() function

```
from flask import abort, redirect, url_for

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/login')
def login():
    abort(401)
    this_is_never_executed()
```

## customize the error page, you can use the errorhandler() decorator

```
from flask import render_template

@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html'), 404

```

## About Responses
- return value from a view function is automatically converted into a response object
- The logic that Flask applies to converting return values into response objects is as follows
- If a response object of the correct type is returned it’s directly returned from the view.
- If it’s a string, a response object is created with that data and the default parameters.
- If a tuple is returned the items in the tuple can provide extra information. Such tuples have to be in the form (response, status, headers) or (response, headers) where at least one item has to be in the tuple. The status value will override the status code and headers can be a list or dictionary of additional header values.
- If none of that works, Flask will assume the return value is a valid WSGI application and convert that into a response object.

##get hold of the resulting response object inside the view use the make_response() function
Imagine you have a view like this:

```
@app.errorhandler(404)
def not_found(error):
    return render_template('error.html'), 404
```

You just need to wrap the return expression with make_response() and get the response object to modify it, then return it:

```
@app.errorhandler(404)
def not_found(error):
    resp = make_response(render_template('error.html'), 404)
    resp.headers['X-Something'] = 'A value'
    return resp
```

## Sessions
- allows you to store information specific to a user from one request to the next
- implemented on top of cookies for you and signs the cookies cryptographically
- user could look at the contents of your cookie but not modify it
- examples:

```
from flask import Flask, session, redirect, url_for, escape, request

app = Flask(__name__)

@app.route('/')
def index():
    if 'username' in session:
        return 'Logged in as %s' % escape(session['username'])
    return 'You are not logged in'

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form action="" method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))

    # set the secret key.  keep this really secret:
    app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'
```

### How to generate good secret keys in python

```
import os
os.urandom(24)
```

### About cookie-base sessions size
*
A note on cookie-based sessions: Flask will take the values you put into the session object and serialize them into a cookie. If you are finding some values do not persist across requests, cookies are indeed enabled, and you are not getting a clear error message, check the size of the cookie in your page responses compared to the size supported by web browsers.
*

## Logging
*
The attached logger is a standard logging Logger, so head over to the official logging documentation for more information.
*

```
app.logger.debug('A value for debugging')
app.logger.warning('A warning occurred (%d apples)', 42)
app.logger.error('An error occurred')
```

## Hooking in WSGI Middlewares
- If you want to add a WSGI middleware to your application you can wrap the internal WSGI application. For example if you want to use one of the middlewares from the Werkzeug package to work around bugs in lighttpd, you can do it like this:
- https://docs.python.org/library/logging.html

```
from werkzeug.contrib.fixers import LighttpdCGIRootFix
app.wsgi_app = LighttpdCGIRootFix(app.wsgi_app)
```

## Using Flask Extensions
- Extensions are packages that help you accomplish common tasks. For example, Flask-SQLAlchemy provides SQLAlchemy support that makes it simple and easy to use with Flask.
- http://flask.pocoo.org/docs/0.11/extensions/#extensions

## Deploying to a Web Server
- http://flask.pocoo.org/docs/0.11/deploying/#deployment
