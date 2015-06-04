__elixir-pdx/potato__

---
#Overview

This exercise is designed to be an introduction to the concept of Supervisors and Child processes.

The challenge is to implement the following story.  A Babysitter wants to play a game of "hot potato" with N-number of Children.  The game begins by the Babysitter gathering the children to play and handing one of them a potato and setting a timer between 1 and 3 seconds.  That Child takes the potato and hands it to the next one, and then that new Child to the next one after that and so on until the timer goes off.

The Child holding the potato when the timer goes off... dies.

About 1 in every 25 people is a sociopath.  When a sociopath gets the potato they replace it with a live grenade and hand it to the next Child and it explodes killing everybody.

If everbody dies, the parents resuscitate the babysitter and the game starts over.

The game ends normally when only one child is left and abnormally if the Babysitter dies more than 3 times.

**Prerequisites:**
* [elixir](http://elixir-lang.org/install.html)

---

#Getting Started

###Clone this repository.
  
    $ cd ~/Repositories
    $ git clone https://github.com/elixir-pdx/potato.git
    $ cd potato

#Hacking

You may find it helpful to play with your code in Elixir's `iex` interactive console. If you want to do that and autoload the console session with your code then you can do the following from the project root:

    $ iex -S mix

That will make sure that you're running `iex` inside your project's build environment.

#Building

To compile your project simply run this from the project root:

    $ mix compile

#Testing

To run the test suite defined in `test/potato_test.exs` then run this from the project root:

    $ mix test
