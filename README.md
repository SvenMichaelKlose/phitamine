#!/usr/bin/less

# An introduction to phitamine

tré version < 0.18 is required.

## Overview

phitamine helps you to make LAMP sites with the programming
language tré.

phitamine gives you:

* easy access to request, form and session data.
* templates that make XML from Lisp expressions.
* a simple MySQL interface.
* modular associations of URLs with functions.


## What you need to know and have

This manual neither explains tré/Lisp, HTML or any other stuff
you need to develop a web site.  You should also have installed
your own Linux with Apache, PHP and MySQL installed to really
get some fun out of life.  Last but not least you should be able
to use the Unix shell.

phitamine requires the tré modules "l10n", "php", "php-db-mysql",
"shared" and "sql-clause".


## How to use phitamine

Make an empty directory, step in and unpack the phitamine
archive.  You should get a directory of the same name.  Then,
make an own directory where you'll place your source codes and
symlink the phitamine directory into it:

```sh
mkdir -p myproject/tre_modules
cd myproject/tre_modules
git clone https://github.com/SvenMichaelKlose/phitamine.git
git clone https://github.com/SvenMichaelKlose/tre-sql-clause.git sql-clause
```

In your project directory, first set up a makefile that will
compile your code.  Call it 'make.lisp' and insert this:

```lisp
(load "tre_modules/phitamine/make-project.lisp")
(make-phitamine-project "Dummy project name" '("toplevel.lisp"))
(quit)
```

This makefile takes a file called 'toplevel.lisp', compiles it to
PHP and saves it in 'compiled/index.php'.  Make the required
'toplevel.lisp' like so:

```lisp
(phitamine)
(princ "This works, too.")
```

phitamine doesn't output anything, except on errors.  Please try
to compile this two-liner just to see if the version of phitamine
you've got is working at all.  Again, in the shell:

```sh
tre make.lisp
php compiled/index.php
```

This makes the script we want and uses the command-line version
of PHP to test run it.  You should just get the message 'This
works, too.', so you can rock on right away and try out your
first template.


## Templates

Let's generate some HTML.  You could just print plain HTML, of
course, but in the world of Lisp, that'd be an incredible waste.
Instead, we assemble so-called LML expressions and have them
converted to HTML by phitamine.


### LML

In LML every list is a tag.  The first element must be a symbol
for the tag name.  A simple

```lisp
(hr)
```

will translate to

```html
<hr/>
```

HTML5 has some tags that may not be closed at all, like the HR
element but I guarantee you that a modern browser won't fail you
on syntactically correct XML. 

If you want attributes, use keyword symbols followed by values.
A keyword symbol must never stand alone.

```lisp
(hr :class "dont_use_classes_too_often")
```

will give you

```html
<hr class="dont_use_classes_too_often"/>
```

But

```lisp
(hr :class)
```

will just break with an error message.  Inside an alement you
can pack more elements or just text nodes:

```lisp
(p "Go " (a :href "/" "home"))
```

will give you

```html
<p>Go <a href="/">home</a>.</p>
```

Should you need a tag with no contents but with an extra ending
tag, like a TEXTAREA element, use an empty string for the content:

```lisp
(textarea :name "message" "")
```

will give you the desired

```html
<textarea name="message"></textarea>
```

The LML to XML converter doesn't translate characters to XML
entities, so you can nest HTML generators.


### Templates

Now for our first template: the index page of our little web
site.  Make a directory called 'templates' where we'll put our
LML files.  There, create a file named 'main.lisp' with the
following content:

```lisp
(html
  (head (title "Our first page with phitamine"))
  (body
    "Even this works."))
```

To get that template out, change 'toplevel.lisp' to:

```lisp
(define-template tpl-main :path "templates/main.lisp")
(phitamine)
(princ (tpl-main))
```

The template TPL-MAIN will be available as a function that
returns our HTML.  Compile the script again and test it on your
web server.  If you have LAMP right under your fingers you may
want to symlink the 'compiled' directory into your web space.
Most Linux installations have their web directory at '/var/www'.
It is so much more comfortable than working with cheap web space
you can only access via FTP.


### Template parameters

Parameters give templates their dynamic content.  They're passed
to template functions in the form of an associative list.  Inside
the template function PARAM gets you a particular parameter.  The
LML expressions are BACKQUOTEd automatically, so you must use
QUASIQUOTE to insert values.  This is how 'templates/main.lisp'
should look like:

```lisp
(html
  (head (title "Our first dynamic template"))
  (body
    "Parameter X has the value &quot;" ,(param 'X) "&quot;."))
```

Also change 'toplevel.lisp' to set the X parameter:

```lisp
(princ (tpl-main `((X . 42))))
```

Compile the script and run it in your browser.  You should get

```
Parameter X has the value "42".
```


### Form data

Form and database records come as associative lists as well.  Our
first, simple form will show that. Here's the code we put in
'templates/main.lisp' to replace its old code:

```lisp
(html
  (head (title "Our first phitamine form"))
  (body
    (form :method "post" :action ""
      (input    :name "email" :type "text" :value ,(form-value 'email))
      (textarea :name "message" ,(form-value 'message))
      (input    :type "submit" :value "Submit..."))))
```

FORM-VALUE reads values from the posted form data.

That's it.  Whenever you post the form, it will return with its
former content.  phitamine also makes it easy to treat multiple
posted records and files, but more on that later.


## Actions

phitamine has a special mechanism to process URLs.  But first,
let's set up our Apache web server.


### Preparing Apache for actions

To be able to use actions, we must configure Apache to NOT throw
an error message if a directory doesn't exist and to pass the URL
to our script.  To do that, create a '.htaccess' file next to
your generated 'index.php':

```
Options -indexes
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule .? index.php$1 [L]
```

This assumes that the script is in the root directory of your
web server.  If you placed the script in a subdirectory called
'example', you must change the last line to

```
RewriteRule .? /example/index.php$1 [L]
```

Now, every time someone tries to open a page in the example
directory, like 'http://whateveryourdomain.is/example/bla',
it will always invoke your script 'example/index.php'.
'bla' will be an action.


### How phitamine deals with URLs and actions

phitamine processes an URL directory by directory from left to
right.  When a directoriy's name is associated with an action
handler, that handler is called, so it can configure the
application before something is output.

If phitamine hits a component for which no action was defined,
it issues the good old mood–shifting ERROR 404 PAGE NOT FOUND.

Let's extend our already working page with internationalization.
We enable our visitors to select the language of our page.

```lisp
(html
  (head (title "Our first phitamine form"))
  (body
    (a :href (action-url :update '(lang en)) "English") " "
    (a :href (action-url :update '(lang de)) "Deutsch") " "
    (a :href (action-url :update '(lang is)) "Íslenska")
    (h1 ,(lang en "Welcome!"
               de "Willkommen!"
               is "Sæl og blessuð!"
               fr "Bonjour!"))
    (form :method "post" :action ""
      (input :type "text" :name "email" :value ,(param 'email))
      (textarea :name "message" ,(param 'message))
      (input :type "submit" :value "Submit…"))))
```

Our new page now intends to support four languages which will
switch our heading.  Function ACTION-URL takes the current URL
and changes only the language part.  Let's rewrite
'toplevel.lisp' step by step.

First, we tell phitamine that there's an action LANGUAGE and a
handler of the same name.  We can set another function, but one
should always keep things as easy as possible:

```lisp
(define-action language)
```

Then we define the handler:

```lisp
(defun language (x)
  (= *current-language* (make-upcase-symbol .x.))
  2)
```

When this handler is called, variable X points to the URL
component that caused the action to be invoked.  If the visitor
picked English it contains the list '("language" "en").  We simply
convert the country code into a symbol and set it as the current
language.  The returned 2 tells phitamine that the two components
should remain in the URL.  phitamine then continues with the
third component in X if it's there.

In case you wonder why the page is already in your preferred
language: phitamine detects the language set in your browser and
sets the current language accordingly.  If your language isn't
available, the LANG macro in the template will fall back to the
*DEFAULT-LANGUAGE* which is English by default.

All left to do is to invoke phitamine (which will process the
actions) and to call our template:

```lisp
(phitamine)
(princ (tpl-main (form-data)))
```

Compile and run the script – Voilà!


### Ports – independent templates on a single page

Usually, the action handlers claim a 'port' for which it
generates HTML as soon as a template requests that port via the
PORT function.  Actions can be packed into groups that occur in
particular ports.  This gives you the advantage of being able to
have many independent pages in one common template which defines
the overall design of your site.  Copy the file
'templates/main.lisp' to 'templates/home.lisp' and edit
'main.lisp' to look like this:

```lisp
(html
  (head "Our first phitamine form")
  (body
    (a :href (action-url :update '(lang en)) "English") " "
    (a :href (action-url :update '(lang de)) "Deutsch") " "
    (a :href (action-url :update '(lang is)) "Íslenska")
    ,(port 'content)))
```

This will be our template used for all pages our script
generates, so all pages come with a language selection.  Then,
tweak 'home.lisp' to

```lisp
(h1 ,(lang en "Welcome!"
           de "Willkommen!"
           is "Sæl og blessuð!"
           fr "Bonjour!"))
(form :method "post" :action ""
  (input :type "text" :name "email" :value ,(param 'email))
  (textarea :name "message" ,(param 'message))
  (input :type "submit" :value "Submit…")))
```

In 'toplevel.lisp' we have to define the new template:

```lisp
(define-template tpl-home :path "templates/home.lisp")
```

As you might've guessed we need to claim the CONTENT port.  But
to do that, we first have to make an action that can claim it,
The global variable *DEFAULT-ACTION* has to be set, so phitamine
knows what to call if the URL contains no action.  Put the
following line on top of your 'toplevel.lisp' file:

```lisp
(= *default-action* "/home")
```

Then define the action and handler for HOME:

```lisp
(define-action home)

(defun home (x)
  (set-port (tpl-home))
  1)
```

The macro SET-PORT tells phitamine to call the TPL-HOME template
for its port.  And, because we haven't defined a port for the
HOME action yet, phitamine assumes that you want the CONTENT port.

Your new 'toplevel.lisp' should now look like this:

```lisp
(= *default-action* "/home")

(define-template tpl-main :path "templates/main.lisp")
(define-template tpl-home :path "templates/home.lisp")

(define-action language)

(defun language (x)
  (= *current-language* (make-symbol (upcase .x.)))
  2)

(define-action home)

(defun home (x)
  (set-port (tpl-home (form-data)))
  1)

(phitamine)
(princ (tpl-main))
```

### Port groups

Once you've set up a useful part of your application, you sure as
hell want to reuse it later on.  Like a user management with
login and registration form.  Such a module has many actions and
you don't want to declare every single action's port in case you
don't want it in the CONTENT port.  Therefore, actions are packed
into groups which can be associated with a port.  If you don't
specify a group when defining an action, it is set to DEFAULT. So

```lisp
(define-action login)
```

is in fact

```lisp
(define-action login :group default)
```

Let's say your user management module set up a couple of actions:

```lisp
(define-action login :group login)
(define-action logout :group login)
```

you can put their group LOGIN into port NAVIGATION with SET-GROUP-PORT:

```lisp
(set-group-port 'login 'navigation)
```

# Future improvements

* Improve the glossary (rename things):
  - 'action' -> 'route'
  - 'component' -> 'directory'? Or 'path element'?
* Let handlers return the rest of path elements instead of number
  of elements that should be skipped.
* Use strings as path element names instead of keywords.
* Use LML/component module.
