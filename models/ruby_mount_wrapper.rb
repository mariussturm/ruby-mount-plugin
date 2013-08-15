require 'stringio'

class RubyMountWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Run the build in a custom ruby environment"

  attr_accessor :rpath

  def initialize(attrs)
    @rpath = fix_empty attrs['rpath']
  end

  def ruby_installed?
     @launcher.execute("bash", "-c", "test -f #{File.join(@rpath, 'bin', 'ruby')}") == 0
  end

  def setup(build, launcher, listener)
    @launcher = launcher
    arg       = @rpath
    workspace = build.workspace.to_s

    listener << "Preparing ruby environment"

    before = StringIO.new()
    if ! ruby_installed?
      listener << "Can not find a ruby installation under #{@rpath}\n"
      listener << before.string
      build.abort "Failed to setup ruby environment"
    end

    # create gem directory in our workspace
    workspace_gem_path = File.join(workspace, 'gems')
    listener << "Create gem directory #{workspace_gem_path}\n"
    @launcher.execute("bash", "-c", "mkdir -p #{workspace_gem_path}")

    gems_version    = StringIO.new()
    @launcher.execute("bash", "-c", "ls -1t #{File.join(@rpath, 'lib', 'ruby', 'gems')} | head -1", {:out => gems_version})
    system_gem_path = File.join(@rpath, 'lib', 'ruby', 'gems', gems_version.string)

    # Setup ruby environment
    build.env["PATH+RUBY"] = File.join(@rpath, 'bin')
    build.env["GEM_HOME"]  = workspace_gem_path
    build.env["GEM_PATH"]  = [workspace_gem_path, system_gem_path].join(':')
  end

  private

  def fix_empty(s)
    s == "" ? nil : s
  end

end
