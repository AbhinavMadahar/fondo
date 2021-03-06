project('com.github.calo001.fondo', ['vala', 'c'],
    version : '1.1.4',
    license: 'GPL-3.0'
)

add_project_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

gnome = import('gnome')
i18n = import('i18n')

gresource = gnome.compile_resources(
    'as-resources', 'data/com.github.calo001.fondo.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h'
]
vala_args = []
sources = files()

subdir('data')
subdir('po')
subdir('src')

dependencies = [
	dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
    dependency('json-glib-1.0'),
    dependency('libsoup-2.4')
]
unity_dep = dependency('unity', required: false)
if unity_dep.found()
    dependencies += [unity_dep]
    vala_args += ['-D', 'WITH_UNITY']
endif

e = executable('com.github.calo001.fondo',
    sources,
    gresource,
    c_args: c_args,
    vala_args: vala_args,
    dependencies: dependencies,
    install : true
)

meson.add_install_script('meson/post_install.py')
