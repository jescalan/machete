Machete
-------

Fast, beautiful slideshows with markdown.

> **NOTE:** Machete is still in early development, and is still very much incomplete. You can still use it, but be warned that all the promises made in this readme are not yet implemented.


### Why should you care?

Sometimes you need to make a slide deck for something. When this happens, you usually have 2 options. First, you could make it with keynote or powerpoint, but if you did, you'd deal with the following disadvantages:

- Questionable GUI as an interface
- Not optimized for code and code highlighting
- Unsure it will work correctly on whatever computer you are presenting on
- Not easily shareable on the internet

Second, you could put some serious effort into coding out a html slideshow with a wonderful tool like [reveal.js](https://github.com/hakimel/reveal.js), which although it will be beautiful, is time-consuming. If you are just trying to get something up quickly that will work well anywhere and looks fresh, neither of these are good options.

To make a slideshow with machete, just make a folder of markdown files, then run one command. That's it, literally. It will drop a single html file that looks awesome and contains each of your markdown files as its own slide, nice transitions, syntax hilighting for code, clean responsive design, and that's all you have to worry about. To take it one step further, you can run one more command and have it instantly deploy to github pages or amazon s3.

### Installation

Convinced? Let's get started. Make sure you have [nodejs](http://nodejs.org) installed, then just run this command:

`npm install machete -g`

### Usage

- Create a folder
- Put markdown files in the folder
- Either `cd path/to/folder; machete` or `machete path/to/folder`

If you'd like to have us generate a sample folder and some slides, run `machete new [name]` and it will create a new folder with the name you gave it.

If you'd like to deploy your slideshow, run `machete deploy [deployer-name]`. Deployers currently available are `gh-pages` and `s3`. If there's somewhere else you want to deploy to, feel free to write a deployer and pull request it in.

Create a title slide using `h1` for the main heading and `h2` for the (optional) subheading. For regular slides, use `h3` for the slide title.

### Configuration

Chances are you might want to configure your slideshow a little more, you power user you. No worries, we've got you covered. Just drop a file called `config.yml` into your presentation folder, and feel free to specify any of the following options.

```yaml
title: 'Slideshow Title'
author: 'Joe Example'
controls: true # show arrow controls
history: false # updates the url
theme: 'dark' # options: dark, light
primary_color: 'red' # any valid css color
secondary_color: 'green' # same as above
google_analytics: 'UA-XXXXXX' # for tracking
```

### Theming

So you want to get a little fancier and make your own theme? Seems like a lot of work, but if you're into it, that's cool. I guess you could just make it once then use it for all your presentations as your signature style. If you do want to add a theme, you can do this pretty easily. Check out the [templates folder](#) to see how we render themes internally.

To make your own theme, just specify a path for the `theme_path` variable in your config and give it a path relative to your config file of where to find the theme. This could be a folder inside your project or wherever else you want. In that folder, make sure there is an `index.jade` file that includes everything you need.

There are a few locals that will be sent to the jade file - you can see a good example of this in the templates folder linked above, but they are also documented below for reference:

```ruby
slides # => array of html strings representing each slide
title # => string representing the presentation title
transition # => string representing the type of transition desired
```

### Contributing

Contributions are most welcome in any form, especially if you have coded up an awesome theme you'd like to share with the rest of anyone who uses this. If you would like to contribute, just follow these simple steps:

1. Fork the repo
2. Make some commits with your changes
3. Make sure the commits are clean, clear, and organized
4. Write a test for the changes you've made
5. Send a pull request
6. ???
7. Profit!

To run the tests, just run `mocha` locally. The test file is pretty straightforward, but if anything is confusing happy to clarify or add it in here.
