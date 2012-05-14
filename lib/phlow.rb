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
      result = `git remote add origin #{repo}`
      result = `git push -u origin master &> /dev/null`
      create_remote_branch 'development'
      create_remote_branch 'operational'
      create_remote_branch 'qa'
      result = `git checkout master &> /dev/null`

      puts "Done!"
   end

   def self.clone_repository(url)
      if repo.nil?
         puts "Oops! Please specify a the central repository url!"
         exit 1
      end

      puts "Cloning the repository..."
      result = `git clone #{url}`
      result = `git checkout master &> /dev/null`

      puts "Done!"
   end

   def self.branch(feature)
      puts "Creating..."
      result = `git pull &> /dev/null`
      result = `git checkout -b #{feature} master &> /dev/null`

      puts "#{feature} is ready for you to work on!"
   end

   def self.sync(action)
      puts "Syncing.."
      result = `git status -s`

      if not result.nil?
         puts "Please commit your changes first!"
         exit 1
      end

      feature = `echo $(git branch | grep "*" | sed "s/* //")`

      # if there is no branch, it should just do the safe sync
      if action.nil?
         puts "Applying remote changes to the #{feature} branch..."
         result = `git rebase master #{feature}`
         if not $?.success?
            puts result
            exit 1
         end

         puts "Sending current changes..."
         result = `git checkout development &> /dev/null`
         result = `git pull`
         result = `git merge --squash #{feature}`
         if not $?.success?
            puts result
            exit 1
         end

         result = `git add -A . &> /dev/null`
         result = `git commit . -m '#{feature} syncing..' &> /dev/null`
         result = `git push -u origin development`
         result = `git checkout #{feature} &> /dev/null`
         # maybe a operational branch sync with dev and master here too..
         # what about qa branch
      end
   end

   def self.signoff(feature)
      puts "Signing off #{feature}..."
      print "Signee: "
      signee = STDIN.gets.chomp

      if signee.length < 5
         puts "Please enter a valid name!"
         exit 1
      end

      result = `git checkout master &> /dev/null`
      result = `git pull &> /dev/null`
      result = `git rebase master #{feature}`
      result = `git merge --no-ff #{feature}`
      if not $?.success?
         puts result
         exit 1
      end

      result = `git pull origin &> /dev/null`
      result = `git checkout master &> /dev/null`
      result = `git merge --no-ff operational`
      if not $?.success?
         puts result
         exit 1
      end

      result = `git merge --no-ff qa`
      if not $?.success?
         puts result
         exit 1
      end

      result = `git push -u origin master`
   end

   private

   def self.create_remote_branch(name)
      result = `git checkout -b #{name} master &> /dev/null`
      result = `git push -u origin #{name} &> /dev/null`
      result = `git branch -d #{name} &> /dev/null`
   end
end
