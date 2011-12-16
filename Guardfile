# encoding: utf-8

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/(.+)\.rb$}) { puts "REEVALUATE and run ALL tests."; Dsl.reevaluate_guardfile; "test" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_.+\.rb$})
  watch('test/helper.rb')  { "test" }

  # Rails example
  # watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
  # watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
  # watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
  # watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
end
