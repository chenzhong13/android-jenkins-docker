# Building the image
Run the command
>docker build -t android-jenkins-slave .

# Run the image
Run the command
>docker run --name android-jenkins-slave -u 0 android-jenkins-slave -url http://jenkins.dev.waiverforever.com  4517a38643117e7dcb0cae28848281a2d862c6730e749ab1d56c67cb0169c887  android-builder2
