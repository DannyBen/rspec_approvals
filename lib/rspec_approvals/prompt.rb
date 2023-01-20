require 'io/console'
require 'colsole'

module RSpecApprovals
  class Prompt
    class << self
      include Colsole

      def select(prompt, default, options)
        options.each do |key, config|
          color = key == default ? 'r' : 'g'
          say "#{color}`#{key}`) #{config.first}"
        end

        say "\nb`#{prompt}` "
        response = $stdin.getch.downcase

        response = default unless options.has_key? response

        say "m`#{options[response].first}`", replace: true
        options[response].last
      end
    end
  end
end
