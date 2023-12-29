# MoviesDatabase Project

## Description
MoviesDatabase is a SQL Server-based project, designed for rapid deployment in Docker. Ideal for API or software demos, it provides a pre-configured database with sample data.

## Quick Start with Docker: 
Pull and run the Docker image to get started quickly:
`docker pull ghcr.io/anthonypwatts/moviedatabase/moviesdb:main`
`docker run -d -p 1433:1433 ghcr.io/anthonypwatts/moviedatabase/moviesdb:main`

This command will start the Docker container in detached mode (-d) and map port 1433 from the container to port 1433 on the host machine, allowing SQL Server connections.

## Features
- SQL Server setup in Docker.
- Automated database initialization with `CombinedInit.sql`.
- Sample data for movies and actors.


## Using the Repository
For customization or development:
1. Clone this repository.
2. Optionally change the SA password throughout.
3. Build the Docker image: `docker build -t mssql-moviesdb .`
4. Run the Docker container: `docker run -d -p 1433:1433 mssql-moviesdb`



## Usage
Connect to the SQL Server instance using tools like Azure Data Studio or SQL Server Management Studio:
- Server: `localhost,1433`
- Authentication: SQL Server Authentication
- Username: `sa`
- Password: [Your sa password]. Wait, did you just keep the one I hoofed in? Because it's just a demo, right? Never going live without changing it... right? Shocking.

## Contributing
Contributions to the MoviesDatabase project are welcome. Please fork the repository and submit a pull request with your changes.

## License
Go forth and use my code!

## Contact
Tony Watts - anthonypwatts@gmail.com
