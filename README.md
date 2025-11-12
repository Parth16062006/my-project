# Online Auction System

A web-based auction system built with Java EE technologies, allowing users to list items for auction and place bids on items.

## Technologies Used

- Java 21
- Jakarta EE 10 (Servlets, JSP)
- MongoDB
- Maven
- BCrypt for password hashing

## Prerequisites

- JDK 21
- Maven 3.8+
- MongoDB 5.0+
- A Jakarta EE compatible application server (e.g., Apache Tomcat 10+)

## Setup Instructions

1. **Database Setup**
   - Ensure MongoDB is running on your system
   - MongoDB will automatically create the database and collections when the application runs

2. **Configure Database Connection**
   - Update MongoDB connection string in `src/main/resources/db.properties` if needed (default: `mongodb://localhost:27017`)

3. **Build the Project**
   ```bash
   mvn clean install
   ```

4. **Deploy the Application**
   - Copy the generated WAR file from `target/Online-Auction-System-1.0.0.war` to your application server's webapps directory

## Features

- User registration and authentication
- Create and manage auction listings
- Place bids on items
- Real-time notifications for bid updates
- Secure payment processing
- Admin dashboard for system management

## Project Structure

```
src/main/
├── java/com/onlineauction/
│   ├── controller/    # Servlet controllers
│   ├── dao/          # Data Access Objects
│   ├── model/        # Entity classes
│   ├── service/      # Business logic
│   └── util/         # Utility classes
├── resources/
│   └── database_schema.sql
└── webapp/
    ├── WEB-INF/
    │   └── web.xml   # Deployment descriptor
    ├── css/
    ├── js/
    └── jsp/          # JSP pages
```

## Security Features

- Password hashing using BCrypt
- CSRF protection
- Input validation
- Session management
- NoSQL injection prevention

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.