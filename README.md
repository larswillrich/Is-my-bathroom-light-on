# aws-iot-greengrass-hello-world

This project demonstrates how to run AWS IoT based on the different steps explained on the offical AWS documentation  [offical AWS documentation](https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-gs.html).  
  
This project try to do the most steps in an automatic way with terraform, AWS CLI and by using IoT Greengrass Core as a ready-to-use Docker Image. In order to have a computation unit for IoT Greengrass Core, AWS Fargate and AWS ECS is used to have the opportunity to run the IoT Greengrass Core in a Docker Image.
To clearly differentiate from the AWS IoT Greengrass documentation, AWS Fargate and AWS ECS is not used in the documentation. There you need to run it locally or somewhere else.  
  
In this project `IoT greengrass Core` is running inside a docker container and is hosted on ECS based on fargate.
* ECS: https://aws.amazon.com/ecs/
* Fargate: https://aws.amazon.com/fargate/
* IoT Greengrass: https://aws.amazon.com/greengrass/
* IoT Greengrass Core in Docker Container: https://docs.aws.amazon.com/greengrass/latest/developerguide/run-gg-in-docker-container.html

# Where are the things?

This project contains out of 2 things managed by an IoT Greengrass Group.
* Thing1: /greengrass/thing1
* Thing2: /greengrass/thing2
  
The `hello world` example sends a message from thing1 to thing2 periodically.  
For now you need to run the `things` locally on your computer by using the run.sh script.  

# Structure of the project

There are two important folders.
* cluster
* greengrass

`cluster` contains of the tf code to provision ECS, Fargate and networking.  
`greengrass` takes care of provision things, IoT Greengrass Core and Greengrass Group.

# How to run the code?

You should first provision the cluster by using terraform and then run the provided commands and partly terraform code in the greengrass folder.  

# Next steps

* As a next step I want to move the `things` also to the ECS Fargate based cluster, to have a everything-out-of-the-box solution and more importantly to keep the network traffic inside AWS to save costs.  
* Moreover you may notice, that at the time writing the code (Jun 2020), there was (is) no terraform support for `IoT Greengrass` available. As soon as this is GA, I would be more then happy to improve the automatic way of setting up the infrastructure.  
* Extend the documentation. Currently it's complicated to setup the infrastructure. This needs to be more easy.