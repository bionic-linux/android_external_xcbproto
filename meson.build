# meson_options.txt extends built-in options. To see all the options,
# built-in and added, run:
#
# PAGER=less meson configure
#
project(
  'XCB Proto',
  version : '1.17.0',
  license : 'X11',
  meson_version : '>= 0.58.0',
)

# The "inclusion" is reversed: what is defined in a subdir is
# available here (what is here is not available in the subdirs).
# So some variables are defined in these subdirs and use, after,
# in this very file.
#
subdir('src')
subdir('xcbgen')

# For pkg-config(1), we keep the definitions as strings like
# ${foo}/${bar} (we do use the pc_<var> variants whose definition
# is not expanded in the subdirs where they are set.)
#
pc_conf = configuration_data({
    'prefix': get_option('prefix'),
    'datarootdir': '${prefix}' / get_option('datadir'),
    'datadir': '${datarootdir}',
    'PYTHON_PREFIX': pc_python_prefix,
    'pythondir': '${PYTHON_PREFIX}' / pythondir,
    'xcbincludedir': pc_xcbincludedir,
    'PACKAGE_VERSION': meson.project_version()
})

pkgconfdir = get_option('pkgconfdir')
pkgconfdir = pkgconfdir.replace('${datadir}', datadir)
configure_file(input: 'xcb-proto.pc.in',
               output: 'xcb-proto.pc',
               install_dir: get_option('prefix') / pkgconfdir,
               configuration: pc_conf)

