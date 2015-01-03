Python.Make - Makefile Module for Python Development
====================================================

Build a local python development environment using [virtualenv](https://virtualenv.pypa.io/),
and simplify [pip](https://pypi.python.org/pypi/pip) package management from outside.

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

Install any pip module you want in virtualenv:

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

Run any command in virtualenv:

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

See also:

  * [Virtualenv and Makefiles](http://blog.bottlepy.org/2012/07/16/virtualenv-and-makefiles.html)

