; --------------------------------------------------
; This script generates the demo gif
; --------------------------------------------------
#SingleInstance Force
SetkeyDelay 0, 50

Commands := []
Index := 1

Commands.Push("cd demo")
Commands.Push("rm -rf spec")
Commands.Push("rm cast.json {;} asciinema rec cast.json")
Commands.Push("vimcat sample_spec.rb")
Commands.Push("rspec sample_spec.rb")
Commands.Push("rspec sample_spec.rb")
Commands.Push("vi sample_spec.rb")
Commands.Push("rspec sample_spec.rb")
Commands.Push("rspec sample_spec.rb")
Commands.Push("exit")
Commands.Push("cat cast.json | svg-term --out cast.svg --window")

F12::
  Send % Commands[Index]
  Index := Index + 1
return

^F12::
  Reload
return

^x::
  ExitApp
return



