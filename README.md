# Hi!

This is bot challenge. For our conference we need to have an awesome bot to help visitors during the event.
It's super easy to add new commands or implement those, which have not been finished yet.
You are free to use `sequel`

Here are some features you can help to implement:
* Schedule
* Speakers
* Nearby places (places of interest)
* Post your pic to feed
* Quiz

Or you can suggest any other feature, which in your opinion might be useful for the event.

# How to run
0. VPN or live outside the Roskomnadzor-controlled area (otherwise it won't connect to the telegram servers)
1. Clone `git clone https://github.com/saintprug/saintpruby_bot.git && cd saintpruby_bot`
2. Get bot token([Instruction](https://core.telegram.org/bots#6-botfather))
3. Copy `cp .env.example .env` and replace with obtained token
4. Run `docker build -t saintpruby:bot . && docker run -it saintpruby:bot`

# How to contribute
1. Fork
2. Implement a feature
3. Make a pull request

5 tickets would be given at the end of the challenge: 3 for most voted by community PR's, and 2 — my personal subjective preference.
There are no hard limitations, do it for fun and to contribute community!
