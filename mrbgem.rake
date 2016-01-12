MRuby::Gem::Specification.new('cura-termbox') do |spec|
  spec.authors = 'Ryan Scott Lewis <ryanscottlewis@lewis-software.com>'
  spec.summary = 'Cura adapter for Termbox.'
  spec.license = 'MIT'
  spec.version = '0.0.1'

  spec.add_dependency('cura', '~> 0.0.1')
  spec.add_dependency('mruby-termbox', '~> 0.2.0')

  spec.rbfiles = []

  spec.rbfiles << "#{dir}/lib/cura/termbox/error/base.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/error/failed_to_open_tty.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/error/not_running.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/error/pipe_trap_error.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/error/unsupported_terminal.rb"

  spec.rbfiles << "#{dir}/lib/cura/termbox/color_mapper.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/pencil.rb"
  spec.rbfiles << "#{dir}/lib/cura/termbox/window.rb"

  spec.rbfiles << "#{dir}/lib/cura/termbox/component/base.rb"

  spec.rbfiles << "#{dir}/lib/cura/termbox/adapter.rb"
end
