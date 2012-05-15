# Phlow

Feature branching is awesome, but it has issues.. Some serious issues! This gem is just aiming to enhance it by creating a workflow around it to make it even work with CI tools like Teamcity, Jenkins, etc. Gem includes a command line wrapper utility around Git.

## Installation

Add this line to your application's Gemfile:

    gem 'phlow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phlow

## Usage

Just type:

    $ phlow help

First of all, Git is not designed for Enterprise teams to work on a newly developed code base or an unstable codebase (unlike Linux kernel). This is just an attempt to ease that pain, but I'm underlining and making the next sentence bold. If you want to use Git in your Enterprise company, be careful and without having any workflow, don't even attempt to use Git blindly. I'll be publishing a white-paper soon around that. For the time being, you can email me for the details.

To have a successful Git workflow, I'm assuming you guys already have a central Git repository. If not, please use GitHub or GitLab. It'll reduce the pain a little bit. Let me try to explain how I expect you to work if you are adopting **Phlow**:

By default, **Phlow** will give you 4 branches. These are:

* master (origin/master)
* development (origin/development)
* operational (origin/operational)
* qa (origin/qa)

Let me explain the easy ones first! **Operational** branch is kind of a branch where you do your config changes, small library editions, updating a documentation etc. **QA** branch is for your QA work. Anything QA related goes into this branch. When I say QA, I'm more focusing on acceptance/load/performance testing. Nothing else. I believe unit, integration (contract) and functional (component) tests should be written by devs.

Keep in mind that above branches are not supposed to be manually merged to anywhere. **Phlow** will take care of it for you.

Now, let's get to the bottom of the real magic. Any time you want to work on a new topic/feature/story/bug/issue, you create a new branch for it by typing:
`phlow new my-awesome-feature`

Phlow will be creating a new branch for you with the necessary settings. You do your normal checkins into this branch. You can switch to another branch or feature any time and come back here using standard git commands. Just make sure that you are not messing anything by applying merging or rebasing (this includes pulls and fetches). If you do this, you are kinda beating the purpose of this gem. Basically, don't do it. Anyways, say you committed 3 checkins and now you want to send this changes to CI environment or other devs. All you need to do at this point is:
`phlow sync`

Phlow will take care of the rest for you. But bottom-line is, Phlow will sync everything over the **development** branch. Therefore your CI should run against **development** branch. This branch is nothing to be worried, all you will be seeing there is bunch of sync messages with feature names associated to them. The actual history will be fully kept in the master branch. Don't worry! You can sync as many as you want. Just remember, any conflicts on development branch, you gotta manually fix that (no merging back). Once you are done with your feature, just call your fellow colleague to review your changes. And if he is cool with it, then he can sign off to this feature by typing:
`phlow signoff my-awesome-feature`

As you as you sign off, all your history will be moved to master branch with no fast-forwarding.

Anyways, this is all for the time being. Keep in mind, **Phlow** is still in progress of development. We are actively using it every day and fine-tuning the problems. However, error-reporting mechanism is not that great yet. I'll be fixing that soon hopefully.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
