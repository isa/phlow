require "phlow/version"

module Phlow

LICENSE = <<LICENSE
Copyright (c) #{Time.now.year}

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LICENSE

   def self.init_repository(repo)
      if repo.nil?
         puts "Oops! Please specify a remote repository url!"
         exit 1
      end

      puts "Initializing the repo..."
      result = `git init`

      puts "Creating a license file..."
      File.open('LICENSE', 'w') {|f| f.write(LICENSE) }

      puts "Committing for the first time..."
      result = `git add -A && git commit -m 'First commit'`

      puts "Creating necessary branches..."
      result = `git checkout -b development &> /dev/null`
      result = `git checkout -b master &> /dev/null`
      result = `git remote add origin #{repo}`
      result = `git push -u origin master &> /dev/null`
      result = `git push -u origin development &> /dev/null`

      puts "Initialization is done!"
   end

   def self.clone_repository(url)
      `git clone #{url}`
   end

   def self.branch(feature)
      `git checkout -b #{feature} master`
   end

   def self.sync
   end

   def self.signoff
   end
end
