prefix = get_option('prefix')
datadir = get_option('datadir')
pc_xcbincludedir = '${datadir}/xcb' # this one for pkgconf file
xcbincludedir = prefix / datadir / 'xcb'

xml_files = [
    'xcb.xsd',
    'xproto.xml',
    'bigreq.xml',
    'composite.xml',
    'damage.xml',
    'dbe.xml',
    'dpms.xml',
    'dri2.xml',
    'dri3.xml',
    'ge.xml',
    'glx.xml',
    'present.xml',
    'randr.xml',
    'record.xml',
    'render.xml',
    'res.xml',
    'screensaver.xml',
    'shape.xml',
    'shm.xml',
    'sync.xml',
    'xc_misc.xml',
    'xevie.xml',
    'xf86dri.xml',
    'xf86vidmode.xml',
    'xfixes.xml',
    'xinerama.xml',
    'xinput.xml',
    'xkb.xml',
    'xprint.xml',
    'xselinux.xml',
    'xtest.xml',
    'xv.xml',
    'xvmc.xml'
]

# CHECKING IF REQUESTED
# If checking is requested, failure is fatal.
#
if get_option('check_xml')
    xmllint = find_program('xmllint', required : true)
    foreach f : xml_files
        if f != 'xcb.xsd'
            run_command(xmllint, '--noout', '--schema', 'xcb.xsd',
               f, check: true)
        endif
    endforeach
endif

install_data(xml_files, install_dir: xcbincludedir)
