# The pythondir depends on Python version needed. We call an external
# utility for this but for this module the absence of python is not
# fatal: all in all, the *.py files are not used _here_ and python
# is only needed to pre-compile at installation time.
# It returns on stdout
#
python_search = run_command('../find_vpython.sh', '>=', '2', '5', check : false)
has_python = false
if python_search.returncode() == 0
    has_python = true
    python = python_search.stdout().split()[0]
    pythondir = python_search.stdout().split()[1]
    message('python found:', python)
else
    message('python not found:')
    pythondir = 'lib/python/site-packages'
endif

pc_python_prefix = get_option('python_prefix')
python_prefix = pc_python_prefix.replace('${prefix}', get_option('prefix'))

py_files = [
    '__init__.py',
    'align.py',
    'error.py',
    'expr.py',
    'matcher.py',
    'state.py',
    'xtypes.py'
]

install_data(py_files, install_dir: python_prefix / pythondir / 'xcbgen')
if has_python and get_option('compile_python')
    meson.add_install_script('../compile_py.sh', python,
        python_prefix / pythondir / 'xcbgen', '0', '1')
endif
