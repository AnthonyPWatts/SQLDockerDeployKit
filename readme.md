# SQLDockerDeployKit Project

## Description
Originally designed for a 'Movies' database demo, this project has evolved into a versatile tool for deploying SQL Server databases in Docker containers. It's ideal for rapid setup of database environments in development, testing, and demonstrations.

## Features
- Quick SQL Server setup in Docker for rapid deployment.
- Customizable database configurations: Dynamically set database names and SA passwords using environment variables for flexible deployments.
- Automated database initialization with `CombinedInit.sql`, adaptable for various database schemas.
- Environment variable integration allows for easy customization of database settings at container run-time, enhancing security and flexibility.
- Flexible deployment options: Easily deployable in both Docker and Azure environments, suitable for development, testing, and demonstration purposes.

## Deployment Options
### Option 1 - Quick Start with Docker
Pull the image from the GitHub Container Registry:
```shell 
docker pull ghcr.io/anthonypwatts/sqldockerdeploykit/moviesdb:main
```

Start the Docker container in detached mode (-d) and map port 1433 from the container to port 1433 on the host machine, allowing SQL Server connections:
```shell
docker run \
  --name mySQLDockerContainer 
  -e DB_NAME=myDatabase \
  -e SA_PASSWORD=MyNewStrong!Passw0rd \
  -d -p 1433:1433 \
  ghcr.io/anthonypwatts/sqldockerdeploykit/moviesdb:main
```


### Option 2 - Deploy to Azure
Deploy the latest build of this project's image (as generated in the CI/CD pipeline and deployed to GitHub Container Registry) to Azure Container Instances using the Azure Resource Manager (ARM) template. The template is configured to set up the environment with reasonable default configurations and ports.

Click the "Deploy to Azure" button below. You'll be redirected to the Azure portal.

Fill in the necessary parameters and deploy.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAnthonyPWatts%2FSQLDockerDeployKit%2Fmain%2Fazure-resource-manager-template.json)

## Extending and Customising
This project is designed for flexibility and can be tailored to fit specific needs:


1. **Environment Variable Customisation**: Customise your database at runtime using environment variables. Set DB_NAME and SA_PASSWORD for personalising database name and SA password.

    Example Command:
    ```shell
    docker run -e DB_NAME=myCustomDb -e SA_PASSWORD=mySecurePassword -d -p 1433:1433 [Docker Image]
    ```

2. **SQL Script Customisation**: Alter CombinedInit.sql or use your own script for a custom database schema.

3. **Build and Run Your Custom Docker Image**: After changes, build the image (`docker build -t myCustomSqlDb .`), then run it (`docker run -d -p 1433:1433 myCustomSqlDb`).

4. **ARM Template for Azure**: Use or modify the included ARM template for easy Azure deployment.



For customization or development:
1. Fork or clone this repository as appropriate.
2. If forked, change the sa password used in `Dockerfile` and in `entrypoint.sh`.
3. Amend as required, e.g. replacing `CombinedInit.sql`
4. Build the Docker image: 
```shell
docker build -t mssql-moviesdb .
```
5. Run the Docker container: 
```shell
docker run -d -p 1433:1433 mssql-moviesdb
```
6. Use or amend the provided ARM template for easy Azure deployments.

## Connecting to the Database
Connect to the SQL Server instance using tools like Azure Data Studio or SQL Server Management Studio:
- Server: e.g., `localhost,1433`
- Authentication: SQL Server Authentication
- Username: `sa`
- Password: [Your sa password] or if unchanged the image default is: `<YourStrong!Passw0rd>`


### TIP: Changing the SA Password:
General instructions for changing the SA password on SQL Server:
1. Connect to your SQL Server instance using SQL Server Management Studio or another SQL client. (the default password is: `<YourStrong!Passw0rd>`)
2. Once connected, open a new query window.
3. Run the following SQL command:
    `ALTER LOGIN sa WITH PASSWORD = 'YourNewStrongPassword!';`
    (Replace `YourNewStrongPassword!` with your desired new password. Ensure your new password adheres to SQL Server's password policy for security)
4. Execute the query to update the password.


## Contributing
Contributions to the SQLDockerDeployKit project are welcome. Please fork the repository and submit a pull request with your changes.

## License
Go forth and use my code!

## Contact
Tony Watts - anthonypwatts@gmail.com
