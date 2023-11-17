An Introduction to Morphometric Analyses with Fishes
================
Morgan Sparks
2023-10-03

## Introduction

Today we’ll be using a variety of physical tools and software to collect
morphometric data from fishes.

For today’s exercise you will need to have downloaded the following
software:

imageJ: <https://imagej.net/ij/>

Once image J is installed we need to also install a macro called
`clickcoordinates.txt` (in google drive folder below). This will create
a tool that measures the x and y coordinates when we click on a location
on our picture. To do so go to the top menu and navigate to
Plugins\>Macros\>Install and then navigate to the Finder window to
wherever that file is saved and select it

We will also use a google drive folder that will have a folder to drop
photos in and worksheet for us to upload our data. It can be accessed
here:

<https://drive.google.com/drive/folders/1dy1zzphPFRoyfz28hN1xgedXDvrV1sdn?usp=sharing>

## Setting up our environment

When we import a photo we first need to make a standardized environment.
To open a photo in imageJ navigate to File\>Open and then select your
image.

These photos will all be taken using a standardized scale (the ruler on
the box) so that we can standardize distance in our photos
electronically. In other words, we’ll measure the number of pixels per
some unit of measurement.

To set this scale in your photo you will use the line draw function to
draw a line over a standardized distance (I like 10 mm). To make your
life easier I recommend doing this while zoomed way in on the photo.

After you have drawn your line over your chosen scale (make sure you use
the same scale in every photo) you will navigate to Analyze\>Set Scale
and in the window change the “Known Distance” to the whatever distance
you measured (e.g. 10) and the “Unit of length” to whatever you chose
(e.g. mm).

## Taking our measurements and landmarks

Now that we have our scale set we can begin to take data off of our
fish. We’ll use the following guide supplied below. We’ll be taking
length measurements, landmarks, and semi-landmarks.

### Length measurements

The first two measurements we’ll take is Total Length and the second,
Mid-eye to hypural. You will do this with the line tool and then by
navigating to Analyze\>Measure and window will pop up with your data
(copy the mean value). Record those data in the google drive document.

### Landmarks and semilandmarks

The next step we will do is to measure Landmarks. Landmarks are fixed
locations in morphometric analysis, so these are things like the middle
of the eye, the start and ending location of dorsal fin, or where the
caudal peduncal (body part of tail) transition into the caudal fin (tail
fin).

We will take 18 landamarks according to those laid out in the provided
photo. It is **VERY IMPORTANT** you do this in the order of those
landmarks laid out on the photo. If we don’t our fish will look very
weird to the computer program!

To do this we will use to the tool we created with the macro which just
requires you click on the photo wherever that landmark lays. You may set
all the landmarks and then copy the whole window of data after you’re
done. <br> <br> <br> ***Functionally, what we are doing today is a very
complicated version of connect to the dots to draw a fish with our
computer*** <br> <br>

## Running the analysis

### Analyzing length

Now we’ll start the analysis. We’re going to go in a stepwise fashion
where I will run the analysis in R in real time and we’ll look at
figures and answer some questions as class.

Before we get into the actual morphometric analyses, let’s just look at
our length distributions that we measured as a class. <br> <br>
**Question 1:** Did we do a good job of measuring our fish? Why or why
not? If we didn’t, what contributed to those issues?

### Standardizing our shape data

We will use a process called Generalized Procrustes Analysis or GPA
which aligns our landmark configurations to a common coordinate system,
and allows us to extract shape (and size) data from them. This is a
pretty specific analysis to just morphometric data and is rather
complex, so we won’t dig into the details. However, if you find yourself
interested check out the slides from the `geomorphr` tutorial here:
<https://geomorphr.github.io/GMcourse/Lectures/03-Superimposition.html#1>
<br> <br> **Question 2:** Use an example to describe why we would need
to standardize our shape data.

### Analyzing our shape data

Next we will use Principal Component Analysis or PCA to summarize our
multidimensional data. PCAs essentially decompose data with lots of
variables (semilandmarks in our case) into vectors of information. So
for a fish we would have a vector of values that represent the fish’s
value on each principal component axis (this will make more sense when
we plot it).

I like Wikipedia’s basic explanation:

> Principal component analysis (PCA) is a popular technique for
> analyzing large datasets containing a high number of
> dimensions/features per observation, increasing the interpretability
> of data while preserving the maximum amount of information, and
> enabling the visualization of multidimensional data.

We then rank each principal component based on the amount variation it
explains (out of 100%) and look for the number of components where there
is an obvious break. For example if we measure 10 components and the
first three explain 75% of variation and the last 7 just 25%, we’d
probably just choose to use those first three.

***Put simply, with PCA we are trying to understand which features
explain the majority of variation in our dataset***

Next we plot the first and second axes against one another to understand
how our fish group together in principal component space. Our
expectation is that some traits will dominate how the fish group (e.g.
their body depth or facial structure, etc.) and we should be able to
explain the morphological structure by species according to how they
group in two-dimensional space (principal component 1 and principal
component 2). <br> <br> **Question 3:** How do our fish group along PC 1
and PC 2? How about additional PCs? What features do you think are
driving these trends?

## Linking our data to the ecology of our fish

Now that we have discussed this as a class, for the next 20 minutes do
some research on each of the species in our analyses and learn about
what may determine their body shape. Talk with your group about your
findings and formulate hypotheses for the questions below.

The species we analyzed are:

Pink salmon (*Oncorhynchus gorbuscha*)

Greenback cutthroat trout (*Ocorhynchus clarki stomias*)

Largemouth bass (*Micropterus salmoides*) <br> <br> Places where you can
learn more about these fish:

Fish base: <https://www.fishbase.se/search.php>

CPW species profile (Greenback):
<https://cpw.state.co.us/learn/Pages/SpeciesProfiles.aspx>

Wikipedia  
<br> <br> **Question 4:** Come up with a set of hypotheses to explain
why the different features of those fish are the way they are? For
example, is it about the food they eat, the predators they try and
avoid, etc. <br> <br> **Question 5:** Given what we know about the
generalized shapes of our fish, how would you say these fish are
evolutionary related (e.g., are some more closely related to others)?
<br> <br> **Question 6:** After seeing the fish phylogeny do you think
morphometrics is the best tool to create phylogenies?
