# aws-iot-greengrass-hello-world

This project demonstrates how to run AWS IoT based on the different steps explained on the offical AWS documentation  [offical AWS documentation](https://docs.aws.amazon.com/greengrass/latest/developerguide/gg-gs.html).  
  
This project try to do the most steps in an automatic way with `terraform`, `AWS CLI` and by using `IoT Greengrass Core` as a ready-to-use Docker Image. In order to have a computation unit for IoT Greengrass Core, `AWS Fargate` and `AWS ECS` is used to have the opportunity to run the IoT Greengrass Core in a Docker Image. `AWS EFS` is used for mounting a directory with the necessary certifications, keys, configs and log directory.  
To clearly differentiate from the AWS IoT Greengrass documentation, AWS Fargate and AWS ECS is not used in the documentation. There you need to run it locally or somewhere else.  
  
In this project `IoT greengrass Core` is running inside a docker container and is hosted on ECS based on fargate. Following services are used:  
* ECS: https://aws.amazon.com/ecs/
* Fargate: https://aws.amazon.com/fargate/
* IoT Greengrass: https://aws.amazon.com/greengrass/
* IoT Greengrass Core in Docker Container: https://docs.aws.amazon.com/greengrass/latest/developerguide/run-gg-in-docker-container.html
* AWS EFS: https://aws.amazon.com/efs/

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

`cluster` contains of the tf code to provision ECS, Fargate, jump server and networking.  
`greengrass` takes care of provision things, IoT Greengrass Core and Greengrass Group.

# How to run the code?

**Be aware of shutting down your ressources again. This can end up in high prices, because an `public AWS endpoint` is used for `MQTT communication`. Also `jump server` and `IoT Greengrass Core` are running on a fargate based cluster as long as you don't turn them off again!**  
  
Following steps should provide you an understanding how to set up the infrastructure:
1. `terraform apply` to all resources in `cluster` folder
2. `terraform apply` in all resources in `greengrass` folder. This are core, thing1, thing2 and the policy directly in the greengrass folder.
3. Run the commands step by step in the commands file in `greengrass/group`. 
4. Run the `jump server ECS task` in order to have access to the jump server. 
5. run the script `getCertsFromTerraform.sh` to get the created certificates. They will be saved in the mounting folder.
6. Use `SCP` or another programm to transfer the mounting folder to the provisioned AWS EFS. These files will be read by IoT Greengrass Core.
7. Run the `greengrass core ECS task` in order to boot IoT Greengrass Core.
8. Check the `public IP Adress` of the running `greengrass Core ECS task` and copy it to `IoT Greengrass Core Device Connectivity` in the Greengras Group.
9. Go to the `IoT Greengrass console` and Deploy the group.
10. Check the log files by using the `jump Server` if there are no error messages. `/greengrass/gcc/var/log/system/runtime.log`
11. Start `thing1` and `thing2` by running the scripts `run.sh` in each of these folders. For this you need to install some AWS Python libs.
12. You should see messages sent from `thing1` to `thing2` and also messages sent to IoT from `IoT Greengrass Core`.
12. Enjoy! Some steps needs to be more in an automatic way, but the time will come!  

# Next steps

* As a next step I want to move the `things` also to the ECS Fargate based cluster, to have a everything-out-of-the-box solution and more importantly to keep the network traffic inside AWS to save costs.  
* Moreover you may notice, that at the time writing the code (Jun 2020), there was (is) no terraform support for `IoT Greengrass` available. As soon as this is GA, I would be more then happy to improve the automatic way of setting up the infrastructure.  
* Extend the documentation. Currently it's complicated to setup the infrastructure. This needs to be more easy.