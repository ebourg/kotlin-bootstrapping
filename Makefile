#
# Kotlin bootstrapping
#

.PHONY: bootstrap init clean

bootstrap: init build/kotlin-1.0.0-beta-3070

init:
	mkdir -p build dependencies

clean:
	rm -Rf build

# Cleans up the Kotlin source directory, checkouts the specified tag and applies the patch
define kcheckout
	cd kotlin && git reset --hard && git clean -fdx && git checkout build-$(1) && git apply ../patches/kotlin-$(1).patch
endef

intellij-community:
	git clone https://github.com/JetBrains/intellij-community

# Build the IntelliJ SDK 133
build/intellij-community-133: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -fdx \
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
	$(call kcheckout,0.6.786)
	cd kotlin \
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
	$(call kcheckout,0.6.1364)
	cd kotlin \
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
	$(call kcheckout,0.6.1932)
	cd kotlin \
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
	$(call kcheckout,0.6.2107)
	cd kotlin \
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
	$(call kcheckout,0.6.2338)
	cd kotlin \
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
	    && git clean -fdx \
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
	$(call kcheckout,0.6.2451)
	cd kotlin \
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
	$(call kcheckout,0.6.2516)
	cd kotlin \
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
	$(call kcheckout,0.7.333)
	cd kotlin \
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
	    && git clean -fdx \
	    && git checkout 135 \
	    && git apply ../patches/sdk-135.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-135

build/kotlin-0.7.638: build/kotlin-0.7.333 build/intellij-community-135
	$(call kcheckout,0.7.638)
	cd kotlin \
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

build/kotlin-0.7.1214: build/kotlin-0.7.638
	$(call kcheckout,0.7.1214)
	cd kotlin \
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
	    && mv dist/kotlinc ../build/kotlin-0.7.1214

# Build the IntelliJ SDK 138
build/intellij-community-138: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -fdx \
	    && git checkout 070c64f86da3bfd3c86f151c75aefeb4f67870c8 \
	    && git apply ../patches/sdk-138.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-138

build/kotlin-0.8.84: build/kotlin-0.7.1214 build/intellij-community-138
	$(call kcheckout,0.8.84)
	cd kotlin \
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
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.7.1214 \
	    && mv dist/kotlinc ../build/kotlin-0.8.84

build/kotlin-0.8.409: build/kotlin-0.8.84
	$(call kcheckout,0.8.409)
	cd kotlin \
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
	$(call kcheckout,0.8.418)
	cd kotlin \
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
	$(call kcheckout,0.8.422)
	cd kotlin \
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
	$(call kcheckout,0.8.1444)
	cd kotlin \
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
	$(call kcheckout,0.9.21)
	cd kotlin \
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
	$(call kcheckout,0.9.738)
	cd kotlin \
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
	$(call kcheckout,0.9.1204)
	cd kotlin \
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
	$(call kcheckout,0.10.300)
	cd kotlin \
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
	    && git clean -fdx \
	    && git checkout 26e72feacf91bfb222bec00b3139ed05aa3084b5 \
	    && git apply ../patches/sdk-139.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-139

build/kotlin-0.10.823: build/kotlin-0.10.300 build/intellij-community-139
	$(call kcheckout,0.10.823)
	cd kotlin \
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
	    && git clean -fdx \
	    && git checkout 141 \
	    && git apply ../patches/sdk-141.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-141

build/kotlin-0.10.1023: build/kotlin-0.10.823 build/intellij-community-141
	$(call kcheckout,0.10.1023)
	cd kotlin \
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
	$(call kcheckout,0.10.1336)
	cd kotlin \
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
	$(call kcheckout,0.10.1426)
	cd kotlin \
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
	$(call kcheckout,0.11.153)
	cd kotlin \
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
	$(call kcheckout,0.11.873)
	cd kotlin \
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
	$(call kcheckout,0.11.992)
	cd kotlin \
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
	$(call kcheckout,0.11.1014)
	cd kotlin \
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
	$(call kcheckout,0.11.1201)
	cd kotlin \
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
	$(call kcheckout,0.11.1393)
	cd kotlin \
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
	$(call kcheckout,0.12.108)
	cd kotlin \
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
	$(call kcheckout,0.12.115)
	cd kotlin \
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

build/kotlin-0.12.176: build/kotlin-0.12.115
	$(call kcheckout,0.12.176)
	cd kotlin \
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
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.115 \
	    && mv dist/kotlinc ../build/kotlin-0.12.176

build/kotlin-0.12.470: build/kotlin-0.12.176
	$(call kcheckout,0.12.470)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
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
	    && cp /usr/share/ant/lib/ant.jar dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.176 \
	    && mv dist/kotlinc ../build/kotlin-0.12.470

# Build the IntelliJ SDK 143
build/intellij-community-143: | intellij-community
	cd intellij-community \
	    && git reset --hard \
	    && git clean -fdx \
	    && git checkout 143 \
	    && git apply ../patches/sdk-143.patch \
	    && ant \
	    && rm -Rf out/classes out/artifacts/*.zip out/artifacts/*.tar.gz out/dist.win.ce out/dist.mac.ce out/dist.all.ce/plugins \
	    && mv out ../build/intellij-community-143

build/kotlin-0.12.1077: build/kotlin-0.12.470 build/intellij-community-143
	$(call kcheckout,0.12.1077)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.470 \
	    && mv dist/kotlinc ../build/kotlin-0.12.1077

build/kotlin-0.12.1250: build/kotlin-0.12.1077
	$(call kcheckout,0.12.1250)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.1077 \
	    && mv dist/kotlinc ../build/kotlin-0.12.1250

build/kotlin-0.12.1306: build/kotlin-0.12.1250
	$(call kcheckout,0.12.1306)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.1250 \
	    && mv dist/kotlinc ../build/kotlin-0.12.1306

build/kotlin-0.13.177: build/kotlin-0.12.1306
	$(call kcheckout,0.13.177)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.12.1306 \
	    && mv dist/kotlinc ../build/kotlin-0.13.177

build/kotlin-0.13.791: build/kotlin-0.13.177
	$(call kcheckout,0.13.791)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.13.177 \
	    && mv dist/kotlinc ../build/kotlin-0.13.791

build/kotlin-0.13.899: build/kotlin-0.13.791
	$(call kcheckout,0.13.899)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.13.791 \
	    && mv dist/kotlinc ../build/kotlin-0.13.899

build/kotlin-0.13.1118: build/kotlin-0.13.899
	$(call kcheckout,0.13.1118)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.13.899 \
	    && mv dist/kotlinc ../build/kotlin-0.13.1118

build/kotlin-0.13.1304: build/kotlin-0.13.1118
	$(call kcheckout,0.13.1304)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.13.1118 \
	    && mv dist/kotlinc ../build/kotlin-0.13.1304

build/kotlin-0.14.209: build/kotlin-0.13.1304
	$(call kcheckout,0.14.209)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.13.1304 \
	    && mv dist/kotlinc ../build/kotlin-0.14.209

build/kotlin-0.14.398: build/kotlin-0.14.209
	$(call kcheckout,0.14.398)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.14.209 \
	    && mv dist/kotlinc ../build/kotlin-0.14.398

build/kotlin-0.15.8: build/kotlin-0.14.398
	$(call kcheckout,0.15.8)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.14.398 \
	    && mv dist/kotlinc ../build/kotlin-0.15.8

build/kotlin-0.15.394: build/kotlin-0.15.8
	$(call kcheckout,0.15.394)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.15.8 \
	    && mv dist/kotlinc ../build/kotlin-0.15.394

build/kotlin-0.15.541: build/kotlin-0.15.394
	$(call kcheckout,0.15.541)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.15.394 \
	    && mv dist/kotlinc ../build/kotlin-0.15.541

build/kotlin-0.15.604: build/kotlin-0.15.541
	$(call kcheckout,0.15.604)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.15.541 \
	    && mv dist/kotlinc ../build/kotlin-0.15.604

build/kotlin-0.15.723: build/kotlin-0.15.604
	$(call kcheckout,0.15.723)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.15.604 \
	    && mv dist/kotlinc ../build/kotlin-0.15.723

build/kotlin-1.0.0-beta-2055: build/kotlin-0.15.723
	$(call kcheckout,1.0.0-beta-2055)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-0.15.723 \
	    && mv dist/kotlinc ../build/kotlin-1.0.0-beta-2055

build/kotlin-1.0.0-beta-3070: build/kotlin-1.0.0-beta-2055
	$(call kcheckout,1.0.0-beta-3070)
	cd kotlin \
	    && rm -Rf ideaSDK dependencies \
	    && mkdir -p ideaSDK/lib ideaSDK/core ideaSDK/core-analysis ideaSDK/jps \
	    && mkdir -p dependencies/ant-1.8/lib dependencies/annotations \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/javac2.jar                ideaSDK/lib \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/asm-all.jar               ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/annotations.jar            ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/guava-17.0.jar             ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/intellij-core-analysis.jar ideaSDK/core-analysis/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jdom.jar                  ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/protobuf-2.5.0.jar        dependencies/protobuf-2.5.0-lite.jar \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/core/ \
	    && cp ../build/intellij-community-143/artifacts/core/trove4j.jar                ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/artifacts/core/cli-parser-1.1.jar         dependencies/cli-parser-1.1.1.jar \
	    && cp ../build/intellij-community-143/artifacts/core/picocontainer.jar          ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/core/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/log4j.jar                 ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jps-model.jar             ideaSDK/jps/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/jna-platform.jar          ideaSDK/lib/ \
	    && cp ../build/intellij-community-143/dist.all.ce/lib/oromatcher.jar            ideaSDK/lib/ \
	    && cp ../dependencies/kotlin-*-annotations.jar                                  dependencies/annotations \
	    && cp /usr/share/java/jarjar.jar          dependencies/jarjar.jar \
	    && cp /usr/share/java/hawtjni-runtime.jar dependencies/hawtjni-runtime.jar \
	    && cp /usr/share/java/jansi.jar           dependencies/jansi.jar \
	    && cp /usr/share/java/jansi-native.jar    dependencies/jansi-native.jar \
	    && cp /usr/share/java/jline2.jar          dependencies/jline.jar \
	    && cp /usr/share/java/native-platform.jar dependencies/native-platform-uberjar.jar \
	    && cp /usr/share/ant/lib/ant.jar          dependencies/ant-1.8/lib/ \
	    && ANT_OPTS=-noverify ant -Dshrink=false -Dgenerate.javadoc=false -Dbootstrap.build.no.tests=true -Dbootstrap.compiler.home=../build/kotlin-1.0.0-beta-2055 \
	    && mv dist/kotlinc ../build/kotlin-1.0.0-beta-3070
