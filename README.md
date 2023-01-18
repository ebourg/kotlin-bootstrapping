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

The build works up to Kotlin 1.0.0 (2016-02-12).


## How to build

### Debian/Ubuntu

Prepare the environment with:

    apt install make git openjdk-8-jdk ant ant-contrib libjline2-java libjarjar-java libnative-platform-java
    update-java-alternatives --set java-1.8.0-openjdk-amd64

And then run:

    make

### Docker

Build the image:

    docker build . --tag kotlin-bootstrapping

And start the build with:

    docker run --rm --volume $(pwd):/kotlin --user $(id -u):$(id -g) kotlin-bootstrapping


## Result

| Kotlin          | IntelliJ SDK |
|-----------------|--------------|
| 0.6.786         | 133          |
| 0.6.1364        |              |
| 0.6.1932        |              |
| 0.6.2107        |              |
| 0.6.2338        |              |
| 0.6.2451        | 134          |
| 0.6.2516        |              |
| 0.7.333         |              |
| 0.7.638         | 135          |
| 0.7.1214        |              |
| 0.8.84          | 138          |
| 0.8.409         |              |
| 0.8.418         |              |
| 0.8.422         |              |
| 0.8.1444        |              |
| 0.9.21          |              |
| 0.9.738         |              |
| 0.9.1204        |              |
| 0.10.300        |              |
| 0.10.823        | 139          |
| 0.10.1023       | 141          |
| 0.10.1336       |              |
| 0.10.1426       |              |
| 0.11.153        |              |
| 0.11.873        |              |
| 0.11.992        |              |
| 0.11.1014       |              |
| 0.11.1201       |              |
| 0.11.1393       |              |
| 0.12.108        |              |
| 0.12.115        |              |
| 0.12.176        |              |
| 0.12.470        |              |
| 0.12.1077       | 143          |
| 0.12.1250       |              |
| 0.12.1306       |              |
| 0.13.177        |              |
| 0.13.791        |              |
| 0.13.899        |              |
| 0.13.1118       |              |
| 0.13.1304       |              |
| 0.14.209        |              |
| 0.14.398        |              |
| 0.15.8          |              |
| 0.15.394        |              |
| 0.15.541        |              |
| 0.15.604        |              |
| 0.15.723        |              |
| 1.0.0-beta-2055 |              |
| 1.0.0-beta-3070 |              |
| 1.0.0-beta-4091 |              |
| 1.0.0-beta-5010 |              |
| 1.0.0-beta-5604 |              |
| 1.0.0-dev-162   |              |
| 1.0.0           |              |

