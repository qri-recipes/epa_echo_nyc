# Let's Build a Dataset!

## 1. Setup Qri
First, you'll need the latest CLI binary. head over to our [releases page](https://github.com/qri-io/qri/releases/latest) and install the binary somewhere on your `$PATH`. You should be able to type `qri help` and see a nice introductory message.

Before we can do useful things with Qri, we need to set it up. So let's start by running setup:
```text
$ qri setup
```
Qri will ask you to pick a peername, this is your "handle" on qri. If you don't want to choose one, just hit enter & Qri will use the random peername shown to you in the prompt. Changing your peername is a bit of a pain, so it's worth taking the time now to find one that works for you.


## 2. Create Your dataset

`cd` to this directory & run the following:

```shell
$ qri save --file download.star me/epa_echo_nyc
```

If everything works, you should see green text saying `dataset created` followed by a lot of numbers & letters


## 3. Check for Updates
If you want to keep this data up-to-date, just run:
```
$ qri update me/epa_echo_nyc
```

if nothing in the source data has changed, you'll see "error: no changes detected". This means the source data hasn't changed.


## 4. Export for analysis:

To export a complete json file of your dataset:

```
$ qri export --format json me/epa_echo_nyc
```

Or to export an excel file of the body:
```
$ qri export --format xlsx me/epa_echo_nyc
```

#### Exporting just body data:

to get just the _body_ of your dataset (only the CSV data in this case):
```
$ qri get body --all me/epa_echo_nyc
```

or just the body as JSON:
```
$ qri get body --all --format json me/epa_echo_nyc
```


## 5. Publish to the world!
If you'd like others to see your work, you can _publish_ it to qri.io:

```
$ qri publish me/
```

you'll now be able to see your dataset at:
```
https://app.qri.io/[your_peername]/epa_echo_nyc
```
