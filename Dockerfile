FROM jenkins/jnlp-slave

# Set desired Android Linux SDK version
ENV ANDROID_SDK_VERSION 24.4.1

ENV ANDROID_SDK_ZIP android-sdk_r$ANDROID_SDK_VERSION-linux.tgz
ENV ANDROID_SDK_ZIP_URL https://dl.google.com/android/$ANDROID_SDK_ZIP
ENV ANDROID_HOME /opt/android-sdk-linux

ENV GRADLE_ZIP gradle-3.0-bin.zip
ENV GRADLE_ZIP_URL https://services.gradle.org/distributions/$GRADLE_ZIP

ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:/opt/gradle-3.0/bin

USER root

# Init dependencies for the setup process
RUN dpkg --add-architecture i386
#RUN apt-get update && \
#       apt-get install software-properties-common python-software-properties unzip -y

# Install gradle
ADD $GRADLE_ZIP_URL /opt/
RUN unzip /opt/$GRADLE_ZIP -d /opt/ && \
       rm /opt/$GRADLE_ZIP

# Install Android SDK
ADD $ANDROID_SDK_ZIP_URL /opt/
RUN tar xzvf /opt/$ANDROID_SDK_ZIP -C /opt/ && \
       rm /opt/$ANDROID_SDK_ZIP

# Install required build-tools
RUN    echo "y" | android update sdk -u -a --filter platform-tools,android-23,build-tools-23.0.1 && \
       chmod -R 755 $ANDROID_HOME

RUN    echo "y" | android update sdk -u -a --filter platform-tools,android-24,build-tools-24.0.1 && \
       chmod -R 755 $ANDROID_HOME

RUN    echo "y" | android update sdk -u -a --filter platform-tools,android-25,build-tools-25.0.2 && \
       chmod -R 755 $ANDROID_HOME
RUN    echo "y" | android update sdk -u -a -t 192
RUN    echo "y" | android update sdk -u -a -t 13

# Install Android Support
RUN     echo "y" | android update sdk --no-ui --all --filter "extra-android-m2repository"

# Install 32-bit compatibility for 64-bit environments
RUN apt-get update
RUN apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 -y

ADD https://nodejs.org/download/release/v6.10.3/node-v6.10.3-linux-x64.tar.gz /opt/
RUN tar xzvf /opt/node-v6.10.3-linux-x64.tar.gz -C /opt/ && \
    rm /opt/node-v6.10.3-linux-x64.tar.gz
RUN ln -s /opt/node-v6.10.3-linux-x64/bin/node /usr/local/bin/node
RUN ln -s /opt/node-v6.10.3-linux-x64/bin/npm /usr/local/bin/npm
RUN npm install -g yarn
RUN ln -s /opt/node-v6.10.3-linux-x64/bin/yarn /usr/local/bin/yarn


# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
