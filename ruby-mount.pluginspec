Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = 'ruby-mount'
  plugin.version = '0.1'
  plugin.description = 'Run your Jenkins build under a custome ruby installation'

  plugin.url = 'https://github.com/mariussturm/ruby-mount-plugin'
  plugin.developed_by 'Marius Sturm', 'kontakt@unscreen.de'

  plugin.uses_repository :github => 'mariussturm/ruby-mount-plugin'
  plugin.depends_on 'ruby-runtime', '0.12'
end
