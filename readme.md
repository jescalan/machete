Machete
-------

Fast, beautiful slideshows with markdown.

> **NOTE:** Machete is still in early development, and is still very much incomplete. You can still use it, but be warned that all the promises made in this readme are not yet implemented. If you'd like to keep up with the progress or contribute, check the [trello board](https://trello.com/b/JllTDqHZ/machete) : )


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

So you want to get a little fancier and make your own theme? Seems like a lot of work, but if you're into it, that's cool. I guess you could just make it once then use it for all your presentations as your signature style. If you do want to add a theme, you can do this pretty easily. Check out the [default theme](https://github.com/jenius/machete/tree/master/templates/dark) to see how we render themes internally.

#### Theme Files

Machete themes are written with jade, stylus, and coffeescript to make life clean and easy. In your theme folder, you should have three files:

- `index.jade`
- `style.styl`
- `script.coffee`

Let's go over how each file is handled, starting with `index.jade`. Set up the file as you'd like, all that's important to know here is the locals that get passed through, described below:

```yaml
css # => string of compiled and minfied css you have defined in `style.styl`
js # => string of compiled and minified javascript you have defined in `script.coffee`
slides # => array of strings of html representing each slide
title # => string representing the presentation title
author # => string representing the author
transition # => string representing the type of transition desired
```

Next up is `style.styl`. This is a stylus file that comes with [axis](https://github.com/jenius/axis) available if you want, to make life easier. If you want to take advantage of axis, just run `@import 'axis'` at the top of the file. There are also a couple of local variables passed in here, as defined below:

```yaml
primary_color # => main presentation color
secondary_color # => slightly less important color
controls # => boolean, whether controls should be displayed or not
```

Finally, `script.coffee`. There is a `Slideshow` class included automatically in all themes which takes care of the basic setup, transitioning between slides, and other stuff you probably don't want to replicate. In order to initialize the slideshow, you need to instantiate a `Slideshow` object, passing it the element that contains your slides, as such:

```coffee
new Slideshow('#slides')
```

And you can do whatever else you want in this script file as well.

#### Javascript API

The `Slideshow` class is incrdibly flexible, and exposes a nice clean public API as well. It's API is as follows:

```coffee
total_slides # total number of slides (int)
current() # returns the current slide
next() # go to the next slide
prev() # go to the previous slide
go_to(2) # go to slide (int)
```

Here's an example of potential usage:

```coffee
slideshow = new Slideshow('#slides')

$('.next').on 'click', -> slideshow.next()
$('.prev').on 'click', -> slideshow.prev()
$('.last_slide').on 'click', -> slideshow.go_to(total_slides)
```

You can also define custom transition types if you'd like to add your own. This can be done by extending the `Transition` class and adding a method called `hook`. A brief example is below:

```coffee
class MyTransition extends @Transition
  hook: ->
    # this hook is fired after classes are re-assigned
    # you can make any css changes here to move the
    # slides in and out the way you want.

slideshow = new MySlideshow('#slides', MyTransition)
```

For examples of how hooks are implemented, check out the [built in transitions folder](https://github.com/jenius/machete/tree/master/templates/base/transitions).

If there are any other requests or needs from the JS API, feel free to open an issue and/or pull request and make a suggestion!

### Contributing

See the [contributing guide](https://github.com/jenius/machete/blob/master/contributing.md)
