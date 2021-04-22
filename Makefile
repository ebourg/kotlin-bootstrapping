#
# Kotlin bootstrapping
#

.PHONY: bootstrap init clean

bootstrap: init build/kotlin-0.12.115

init:
	mkdir -p build dependencies

clean:
	rm -Rf build

intellij-community:
	git clone https://github.com/JetBrains/intellij-community

# Build the IntelliJ SDK 133
build/intellij-community-133: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 133 \
	    && git apply ../patches/sdk-133.patch \
	    && rm -Rf plugins/gradle \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-133

kotlin:
	git clone https://github.com/JetBrains/kotlin

# Build Kotlin 0.6.786 (last version of the compiler buildable without Kotlin)
build/kotlin-0.6.786: build/intellij-community-133 | kotlin
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.786 \
	    && git apply ../patches/kotlin-0.6.786.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-133/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ \
	    && ant -Dshrink=false -Dgenerate.javadoc=false \
	    && mv dist/kotlinc ../build/kotlin-0.6.786

build/kotlin-0.6.1364: build/kotlin-0.6.786
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.1364 \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-133/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.compiler.home=../build/kotlin-0.6.786 \
	    && mv dist/kotlinc ../build/kotlin-0.6.1364

build/kotlin-0.6.1932: build/kotlin-0.6.1364
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.1932 \
	    && git apply ../patches/kotlin-0.6.1932.patch \
	    && cp -r runtime/src/org/jetbrains/annotations core/util.runtime/src/org/jetbrains/ \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-133/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.compiler.home=../build/kotlin-0.6.1364 \
	    && rm -Rf core/util.runtime/src/org/jetbrains/annotations/ \
	    && mv dist/kotlinc ../build/kotlin-0.6.1932

build/kotlin-0.6.2107: build/kotlin-0.6.1932
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.2107 \
	    && git apply ../patches/kotlin-0.6.2107.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-133/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.compiler.home=../build/kotlin-0.6.1932 \
	    && mv dist/kotlinc ../build/kotlin-0.6.2107

build/kotlin-0.6.2338: build/kotlin-0.6.2107
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.2338 \
	    && git apply ../patches/kotlin-0.6.2338.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-133/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-133/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-133/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-133/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.compiler.home=../build/kotlin-0.6.2107 \
	    && mv dist/kotlinc ../build/kotlin-0.6.2338

# Build the IntelliJ SDK 134
build/intellij-community-134: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 1168c7b8cb4dc8318b8d24037b372141730a0d1f \
	    && git apply ../patches/sdk-134.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-134

dependencies/kotlin-jdk-annotations.jar:
	wget https://teamcity.jetbrains.com/guestAuth/repository/download/Kotlin_KAnnotator_InferJdkAnnotations/shipWithKotlin.tcbuildtag/kotlin-jdk-annotations.jar -P dependencies

dependencies/kotlin-android-sdk-annotations.jar:
	wget https://teamcity.jetbrains.com/guestAuth/repository/download/Kotlin_KAnnotator_InferJdkAnnotations/shipWithKotlin.tcbuildtag/kotlin-android-sdk-annotations.jar -P dependencies

build/kotlin-0.6.2451: build/kotlin-0.6.2338 build/intellij-community-134 dependencies/kotlin-jdk-annotations.jar dependencies/kotlin-android-sdk-annotations.jar
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.2451 \
	    && git apply ../patches/kotlin-0.6.2451.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-134/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.6.2338 \
	    && mv dist/kotlinc ../build/kotlin-0.6.2451

build/kotlin-0.6.2516: build/kotlin-0.6.2451
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.6.2516 \
	    && git apply ../patches/kotlin-0.6.2516.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-134/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.6.2451 \
	    && mv dist/kotlinc ../build/kotlin-0.6.2516

build/kotlin-0.7.333: build/kotlin-0.6.2516
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.7.333 \
	    && git apply ../patches/kotlin-0.7.333.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-134/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-134/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-134/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-134/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.6.2516 \
	    && mv dist/kotlinc ../build/kotlin-0.7.333

# Build the IntelliJ SDK 135
build/intellij-community-135: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 135 \
	    && git apply ../patches/sdk-135.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-135

build/kotlin-0.7.638: build/kotlin-0.7.333 build/intellij-community-135
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.7.638 \
	    && git apply ../patches/kotlin-0.7.638.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-135/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-135/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-135/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-135/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.7.333 \
	    && mv dist/kotlinc ../build/kotlin-0.7.638

build/kotlin-0.7.1189: build/kotlin-0.7.638
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.7.1189 \
	    && git apply ../patches/kotlin-0.7.1189.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/lib/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/jps/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/dist.all.ce/lib/asm4-all.jar       ideaSDK/core/jetbrains-asm-debug-all-4.0.jar \
	    && cp ../build/intellij-community-135/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/core/guava-14.0.1.jar    ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/protobuf-2.5.0.jar   ideaSDK/lib/ \
	    && cp ../build/intellij-community-135/artifacts/jps/trove4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/trove4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-135/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-135/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/log4j.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-135/artifacts/jps/log4j.jar            ideaSDK/jps/ \
	    && cp ../build/intellij-community-135/artifacts/jps/jps-model.jar        ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.7.638 \
	    && mv dist/kotlinc ../build/kotlin-0.7.1189

# Build the IntelliJ SDK 138
build/intellij-community-138: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 070c64f86da3bfd3c86f151c75aefeb4f67870c8 \
	    && git apply ../patches/sdk-138.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-138

build/kotlin-0.8.84: build/kotlin-0.7.1189 build/intellij-community-138
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.8.84 \
	    && git apply ../patches/kotlin-0.8.84.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.7.1189 \
	    && mv dist/kotlinc ../build/kotlin-0.8.84

build/kotlin-0.8.409: build/kotlin-0.8.84
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.8.409 \
	    && git apply ../patches/kotlin-0.8.409.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.8.84 \
	    && mv dist/kotlinc ../build/kotlin-0.8.409

build/kotlin-0.8.418: build/kotlin-0.8.409
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.8.418 \
	    && git apply ../patches/kotlin-0.8.418.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.8.409 \
	    && mv dist/kotlinc ../build/kotlin-0.8.418

build/kotlin-0.8.422: build/kotlin-0.8.418
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.8.422 \
	    && git apply ../patches/kotlin-0.8.422.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.8.418 \
	    && mv dist/kotlinc ../build/kotlin-0.8.422

build/kotlin-0.8.1444: build/kotlin-0.8.422
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.8.1444 \
	    && git apply ../patches/kotlin-0.8.1444.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.8.422 \
	    && mv dist/kotlinc ../build/kotlin-0.8.1444

build/kotlin-0.9.21: build/kotlin-0.8.1444
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.9.21 \
	    && git apply ../patches/kotlin-0.9.21.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.8.1444 \
	    && mv dist/kotlinc ../build/kotlin-0.9.21

build/kotlin-0.9.738: build/kotlin-0.9.21
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.9.738 \
	    && git apply ../patches/kotlin-0.9.738.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.9.21 \
	    && mv dist/kotlinc ../build/kotlin-0.9.738

build/kotlin-0.9.1204: build/kotlin-0.9.738
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.9.1204 \
	    && git apply ../patches/kotlin-0.9.1204.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.9.738 \
	    && mv dist/kotlinc ../build/kotlin-0.9.1204

build/kotlin-0.10.300: build/kotlin-0.9.1204
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.10.300 \
	    && git apply ../patches/kotlin-0.10.300.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-138/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-138/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-138/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.9.1204 \
	    && mv dist/kotlinc ../build/kotlin-0.10.300

# Build the IntelliJ SDK 139 (December 2014 build @ 26e72feacf91bfb222bec00b3139ed05aa3084b5)
build/intellij-community-139: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 26e72feacf91bfb222bec00b3139ed05aa3084b5 \
	    && git apply ../patches/sdk-139.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-139

build/kotlin-0.10.823: build/kotlin-0.10.300 build/intellij-community-139
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.10.823 \
	    && git apply ../patches/kotlin-0.10.823.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-139/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-139/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-139/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-139/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-139/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-139/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-139/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-139/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.10.300 \
	    && mv dist/kotlinc ../build/kotlin-0.10.823

# Build the IntelliJ SDK 141
build/intellij-community-141: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout 141 \
	    && git apply ../patches/sdk-141.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-141

build/kotlin-0.10.1023: build/kotlin-0.10.823 build/intellij-community-141
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.10.1023 \
	    && git apply ../patches/kotlin-0.10.1023.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.10.823 \
	    && mv dist/kotlinc ../build/kotlin-0.10.1023

build/kotlin-0.10.1336: build/kotlin-0.10.1023
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.10.1336 \
	    && git apply ../patches/kotlin-0.10.1336.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.10.1023 \
	    && mv dist/kotlinc ../build/kotlin-0.10.1336

build/kotlin-0.10.1426: build/kotlin-0.10.1336
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.10.1426 \
	    && git apply ../patches/kotlin-0.10.1426.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar         ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar        ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar     ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar      ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar           ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar         ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar  dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar   ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar          ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar      ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar      ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar     ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                           dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.10.1336 \
	    && mv dist/kotlinc ../build/kotlin-0.10.1426

build/kotlin-0.11.153: build/kotlin-0.10.1426
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.153 \
	    && git apply ../patches/kotlin-0.11.153.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.10.1426 \
	    && mv dist/kotlinc ../build/kotlin-0.11.153

build/kotlin-0.11.873: build/kotlin-0.11.153
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.873 \
	    && git apply ../patches/kotlin-0.11.873.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.153 \
	    && mv dist/kotlinc ../build/kotlin-0.11.873

build/kotlin-0.11.992: build/kotlin-0.11.873
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.992 \
	    && git apply ../patches/kotlin-0.11.992.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.873 \
	    && mv dist/kotlinc ../build/kotlin-0.11.992

build/kotlin-0.11.1014: build/kotlin-0.11.992
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.1014 \
	    && git apply ../patches/kotlin-0.11.1014.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.992 \
	    && mv dist/kotlinc ../build/kotlin-0.11.1014

build/kotlin-0.11.1201: build/kotlin-0.11.1014
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.1201 \
	    && git apply ../patches/kotlin-0.11.1201.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.1014 \
	    && mv dist/kotlinc ../build/kotlin-0.11.1201

build/kotlin-0.11.1393: build/kotlin-0.11.1201
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.11.1393 \
	    && git apply ../patches/kotlin-0.11.1393.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.1201 \
	    && mv dist/kotlinc ../build/kotlin-0.11.1393

build/kotlin-0.12.108: build/kotlin-0.11.1393
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.12.108 \
	    && git apply ../patches/kotlin-0.12.108.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar dependencies/jarjar.jar \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.11.1393 \
	    && mv dist/kotlinc ../build/kotlin-0.12.108

build/kotlin-0.12.115: build/kotlin-0.12.108
	cd kotlin \
	    && git reset --hard \
	    && git clean -f \
	    && git checkout build-0.12.115 \
	    && git apply ../patches/kotlin-0.12.115.patch \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.7/lib dependencies/annotations \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-141/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-141/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/jna-utils.jar             ideaSDK/lib/ \
	    && cp ../build/intellij-community-141/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar dependencies/jarjar.jar \
	    && cp /usr/share/java/jline2.jar dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.7/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.108 \
	    && mv dist/kotlinc ../build/kotlin-0.12.115
