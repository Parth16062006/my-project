# How to Run the Online Auction System

## Prerequisites

1. **Java 21** - Already installed ✓
2. **Maven 3.8+** - Needs to be installed
3. **MongoDB** - Needs to be running

## Installation Steps

### 1. Install Maven

**Option A: Using Chocolatey (Recommended for Windows)**
```powershell
choco install maven
```

**Option B: Manual Installation**
1. Download Maven from: https://maven.apache.org/download.cgi
2. Extract to a folder (e.g., `C:\Program Files\Apache\maven`)
3. Add `C:\Program Files\Apache\maven\bin` to your PATH environment variable
4. Restart your terminal

**Verify Installation:**
```powershell
mvn --version
```

### 2. Install and Start MongoDB

**Option A: Using Chocolatey**
```powershell
choco install mongodb
# Start MongoDB service
net start MongoDB
```

**Option B: Manual Installation**
1. Download MongoDB from: https://www.mongodb.com/try/download/community
2. Install and start MongoDB service
3. MongoDB should run on `localhost:27017` (default)

**Verify MongoDB is Running:**
```powershell
mongosh
# Or if using older version:
mongo
```

### 3. Build and Run the Application

Navigate to the project directory:
```powershell
cd "C:\Users\jatin\Downloads\Online-Auction-System\Online-Auction-System"
```

**Build the project:**
```powershell
mvn clean install
```

**Run the application:**
```powershell
mvn tomcat10:run
```

The application will be available at: **http://localhost:8080**

## Alternative: Using an IDE

### IntelliJ IDEA / Eclipse
1. Import the project as a Maven project
2. Configure Tomcat 10+ as the application server
3. Deploy the WAR file from `target/Online-Auction-System-1.0.0.war`
4. Start the server

### VS Code
1. Install Java Extension Pack
2. Install Maven for Java extension
3. Use the Maven sidebar to run `tomcat10:run`

## Database Configuration

The application uses MongoDB with the following default settings:
- **Connection URI:** `mongodb://localhost:27017`
- **Database Name:** `auction_system`

You can modify these in: `src/main/resources/db.properties`

## Accessing the Application

Once running, access:
- **Home Page:** http://localhost:8080
- **Browse Auctions:** http://localhost:8080/browse
- **Login:** http://localhost:8080/login.jsp
- **Register:** http://localhost:8080/register.jsp

## Default Users

You'll need to register users through the registration page. Roles available:
- **user** - Can browse and place bids
- **seller** - Can list products for auction
- **admin** - Can approve pending products (you'll need to manually set this role in MongoDB)

## Troubleshooting

1. **Port 8080 already in use:**
   - Change the port in `pom.xml` under `tomcat10-maven-plugin` configuration
   - Or stop the service using port 8080

2. **MongoDB connection error:**
   - Ensure MongoDB is running: `mongosh` or check services
   - Verify connection string in `db.properties`

3. **Build errors:**
   - Ensure Java 21 is set: `java -version`
   - Clean and rebuild: `mvn clean install`


