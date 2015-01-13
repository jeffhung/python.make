Python.Make
===========

Python.Make is a `Makefile` module for python development that use
[GNU make][gmake] to build a local python development environment
using [virtualenv][virtualenv], and simplify [pip][pip] package
management from outside.

[virtualenv]: https://virtualenv.pypa.io/
[pip]: https://pypi.python.org/pypi/pip
[gmake]: http://www.gnu.org/software/make/

Make targets are prefix with `python-` so you can use them easily with auto-completion:

	$ make python-<TAB>
	python-%        python-pip      python-run      python-runtime  python-shell

Bootstrap your development environment in local:

	$ make python-runtime
	mkdir -p ~/python.make/runtime;
	python ~/python.make/.cache/virtualenv/virtualenv.py ~/python.make/runtime;
	New python executable in ~/python.make/runtime/bin/python
	Installing setuptools, pip...done.

Search pip modules in virtualenv:

	$ make python-pip search ralc
	. ~/python.make/runtime/bin/activate; pip search ralc;
	ColanderAlchemy           - Autogenerate Colander schemas based on SQLAlchemy models.
	python-mistralclient      - Mistral Client Library
	ralc                      - Rate Calculator.
	referral_candy            - ReferralCandy Python API Client

Install any pip module you want in virtualenv, with prefix `python-` added in front of package name:

	$ make python-ralc
	. ~/python.make/runtime/bin/activate; \
	pip install --download-cache ~/python.make/.cache/pip ralc;
	Downloading/unpacking ralc
	  Using download cache from ~/python.make/.cache/pip/https%3A%2F%2Fpypi.python.org%2Fpackages%2Fsource%2Fr%2Fralc%2Fralc-0.1.tar.gz
	  Running setup.py (path:~/python.make/runtime/build/ralc/setup.py) egg_info for package ralc
	
	Installing collected packages: ralc
	  Running setup.py install for ralc
	
	    Installing ralc script to ~/python.make/runtime/bin
	Successfully installed ralc
	Cleaning up...

Run any command in virtualenv while using `--` to avoid options captured by `make`:

	$ make python-run -- ralc 30 20
	. ~/python.make/runtime/bin/activate; ralc 30 20;
	> 30.00 x 20.00 = 600.00

List installed pip modules in virtualenv:

	$ make python-pip list
	. ~/python.make/runtime/bin/activate; pip list;
	pip (1.5.4)
	ralc (0.1)
	setuptools (2.2)
	wsgiref (0.1.2)

Run python interactively with all modules you installed in local:

	$ make python-shell
	. ~/python.make/runtime/bin/activate; python;
	Python 2.7.5 (default, Mar  9 2014, 22:15:05)
	[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
	Type "help", "copyright", "credits" or "license" for more information.
	>>>

Take a snapshot of current dependencies in `requirements.txt`:

	$ make python-freeze
	. ~/python.make/runtime/bin/activate; pip freeze > requirements.txt;

Create new module `foo` in current folder with module skeleton generated:

	$ make python-module foo \
	       version=1.2.3 \
	       author='Jeff Hung' email=name@example.com \
	       url=https://github.com/jeffhung/python.make \
	       summary='one line summary to describe this new module' \
	       description='multiline description of this new module' \
	       license=MIT copyright='blah~'
	. ~/python.make/runtime/bin/activate; pip freeze > requirements.txt;
	Making new python module 'foo'...
	mkdir -p foo;
	Generate foo/__init__.py
	Generate setup.py
	Generate MANIFEST.in

The `version`, `author`, `email`, `url`, `summary`, `description`, and
`license` parameters are optional. Please specify them to override the default
values.

By default the `author`, `email`, and `url` parameters will be automatically
discovered from your git and github configurations. The `author` will be the
value of your `user.name` git configuration. The `email` will be the value of
your `user.email` git configuration. And `url` will be a github repository url
composed by your github username and name of this new python module.

By default `license` is empty. If `license` is empty, the new python module is
considered a private work that all rights are reserved to the author (auto
discovered or specified by the `author` parameter). Otherwise, a `LICENSE` file
will be generated using the [lice][lice] tool.  That means the valid value of
`license` parameter could be any of the followings: `agpl3`, `apache`, `bsd2`,
`bsd3`, `cddl`, `cc0`, `epl`, `gpl2`, `gpl3`, `lgpl`, `mit`, or `mpl`.

[lice]: https://pypi.python.org/pypi/lice


See also:

  * [Virtualenv and Makefiles](http://blog.bottlepy.org/2012/07/16/virtualenv-and-makefiles.html)

