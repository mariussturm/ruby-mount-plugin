Jenkins ruby mount plugin
==========

run your Jenkins build under a custome ruby installation

##Installation

    rvm use jruby
    bundle install
    bundle exec jpi build

Upload pkg/ruby-mount.hpi to your Jenkins instance under /pluginManager/advanced
