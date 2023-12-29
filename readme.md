# MoviesDatabase Project

## Description
MoviesDatabase is a SQL Server-based project, set up within a Docker container, designed for rapid deployment and ease of use. It serves as an ideal starting point for anyone looking to expedite the creation of API or other software demos. With a pre-configured database and sample data for movies and actors, it offers a quick-to-get-running DB environment, allowing developers to focus on their application logic rather than database setup. This makes it a valuable tool for demonstrations, prototypes, or any scenario where a reliable and easy-to-set-up database is needed.
## Features
- SQL Server setup in Docker.
- Automated database initialization with `CombinedInit.sql`.
- Sample data for movies and actors.

## Installation
1. Clone this repository.
2. Consider changing the sa password!
2. Build the Docker image: `docker build -t mssql-moviesdb .`
3. Run the Docker container: `docker run -d -p 1433:1433 mssql-moviesdb`

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
