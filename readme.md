# MoviesDatabase Project

## Description
MoviesDatabase is a SQL Server-based project, designed for rapid deployment in Docker. Ideal for API or software demos, it provides a pre-configured database with sample data.


## Features
- SQL Server setup in Docker.
- Automated database initialization with `CombinedInit.sql`.
- Sample data for movies and actors.


## Use Case 1 - Quick Start with Docker
Pull and run the Docker image to get started quickly:
`docker pull ghcr.io/anthonypwatts/moviedatabase/moviesdb:main`

This command will start the Docker container in detached mode (-d) and map port 1433 from the container to port 1433 on the host machine, allowing SQL Server connections.
`docker run -d -p 1433:1433 ghcr.io/anthonypwatts/moviedatabase/moviesdb:main`


## Use Case 2 - Deploy to Azure
Now, you can deploy the MoviesDatabase to Azure Container Instances using the ARM template. The template is configured to set up the environment with reasonable default configurations and ports.

Click the "Deploy to Azure" button below. You'll be redirected to the Azure portal.

Fill in the necessary parameters and deploy.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAnthonyPWatts%2FMovieDatabase%2Fmain%2Fazure-deploy-moviedb.json)


## Use Case 3 - Using the Repository
For customization or development:
1. Clone this repository.
2. Change the sa password throughout.
3. Build the Docker image: `docker build -t mssql-moviesdb .`
4. Run the Docker container: `docker run -d -p 1433:1433 mssql-moviesdb`


## Connecting to the Database
Connect to the SQL Server instance using tools like Azure Data Studio or SQL Server Management Studio:
- Server: `localhost,1433`
- Authentication: SQL Server Authentication
- Username: `sa`
- Password: [Your sa password] or if unchanged the image default is: `<YourStrong!Passw0rd>`

## Contributing
Contributions to the MoviesDatabase project are welcome. Please fork the repository and submit a pull request with your changes.

## License
Go forth and use my code!

## Contact
Tony Watts - anthonypwatts@gmail.com
