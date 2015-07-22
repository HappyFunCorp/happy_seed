Version 0.0.17
  - Cleaned up twitter generator
  - Changed angular generator to move @app into the global scope
  - Changed angular generator to define controllers via @app.controller
  
Version 0.0.16
  - Fixes for rbenv (require bundler)
  - Switched to bundle install --without production and print the output
  - Switched to BH for the static sites
  - Fixed problem with sticky footer
  - Fixed a problem in the default generated CSS
  - Fixed a missing include file for the bootstrap generator
  
Version 0.0.15
  - Added API Generator
  
Version 0.0.14
  - Cleaned up google apps
  - Added VCR
  - Added github oauth
  - Cleaned up testing helpers for authentication
  - Updated Admin Generator to use inherited_resources gem
  
Version 0.0.13
  - Removed testing code that shouldn't have been checked in
  - Improved cucumber testing
  - Added devise_invitable generator
  - Added google oauth generator  

Version 0.0.12
  - Updated rails dependancy to 4.2
  - Moved to guard from autotest
  - Added cucumber
  - Added spring to rspec test
  - Moved to bh for bootstrap helpers
  - Refactored omniauth generators
  - Updated ActiveAdmin
  - Added config defaults from ~/.seed_defaults

Version 0.0.10
  - Started the Changelog
  - Split the generate into a Thor class
  - Added middleman generators
  