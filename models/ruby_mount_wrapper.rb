require 'stringio'

class RubyMountWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Run the build in a custome ruby environment"

  attr_accessor :rpath

  def initialize(attrs)
    @rpath = fix_empty attrs['rpath']
  end

  def ruby_installed?
    File.exists?(File.join(@rpath, 'bin', 'ruby'))
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
    listener << "Create gem directory #{workspace_gem_path} if needed\n"
    Dir.mkdir(workspace_gem_path) if ! File.exists? workspace_gem_path

    gems_version    = File.basename(Dir.glob(File.join(@rpath, 'lib', 'ruby', 'gems', '*')).first)
    system_gem_path = File.join(@rpath, 'lib', 'ruby', 'gems', gems_version)

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
