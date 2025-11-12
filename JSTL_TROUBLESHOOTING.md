# JSTL Troubleshooting Guide

## Error
```
java.lang.NoClassDefFoundError: jakarta/servlet/jsp/jstl/core/ConditionalTagSupport
```

## Current Setup
- **JSTL API**: `jakarta.servlet.jsp.jstl-api:3.0.0`
- **JSTL Implementation**: `org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.0`
- **Taglib URI in JSP**: `jakarta.tags.core` ✅ (correct for Jakarta EE 10)

## Steps to Fix

### Step 1: Clean and Rebuild
```bash
mvn clean install
```

### Step 2: Verify JAR is in WAR
Check that `jakarta.servlet.jsp.jstl-3.0.0.jar` is in:
```
target/Online-Auction-System-1.0.0/WEB-INF/lib/
```

### Step 3: Check JAR Contents (Optional)
If the error persists, verify the JAR contains implementation classes:
```bash
jar tf target/Online-Auction-System-1.0.0/WEB-INF/lib/jakarta.servlet.jsp.jstl-3.0.0.jar | grep ConditionalTagSupport
```

### Step 4: Alternative Solution - Use Different Implementation
If Glassfish implementation doesn't work, try this in `pom.xml`:

```xml
<!-- Remove existing JSTL dependencies and add these: -->
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>org.apache.taglibs</groupId>
    <artifactId>taglibs-standard-spec</artifactId>
    <version>1.2.6</version>
</dependency>
<dependency>
    <groupId>org.apache.taglibs</groupId>
    <artifactId>taglibs-standard-impl</artifactId>
    <version>1.2.6</version>
</dependency>
```

**Note**: Apache Taglibs uses Jakarta namespace, but you may need to update JSP taglib URIs to match.

### Step 5: Verify Tomcat Version
Ensure you're using **Tomcat 10.1.x** or later:
- Tomcat 10.0.x may have compatibility issues
- Tomcat 10.1+ fully supports Jakarta EE 10

### Step 6: Check Server Logs
Look for more detailed error messages in Tomcat logs:
- `catalina.out`
- `localhost.log`
- `localhost.YYYY-MM-DD.log`

## Quick Test
After rebuilding, test with a simple JSP:
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:out value="Test"/>
```

## Common Issues

1. **JAR not packaged**: Ensure dependency doesn't have `scope=provided`
2. **Version mismatch**: API and implementation versions must match
3. **Classloader issue**: Restart Tomcat completely
4. **Cached classes**: Clear Tomcat work directory

## Expected JARs in WEB-INF/lib
After build, you should see:
- `jakarta.servlet.jsp.jstl-api-3.0.0.jar`
- `jakarta.servlet.jsp.jstl-3.0.0.jar` (or similar implementation JAR)

## Next Steps
1. Rebuild the project: `mvn clean install`
2. Deploy the WAR file
3. Restart Tomcat
4. Test a JSP page with JSTL tags

If the issue persists, the Glassfish JSTL implementation may be incomplete. Consider using the Apache Taglibs implementation or checking for a newer version of the Glassfish JSTL.

