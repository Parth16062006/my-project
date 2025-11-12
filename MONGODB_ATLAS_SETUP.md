# MongoDB Atlas Setup

## Connection Configuration

The project is now configured to connect to MongoDB Atlas using the following connection string:

```
mongodb+srv://password738:password738@cluster0.b9nr2og.mongodb.net/
```

## Configuration Files

### db.properties
Located at: `src/main/resources/db.properties`

```properties
# MongoDB Atlas configuration
mongodb.uri=mongodb+srv://password738:password738@cluster0.b9nr2og.mongodb.net/?retryWrites=true&w=majority
mongodb.database=auction_system
```

## Connection Details

- **Protocol**: `mongodb+srv://` (MongoDB Atlas connection protocol)
- **Username**: `password738`
- **Password**: `password738`
- **Cluster**: `cluster0.b9nr2og.mongodb.net`
- **Database**: `auction_system`
- **Connection Options**: 
  - `retryWrites=true` - Automatically retry write operations
  - `w=majority` - Wait for majority of replicas to confirm writes

## MongoDB Atlas Requirements

### 1. Network Access
Ensure your IP address is whitelisted in MongoDB Atlas:
1. Go to MongoDB Atlas Dashboard
2. Navigate to **Network Access**
3. Add your IP address or use `0.0.0.0/0` for development (not recommended for production)

### 2. Database User
The connection uses a database user with:
- Username: `password738`
- Password: `password738`
- Ensure this user has appropriate permissions (read/write access)

### 3. Cluster Status
Ensure your MongoDB Atlas cluster is running and accessible.

## Testing the Connection

### Method 1: Run the Application
When you start the application, check the console logs for:
```
Successfully connected to MongoDB Atlas
Database: auction_system
```

### Method 2: Test Servlet
You can use the `TestMongoServlet` (if it exists) to test the connection.

### Method 3: Check Application Logs
If there are connection errors, they will be displayed in the application logs.

## Troubleshooting

### Connection Timeout
- Check if your IP is whitelisted in MongoDB Atlas
- Verify the cluster is running
- Check firewall settings

### Authentication Failed
- Verify username and password are correct
- Ensure the database user exists in MongoDB Atlas
- Check user permissions

### SSL/TLS Issues
- `mongodb+srv://` automatically handles SSL/TLS
- No additional SSL configuration needed
- Ensure your Java environment supports TLS 1.2+

### Connection String Format
The connection string format is:
```
mongodb+srv://[username]:[password]@[cluster]/[database]?[options]
```

For URL-encoded passwords with special characters, use:
```
mongodb+srv://username:%40password@cluster/database
```

## Database Collections

The application will automatically create the following collections when needed:
- `users` - User accounts
- `products` - Auction products
- `bids` - Bidding records
- `notifications` - User notifications
- `payments` - Payment records

## Security Notes

⚠️ **Important Security Considerations:**

1. **Credentials**: The credentials are stored in `db.properties`. For production:
   - Use environment variables
   - Use a secrets management system
   - Never commit credentials to version control

2. **Network Access**: 
   - Restrict IP whitelist to specific IPs in production
   - Don't use `0.0.0.0/0` in production

3. **Database User**:
   - Use a dedicated database user with minimal required permissions
   - Use strong passwords
   - Rotate passwords regularly

## Next Steps

1. **Rebuild the project**:
   ```bash
   mvn clean install
   ```

2. **Start the application**:
   ```bash
   mvn tomcat10:run
   ```

3. **Verify connection**: Check console logs for successful connection message

4. **Test the application**: Register a user, create products, place bids

## Environment Variables (Optional)

For better security, you can use environment variables:

1. Set environment variables:
   ```bash
   export MONGODB_URI="mongodb+srv://password738:password738@cluster0.b9nr2og.mongodb.net/?retryWrites=true&w=majority"
   export MONGODB_DATABASE="auction_system"
   ```

2. Update `DatabaseUtil.java` to read from environment variables as fallback:
   ```java
   String connectionString = System.getenv("MONGODB_URI");
   if (connectionString == null) {
       connectionString = properties.getProperty("mongodb.uri");
   }
   ```

## Support

If you encounter connection issues:
1. Check MongoDB Atlas dashboard for cluster status
2. Verify network access settings
3. Check application logs for detailed error messages
4. Verify the connection string format is correct

