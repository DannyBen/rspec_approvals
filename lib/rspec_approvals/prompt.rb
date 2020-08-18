require 'io/console'
require 'colsole'

module RSpecApprovals
  class Prompt
    class << self
      include Colsole

      def select(prompt, default, options)
        options.each do |key, config|
          color = key == default ? 'txtred' : 'txtgrn'
          say "!#{color}!#{key}!txtrst!) #{config.first}"
        end
        
        say "\n!txtblu!#{prompt}!txtrst! "
        response = STDIN.getch.downcase
        
        response = default unless options.has_key? response
        
        resay "!txtpur!#{options[response].first}"
        options[response].last
      end
    end
  end
end