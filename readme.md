# SQLDockerDeployKit Project

## Description
A versatile tool for deploying SQL Server databases in Docker containers. Ideal for rapid setup of database environments for development, testing, and demonstrations.

---

## Quicklinks

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAnthonyPWatts%2FSQLDockerDeployKit%2Fmain%2Fazure-resource-manager-template.json)

 [GitHub Container Registry Image](https://github.com/AnthonyPWatts?tab=packages&repo_name=SQLDockerDeployKit)

---

## Overview
The SQLDockerDeployKit is a highly efficient and flexible tool designed to streamline the deployment of SQL Server databases within Docker containers. This project aims to simplify the initial setup and management of database environments, catering to a wide range of needs from development and testing to live demonstrations. Whether you are a developer, a database administrator, or a student learning SQL Server, the SQLDockerDeployKit offers a quick and easy way to get your database up and running with minimal setup.

### Key Features and Advantages
- Ease of Use: With a focus on simplicity, the SQLDockerDeployKit allows for the quick provisioning of SQL Server instances, eliminating the complexities traditionally associated with database setup.
- Flexibility: Catering to various requirements, the tool supports multiple deployment options, including local Docker environments and cloud-based solutions like Azure. This flexibility ensures that users can select the deployment method that best suits their needs.
- Customization: Understanding that no two database applications are the same, the SQLDockerDeployKit is designed to be highly customizable. Users can easily adapt the tool to deploy different database schemas and utilize automated SQL scripts for database initialization.
- Rapid Development and Testing: The tool is an excellent asset for developers and QA engineers looking for a fast way to spin up SQL Server instances for application development, testing, or bug reproduction.

### Intended Users
- Software Developers: Quickly integrate and test database interactions with your applications without the overhead of complex database setup procedures.
- Database Administrators and DBA Students: Learn and experiment with SQL Server configurations, performance tuning, and security settings in a controlled, easily resettable environment.
- Demo and Training Providers: Create consistent, reproducible database environments for training sessions, workshops, or product demonstrations, ensuring that all participants have a uniform starting point.

### Use Cases
- Application Development: Streamline the development process by quickly setting up and tearing down database environments, allowing more time to focus on application logic and user experience.
- Testing Environments: Easily create and duplicate test databases to isolate test cases, ensuring accurate and reliable results.
- Educational Purposes: Provide students with a simple way to access and manage SQL Server databases, facilitating hands-on learning and experimentation.
- Demo Environments: Showcase software products or data-driven applications in a stable, controlled environment, enhancing the impact of your presentations.

By utilizing the SQLDockerDeployKit, users can significantly reduce the time and effort required to manage SQL Server databases, allowing them to focus on their core activities, whether it be development, testing, learning, or showcasing products.


### GitHub Repository Features
- Any commits to the main branch trigger an update of this project's [GitHub Container Registry Image](https://github.com/AnthonyPWatts?tab=packages&repo_name=SQLDockerDeployKit).

---

## Deployment Options
### Option 1 - Quick Start with Docker
####  (if you want to work with the unchanged MoviesDB, running locally)
Pull the image from the GitHub Container Registry:
```shell 
docker pull ghcr.io/anthonypwatts/sqldockerdeploykit/moviesdb:main
```

Start the Docker container in detached mode (-d) and map port 1433 from the container to port 1433 on the host machine, allowing SQL Server connections:
```shell
docker run -d -p 1433:1433 ghcr.io/anthonypwatts/sqldockerdeploykit/moviesdb:main
```


### Option 2 - Deploy to Azure
####  (if you want to work with the unchanged MoviesDB, running in the cloud)
Deploy the latest build of this project's image (as generated in the CI/CD pipeline and deployed to GitHub Container Registry) to Azure Container Instances using the Azure Resource Manager (ARM) template. The template is configured to set up the environment with reasonable default configurations and ports.

Click the "Deploy to Azure" button below. You'll be redirected to the Azure portal.

Fill in the necessary parameters and deploy.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAnthonyPWatts%2FSQLDockerDeployKit%2Fmain%2Fazure-resource-manager-template.json)

---

## Extending and Customizing
For customization or development:
1. Fork or clone this repository as appropriate.
2. If forked, change the sa password used in `Dockerfile` and in `entrypoint.sh`.
3. Amend the SQL in src/SQLScripts as required. Note that the scripts are executed sequentially, so follow the 001, 002, 003 pattern.
4. Build the Docker image from the src folder (you can replace 'sqldockerdeploykit' with your preferred image name): 
```shell
docker build -t sqldockerdeploykit .
```
5. Run the Docker container: 
```shell
docker run --name myDatabaseContainer -d -p 1433:1433 sqldockerdeploykit
```
6. Use or amend the provided ARM template for easy Azure deployments.

---

## Connecting to the Database
Connect to the SQL Server instance using tools like Azure Data Studio or SQL Server Management Studio:
- Server: e.g., `localhost,1433`
- Authentication: SQL Server Authentication
- Username: `sa`
- Password: [Your sa password] or if unchanged the image default is: `<YourStrong!Passw0rd>`

![ADS Connection](project-docs/images/ads-connected-local.png "Azure Data Studio Local Connection")

### TIP: Changing the SA Password:
General instructions for changing the SA password on SQL Server:
1. Connect to your SQL Server instance using SQL Server Management Studio or another SQL client. (the default password is: `<YourStrong!Passw0rd>`)
2. Once connected, open a new query window.
3. Run the following SQL command:
    `ALTER LOGIN sa WITH PASSWORD = 'YourNewStrongPassword!';`
    (Replace `YourNewStrongPassword!` with your desired new password. Ensure your new password adheres to SQL Server's password policy for security)
4. Execute the query to update the password.

---

## Contributing
Contributions to the SQLDockerDeployKit project are welcome. Please fork the repository and submit a pull request with your changes.

## License

This project is released into the public domain. Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, for any purpose, commercial or non-commercial, and by any means. There are no restrictions. Use it as you see fit.



## Contact
Tony Watts - anthonypwatts@gmail.com
