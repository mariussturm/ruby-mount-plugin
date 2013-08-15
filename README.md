Jenkins ruby mount plugin
==========

Run your Jenkins build under a custome ruby installation.

# Description

The idea is to compile your very own ruby with maybe some patches and some gems preinstalled. Package
this and deploy it to your production servers.

On the Jenkins side you want to use exactly the same package and not rvm or rbenv. So you can
make this custome ruby available to your build via this plugin.
 
The PATH environment variable will be set to your ruby installation. You can just use 'ruby' or 'gem'
in your build script.

Gems will be installed in the workspace of the job under '/gems'. You can wipe the workspace through
the Jenkins UI and all gems will be reinstalled on the next build.

# Installation

    rvm use jruby
    bundle install
    bundle exec jpi build

Upload pkg/ruby-mount.hpi to your Jenkins instance under /pluginManager/advanced

# License
This is licensed under the MIT license.
