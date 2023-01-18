Kotlin bootstrapping
--------------------

This project is an attempt to build the Kotlin compiler and its standard
libraries with no prebuilt version of Kotlin. See the
[Bootstrappable Builds](https://bootstrappable.org) project to understand
why it matters.

The following pre-requisites are assumed to be bootstrappable:
* OpenJDK 8
* Apache Ant 1.10
* The IntelliJ SDK dependencies

This project focuses on the interactions between Kotlin and the IntelliJ SDK
to find a build path toward the recent versions of Kotlin. Building the other
non Kotlin related dependencies from sources is left as an exercise to the
reader.


## Status

The build works up to Kotlin 1.0.0-beta-4091 (2015-12-04).


## How to build

### Debian/Ubuntu

Prepare the environment with:

    apt install make git openjdk-8-jdk ant ant-contrib libjline2-java libjarjar-java
    update-java-alternatives --set java-1.8.0-openjdk-amd64

And then run:

    make

### Docker

Build the image:

    docker build . --tag kotlin-bootstrapping

And start the build with:

    docker run --rm --volume $(pwd):/kotlin --user $(id -u):$(id -g) kotlin-bootstrapping
