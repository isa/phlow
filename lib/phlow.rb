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

      if not File.exists?(".git")
         puts "Initializing the repo..."
         result = `git clone #{repo} .`
      end

      if not File.exists?("LICENSE")
         puts "Creating a license file..."
         File.open("LICENSE", "w") {|f| f.write(LICENSE) }

         puts "Committing for the first time..."
         result = `git add -A && git commit -m 'First commit'`
      end

      puts "Creating necessary branches..."
      result = `git push -u origin master &> /dev/null`
      create_remote_branch 'development'
      create_remote_branch 'operational'
      create_remote_branch 'qa'
      result = `git checkout master &> /dev/null`

      puts "Done!"
   end

   def self.new_topic(topic)
      puts "Creating..."
      result = `git pull &> /dev/null`
      result = `git checkout -b #{topic} master &> /dev/null`

      puts "#{topic} is ready for you to work on!"
   end

   def self.sync(action)
      puts "Syncing.."
      result = `git status -s`

      if result.nil?
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

         result = `git commit . -m '#{feature} syncing..' &> /dev/null`

         sync_with_operational_branches 'development'

         result = `git push -u origin development`
         result = `git checkout #{feature} &> /dev/null`
      end
   end

   def self.signoff(feature)
      if feature.nil?
         puts "Please specify which feature you want to sign off!"
         exit 1
      end

      print "Are you sure you want to sign off to #{feature}? Remember, this will delete the #{feature} [y/n]? "
      answer = STDIN.gets.chomp

      if answer.downcase == 'y' or answer.downcase == 'yes'
         puts "Signing off [ #{feature} ]..."
         print "Signee: "
         signee = STDIN.gets.chomp

         if signee.length < 5
            puts "Please enter a valid name!"
            exit 1
         end

         result = `git checkout master &> /dev/null`
         result = `git pull &> /dev/null`
         result = `git rebase master #{feature}`
         result = `git checkout master &> /dev/null`
         result = `git merge --no-ff #{feature} -m '#{feature} is signed off by #{signee}'`
         if not $?.success?
            puts result
            exit 1
         end

         sync_with_operational_branches 'master'
         result = `git branch -d #{feature}`
         result = `git push -u origin master`
      end
   end

   private

   def self.create_remote_branch(name)
      result = `git checkout -b #{name} master &> /dev/null`
      result = `git push -u origin #{name} &> /dev/null`

      if not $?.success?
         result = `git pull &> /dev/null`
         result = `git branch #{name} --set-upstream origin/#{name} &> /dev/null`
      end
   end

   def self.sync_with_operational_branches(branch)
      result = `git pull origin &> /dev/null`
      result = `git checkout operational &> /dev/null`
      result = `git checkout qa &> /dev/null`

      result = `git checkout #{branch} &> /dev/null`
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
   end

end
